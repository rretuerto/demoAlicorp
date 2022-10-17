# man-tm-ewm-pyrfc-demo

# Tabla de Contenido

1. [Resumen](#resumen)
2. [Ejecución](#ejecución)
3. [Función RFC](#función-rfc)

## Resumen

[(Volver al Inicio)](#tabla-de-contenido)

El proyecto presenta una demostración simplificada del uso de PyRFC para descargar información desde tablas de SAP TM/EWM.

## Ejecución

[(Volver al Inicio)](#tabla-de-contenido)

Puede correr la demo ejecutando el siguiente comando:

```
make local
```
Véase [Makefile](Makefile)

<br>
Nota: Es necesario tener instalado Docker https://docs.docker.com/engine/install/

## Función RFC

[(Volver al Inicio)](#tabla-de-contenido)

Para la extracción de información de S/4 Hana, fue necesario el despliegue de la función **Z_RFC_READ_TABLE** en el sistema SAP.

**Z_RFC_READ_TABLE** recibe los siguientes parámetros:

| Nombre        | Descripción                           |
|---------------|---------------------------------------|
| PFI_TABNAME      | Nombre de tabla                       |
| PFI_DELIMITER  | Delimitador                           |
| PFI_FIELDS  | Filtro de columnas                    |
| PFI_SELFIELDS     | Filtro de filas                       |

Y devuelve los siguientes datos:

| Nombre              | Descripción |
|---------------------|-------------|
| PFE_TABLE_STRUCTURE  | Metadata    |
| PFE_DATA             | Data        |

Para más detalle, puede visitar la función usando la transacción **SE37** del sistema SAP que se esté utilizando. <br>