from distutils.util import strtobool
import pandas as pd
import os
import pip
import platform
import traceback
from pyrfc import Connection

from src import (
  load_yml_env
)

def main():

  try:

    print(f'python: {platform.python_version()}')
    print(f'pip: {pip.__version__}')
    print('')

    # env

    load_yml_env('credentials/.env.yml')

    # check outdated

    if strtobool(os.environ['CHECK_REQUIREMENTS']):
      os.system('pip list --outdated > src/requirements-outdated.txt')

    # connect to sap

    print(f"HOST: {os.environ['SAP_HOST']}\n")
    sap_con = Connection(
      ashost=os.environ['SAP_HOST'],
      sysnr=os.environ['SAP_SYSNR'],
      client=os.environ['SAP_CLIENT'],
      user=os.environ['SAP_USER'],
      passwd=os.environ['SAP_PASS']
    )
    print('connected')
    
    # download data

    tablename = '/SCMB/TMFGT'
    delimiter = ';'

    print(f'  tablename: {tablename}')
    print('    downloading data')

    response = sap_con.call(
        func_name = 'Z_RFC_READ_TABLE',
        PFI_TABNAME = tablename,
        PFI_DELIMITER = delimiter,
        PFI_FIELDS = [
          {'FIELDNAME': 'MFRGR'},
          {'FIELDNAME': 'DESCR'}
        ],
        PFI_SELFIELDS = [
          {
            'FIELD': 'MFRGR',
            'SIGN': 'I',
            'OPTION': 'EQ',
            'LOW': 'CHILLED',
            'HIGH': ''
          }
        ]
      )

    df_data = pd.DataFrame(response['PFE_DATA'])
    df_data = df_data[0].str.split(delimiter, expand=True)
    df_table_structure = pd.DataFrame(response['PFE_TABLE_STRUCTURE'])
    df_data.columns = df_table_structure['FIELDNAME']

    df_data.to_csv(f'TMFGT.csv', index=False, sep=delimiter)

    print('')
    print('done')

  except Exception as e:
    print('  Error at main.py - main:', str(e))
    traceback.format_exc()

main()