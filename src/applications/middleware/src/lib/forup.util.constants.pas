unit forup.util.constants;

interface
uses System.Classes, System.SysUtils, System.StrUtils, System.Math, System.Masks;

const
  EMPTYSTRING = '';
  EMPTYDATE_BR = '  /  /    ';
  EMPTYDATETIME_BR = Concat(EMPTYDATE_BR,'   :  :  ');
  DEF_LIST_SEPARATOR = ',';
  RANGE_INFO = '..';
  _S = 'S';
  _N = 'N';
  INT_0 = 0;
  INT_1 = 1;
  _TRUE = 'TRUE';
  _FALSE = 'FALSE';
  _NULL = 'NULL';
  DB_CONVERT_ERROR = 'DBCE';
  SEPARATOR = ' ';


type
  TConnType = (ctNone, ctPostgreSQL, ctORACLE, ctSQLServer, ctMySQL, ctSQLite, ctFirebird);
  TDBtype = (tdChar, tdInteger, tdDate, tdDateTime, tdTime, tdReal,
    tdBoolean, tdPassword, tdBlob, tdImage, tdFile, tdOID);
  TExtraAction = (doNone, doInsert, doUpdate, doSelect, doValidate, doAll);
  TExtraActions = set of TExtraAction;


implementation



end.
