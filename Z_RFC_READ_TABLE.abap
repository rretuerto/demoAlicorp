FUNCTION Z_RFC_READ_TABLE.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(PFI_TABNAME) TYPE  DD02L-TABNAME
*"     VALUE(PFI_DELIMITER) TYPE  CHAR1 DEFAULT '|'
*"     VALUE(PFI_SELFIELDS) TYPE  UASE16N_SELTAB_T OPTIONAL
*"     VALUE(PFI_FIELDS) TYPE  FIELDNAME_TABLE OPTIONAL
*"  EXPORTING
*"     VALUE(PFE_TABLE_STRUCTURE) TYPE  DFIES_TABLE
*"     VALUE(PFE_DATA) TYPE  ACO_TT_STRING
*"  EXCEPTIONS
*"      TABLE_NOT_AVAILABLE
*"      TABLE_WITHOUT_DATA
*"      FIELD_NOT_VALID
*"      NOT_AUTHORIZED
*"----------------------------------------------------------------------
  DATA: lt_where        TYPE STANDARD TABLE OF string,
        lt_table_struct TYPE dfies_table,
        lv_table_type   TYPE dd02v-tabclass,
        lv_campo        TYPE string.

  DATA: ref_tab TYPE REF TO data.
  FIELD-SYMBOLS: <lf_table>     TYPE table,
                 <lf_dfies>     TYPE dfies,
                 <lf_dfies_aux> TYPE dfies,
                 <lf_field>     TYPE sfldname,
                 <lf_comp>      TYPE any,
                 <lf_line>      TYPE any,
                 <lf_data>      LIKE LINE OF pfe_data.

  CALL FUNCTION 'DDIF_FIELDINFO_GET'
    EXPORTING
      tabname        = pfi_tabname
    IMPORTING
      ddobjtype      = lv_table_type
    TABLES
      dfies_tab      = lt_table_struct
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
  IF sy-subrc <> 0.
    RAISE table_not_available.
  ENDIF.
  IF lv_table_type = 'INTTAB'.
    RAISE table_without_data.
  ENDIF.

**** { ADD CMV 21.01.2022

  AUTHORITY-CHECK OBJECT 'S_TABU_NAM'
              ID 'ACTVT'     FIELD '03'
              ID 'TABLE'     FIELD PFI_TABNAME.

  IF sy-subrc NE 0.
    RAISE NOT_AUTHORIZED.
  ENDIF.
**** } ADD CMV 21.01.2022

  CALL FUNCTION 'SE16N_CREATE_SELTAB'
    TABLES
      lt_sel   = pfi_selfields
      lt_where = lt_where.

  CREATE DATA ref_tab TYPE TABLE OF (pfi_tabname).
  ASSIGN ref_tab->* TO <lf_table>.

  SELECT * FROM (pfi_tabname) INTO TABLE <lf_table> WHERE (lt_where).
  IF sy-subrc IS INITIAL.
    IF pfi_fields IS INITIAL.
      pfe_table_structure = lt_table_struct.
    ELSE.
      LOOP AT pfi_fields ASSIGNING <lf_field>.
        READ TABLE lt_table_struct ASSIGNING <lf_dfies_aux>
        WITH KEY fieldname = <lf_field>-fieldname.
        IF sy-subrc IS INITIAL.
          APPEND INITIAL LINE TO pfe_table_structure ASSIGNING <lf_dfies>.
          <lf_dfies> = <lf_dfies_aux>.
        ELSE.
          RAISE field_not_valid.
        ENDIF.
      ENDLOOP.
    ENDIF.

    CHECK pfe_table_structure IS NOT INITIAL.
    LOOP AT <lf_table> ASSIGNING <lf_line>.
      APPEND INITIAL LINE TO pfe_data ASSIGNING <lf_data>.

      LOOP AT pfe_table_structure ASSIGNING <lf_dfies>.
        CLEAR lv_campo.
        ASSIGN COMPONENT <lf_dfies>-fieldname
        OF STRUCTURE <lf_line> TO <lf_comp>.
        lv_campo = <lf_comp>.
        CONDENSE lv_campo.

        IF sy-tabix EQ 1.
          <lf_data> = lv_campo.
        ELSE.
          CONCATENATE <lf_data>
                      lv_campo
          INTO <lf_data> SEPARATED BY pfi_delimiter.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ELSE.
    RAISE no_data.
  ENDIF.

ENDFUNCTION.