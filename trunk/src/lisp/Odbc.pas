{
Version 0.11
You can use it

If you make modifications to it, send it back to me.
If these is useful to you, just send me an email.

written by pedro otoya gerdts
potoya@ctgred.net.co

A simple example

var
query1 : Todbcst;
.
.
.
try
   PSQLAllocEnv;
   PSQLAllocConnect;
   If PSQLConnect('AS400','potoya','password') = 0 Then
   Begin
      Try
         Query1 := Todbcst.Create;
         With Query1 do
         Begin
            Try
               Sql := 'SELECT * FROM TABLE1 ORDER BY ID,DATE';
               execute;
               While Next do
               Begin
                  v1 := cellstring(1);
                  v2 := cellstringbyname('ID');
                  v3 := cellintegerbyname('VAR1');
                  .
                  .
                  .etc,
               End;
            Except
               On Except E: Error_Odbc do
                  Detail('An error has occured, while executing the query');
            End;
         End;
      Finally
         Query1.Free;
      End;

   End;
Finally
   PSQLDisconnect;
   PSQLFreeConnect;
   PSQLFreeEnv;
End;

}

unit ODBC;
{$H+}

interface

uses
     Windows, Messages, SysUtils, Classes, Dialogs;

Const
gSQLSuccess = 0;
gSQLSuccessWithInfo = 1;
gSQLError = -1;

gSQLNoDataFound = 100;

gSQLClose = 0;
gSQLDrop = 1;
gSQLMaxMsgLen = 512;

gSQLChar = 1;

gSQLNTS = -3;
SQL_NTS = -3;

SQL_SQLSTATE_SIZE = 5;
SQL_MAX_MESSAGE_LENGTH = 512;
SQL_MAX_DSN_LENGTH = 32;

SQL_ERROR = -1;
SQL_INVALID_HANDLE = -2;
SQL_NO_DATA_FOUND = 100;
SQL_SUCCESS = 0;
SQL_SUCCESS_WITH_INFO = 1;

SQL_CLOSE = 0;
SQL_DROP  = 1;
SQL_UNBIND = 2;
SQL_RESET_PARAMS = 3;

Type
   Error_Odbc = class(Exception)
   private
       vMsg : string;
       vEstado : string;
       vNativo : integer;
       constructor Create(Msg: String; Estado : string; Nativo : integer); Virtual;
   public
       property Estado:string read vEstado;
       property Nativo:integer read vNativo;
       Procedure Detail(Msg:String);
   End;

   ElemString = String;
   Coldef = Record
       Ctipo, CStart, Clen : Word;
       Cname : Array[0..32] of Char;
   End;

   Astrings = Array[1..8192] of string;
   ArrString = Array[1..128] of Coldef;

   SqlAnswer = Record
        Ncols, Nrows, Rlen : Word;
   End;

   TOdbcSt = Class
   Private
      vPSql : string;
      vSql : string;
      vPreparada : Boolean;
      vEjecutada : Boolean;
      vColumnas : TstringList;
      vEof : Boolean;
      vBof : Boolean;
      vHstmt : integer;
      vinicializado : boolean;
      vret : smallint;
      vrow : integer;
      Procedure Put_Sql(Sql : String);
      Procedure Load_Fields;

   Public
      constructor Create; Virtual;
      destructor Destroy; override;
      Procedure Execute;
      Procedure Free;
      Procedure Close;

      Function First : Boolean;
      Function Next : Boolean;
      Function Prev : Boolean;
      Function Last : Boolean;

      Function CellInteger(i:integer): integer;
      Function CellString(i:integer): String;
      Function CellSingle(i:integer) : Single;
      Function NumbCols: Integer;
      Function CellIntegerByName(i:string): integer;
      Function CellStringByName(i:string): String;
      Function CellSingleByName(i:string) : Single;

      Property  Eof: Boolean read vEof;
      Property  Bof: Boolean read vBof;
      Property  Ret: Smallint read Vret;
      Property  Sql: String Read vSql Write Put_Sql;
   End;


Var  {Conexion A Odbc}
  Hadini : Boolean;
  Ghenv : Integer;
  Ghdbc : Integer;
  Ghstmt : Integer;
  Buffer : Array[0..1024] of Char;

{Declaración de Procedimientos Para Accesar ODBC}
Function SQLError( henv:Integer; hdbc:Integer; hstmt:Integer; szSqlState:PCHAR; var pfNativeError:Integer;  szErrorMsg:PCHAR;  cbErrorMsgMax:Smallint; var pcbErrorMsg:Smallint) :Smallint;stdcall; far;
Function SQLExecDirect( hstmt:Integer;  szSqlStr:PCHAR;  cbSqlStr:Integer) :Smallint;stdcall; far;
Function PSQLExecDirect(SqlStr:PCHAR) :Smallint;
Function SQLFetch( hstmt:Integer) :Smallint;stdcall; far;
Function PSQLFetch:Smallint;
Function SQLGetData(hstmt:Integer; icol:Smallint; fCType:Smallint; RGBValue:PCHAR; cbValueMax:Integer; var pcbValue:Integer):Smallint;stdcall;far;
Function PSQLGetData(icol:Smallint; fCType:Smallint; RGBValue:PCHAR; cbValueMax:Integer; var pcbValue:Integer):Smallint;
Function SQLFreeStmt( hstmt:Integer;  fOption:Smallint) :Smallint;stdcall; far;
Function PSQLFreeStmt(fOption:Smallint):Smallint;
Function SQLNumResultCols( hstmt:Integer; var pccol:Smallint) :Smallint;stdcall; far;
Function PSQLNumResultCols(var pccol:Smallint):Smallint;
Function SQLAllocConnect(henv:Integer; var phdbc:Integer):Smallint;stdcall;far;
Function SQLAllocEnv(var phenv:Integer):Smallint;stdcall;far;
Function SQLAllocStmt(hdbc:Integer; var phstmt:Integer):Smallint;stdcall;far;
Function SQLBindCol(hstmt:Integer; icol:Smallint; fCType:Smallint; var RGBValue:PCHAR; cbValueMax:Integer; var pcbValue:Integer):Smallint;stdcall;far;
Function SQLCancel(hstmt:Integer):Smallint;stdcall; far;
Function SQLColAttributes(hstmt:Integer; icol:Smallint; fDescType:Smallint; var rgbDesc: Pchar; cbDescMax:Smallint; var pcbDesc:Smallint; var pfDesc:Integer):Smallint;stdcall; far;
Function SQLColAttributesString(hstmt:Integer; icol:Smallint; fDescType:Smallint; rgbDesc:Pchar; cbDescMax:Smallint; var pcbDesc:Smallint; var pfDesc:Integer):Smallint;stdcall; far;
Function SQLConnect(hdbc:Integer; szDSN:PCHAR; cbDSN:Smallint; szUID:PCHAR; cbUID:Smallint; szAuthStr:PCHAR; cbAuthStr:Smallint) :Smallint;stdcall; far;
Function PSQLConnect(szDSN:PCHAR; szUID:PCHAR; szAuthStr:PCHAR) :Smallint;
Function SQLDriverConnect(hdbc:Integer; vhwnd:HWND; szConstr:PCHAR; cbConstr:Smallint; szconstrout:PCHAR; cbconstrout:Smallint; var pcbconstrout:smallint; fdrivercompletion: integer) :Smallint;far;
Function SQLDescribeCol( hstmt:Integer;  icol:Smallint;  szColName:PCHAR;  cbColNameMax:Smallint; var pcbColName:Smallint; var pfSqlType:Smallint; var pcbColDef:Integer; var pibScale:Smallint; var pfNullable:Smallint) :Smallint;stdcall; far;
Function SQLDisconnect( hdbc:Integer) :Smallint;stdcall; far;
Function SQLExecute( hstmt:Integer) :Smallint;stdcall; far;
Function SQLFreeConnect( hdbc:Integer) :Smallint;stdcall; far;
Function SQLFreeEnv( henv:Integer) :Smallint;stdcall; far;
Function SQLGetCursorName( hstmt:Integer;  szCursor:PCHAR;  cbCursorMax:Smallint; var pcbCursor:Smallint) :Smallint;stdcall; far;
Function SQLPrepare( hstmt:Integer;  szSqlStr:PCHAR;  cbSqlStr:Integer) :Smallint;stdcall; far;
Function SQLRowCount( hstmt:Integer; var pcrow:Integer):Smallint;stdcall; far;
Function PSQLRowCount(var pcrow:Integer):Smallint;
Function SQLSetCursorName( hstmt:Integer;  szCursor:PCHAR;  cbCursor:Smallint) :Smallint;stdcall; far;
Function SQLSetParam( hstmt:Integer;  ipar:Smallint;  fCType:Smallint;  fSqlType:Smallint;  cbColDef:Integer;  ibScale:Smallint; var RGBValue:PCHAR; var pcbValue:Integer) :Smallint;stdcall; far;
Function SQLTransact( henv:Integer;  hdbc:Integer;  fType:Smallint) :Smallint;stdcall; far;
Function PSQLAllocEnv:Smallint;
Function PSQLFreeEnv:Smallint;
Function PSQLAllocConnect:Smallint;
Function PSQLDisconnect:Smallint;

Function PSQLFreeConnect:Smallint;
Function PSQLError(tipo:char):Smallint;
Function PSQLErrormsg(tipo:char):String;
Function SQLErrormsg(ghstmt:integer; tipo:char):String;
Function SQLErrormsgPlus(ghstmt: integer; tipo:char; Var State:String; Var Nativo: integer):String;

Procedure SetAutoCommit(Sw : Boolean);
Function CommitTran :Smallint;
Function RollBackTran :Smallint;

implementation

Function SQLError(henv:Integer;  hdbc:Integer;  hstmt:Integer;  szSqlState:PCHAR; var pfNativeError:Integer;  szErrorMsg:PCHAR;  cbErrorMsgMax:Smallint; var pcbErrorMsg:Smallint) :Smallint;far;external 'odbc32.dll';
Function SQLExecDirect( hstmt:Integer;  szSqlStr:PCHAR;  cbSqlStr:Integer) :Smallint;far;external 'odbc32.dll';
Function SQLFetch(hstmt:Integer) :Smallint;far;external 'odbc32.dll';
Function SQLGetData(hstmt:Integer; icol:Smallint; fCType:Smallint; RGBValue:PCHAR; cbValueMax:Integer; var pcbValue:Integer):Smallint;far;external 'odbc32.dll';
Function SQLFreeStmt(hstmt:Integer;  fOption:Smallint) :Smallint;far;external 'odbc32.dll';
Function SQLNumResultCols(hstmt:Integer; var pccol:Smallint) :Smallint;far;external 'odbc32.dll';

Function SQLAllocConnect(henv:Integer; var phdbc:Integer):Smallint;far;External 'odbc32.dll';
Function SQLAllocEnv(var phenv:Integer):Smallint;far;external 'odbc32.dll';
Function SQLAllocStmt(hdbc:Integer; var phstmt:Integer):Smallint;far;external 'odbc32.dll';
Function SQLBindCol(hstmt:Integer; icol:Smallint; fCType:Smallint; var RGBValue:PCHAR; cbValueMax:Integer; var pcbValue:Integer):Smallint;far;external 'odbc32.dll';
Function SQLCancel(hstmt:Integer):Smallint; far; External 'odbc32.dll';

Function SQLColAttributes(hstmt:Integer; icol:Smallint; fDescType:Smallint; var rgbDesc: Pchar; cbDescMax:Smallint; var pcbDesc:Smallint; var pfDesc:Integer):Smallint;far;external 'odbc32.dll';
Function SQLColAttributesString(hstmt:Integer; icol:Smallint; fDescType:Smallint; rgbDesc:Pchar; cbDescMax:Smallint; var pcbDesc:Smallint; var pfDesc:Integer):Smallint;far;external 'odbc32.dll';

Function SQLConnect(hdbc:Integer; szDSN:PCHAR; cbDSN:Smallint; szUID:PCHAR; cbUID:Smallint; szAuthStr:PCHAR; cbAuthStr:Smallint) :Smallint;far;external 'odbc32.dll';
Function SQLDriverConnect(hdbc:Integer; vhwnd:HWND; szConstr:PCHAR; cbConstr:Smallint; szconstrout:PCHAR; cbconstrout:Smallint; var pcbconstrout:smallint; fdrivercompletion: integer) :Smallint;far;external 'odbc32.dll';
Function SQLDescribeCol(hstmt:Integer; icol:Smallint; szColName:PCHAR; cbColNameMax:Smallint; var pcbColName:Smallint; var pfSqlType:Smallint; var pcbColDef:Integer; var pibScale:Smallint; var pfNullable:Smallint) :Smallint;far;external 'odbc32.dll';

Function SQLDisconnect( hdbc:Integer) :Smallint;far;external 'odbc32.dll';

Function SQLExecute( hstmt:Integer) :Smallint;far;external 'odbc32.dll';
Function SQLFreeConnect( hdbc:Integer) :Smallint;far;external 'odbc32.dll';
Function SQLFreeEnv( henv:Integer) :Smallint;far;external 'odbc32.dll';
Function SQLGetCursorName( hstmt:Integer;  szCursor:PCHAR;  cbCursorMax:Smallint; var pcbCursor:Smallint) :Smallint;far;external 'odbc32.dll';
Function SQLPrepare( hstmt:Integer;  szSqlStr:PCHAR;  cbSqlStr:Integer) :Smallint;far;external 'odbc32.dll';

Function SQLRowCount( hstmt:Integer; var pcrow:Integer) :Smallint; far;external 'odbc32.dll';

Function SQLSetCursorName( hstmt:Integer;  szCursor:PCHAR;  cbCursor:Smallint) :Smallint;far;external 'odbc32.dll';
Function SQLSetParam( hstmt:Integer;  ipar:Smallint;  fCType:Smallint;  fSqlType:Smallint;  cbColDef:Integer;  ibScale:Smallint; var RGBValue:PCHAR; var pcbValue:Integer) :Smallint;far;external 'odbc32.dll';
Function SQLTransact(henv:Integer;  hdbc:Integer;  fType:Smallint) :Smallint;far;external 'odbc32.dll';


// *------------------------------------------------------------------------*//


constructor Error_Odbc.Create(Msg: String; Estado : string; Nativo : integer);
Begin
   vMsg := Msg;
   vEstado := Estado;
   vNativo := Nativo;
   inherited Create(Msg);
End;

Procedure Error_odbc.Detail(Msg: String);
Begin
   MessageDlg('ODBC Error State: ' + vEstado + ', Nativo: '+inttostr(vnativo) + #13 + Msg + #13 + vMsg, mtError, [mbOk], 0);
End;


// *------------------------------------------------------------------------*//



constructor TOdbcst.Create;
Begin
   vSql := '';
   vPSql := '';
   vColumnas := TstringList.Create;
   vret := 0;
   vEof := True;
   vEjecutada := False;
   vinicializado := False;
End;

destructor TOdbcst.Destroy;
Begin
   vSql := '';
   vPSql := '';
   Vcolumnas.Free;
   inherited;
End;

Procedure TOdbcst.Put_Sql(Sql : String);
Begin
   Vejecutada := False;
   Vpreparada := False;
   vSql := Sql;
End;

Procedure TOdbcst.Execute;
Var
Texto : Pchar;
Estado : String;
Nativo : integer;
Msg : String;
Begin
   SQLFreeStmt(vhstmt, 0);
      vhstmt := 0;
      Vret := SQLAllocStmt(ghdbc, vhstmt);
      If vRet < 0 Then
      Begin
         Msg := SQLErrormsgplus(vHstmt, 'S', Estado, Nativo);
         raise Error_Odbc.Create(Msg, Estado, Nativo);
      End
      Else
      Begin
         Texto := Pchar(vSql);
         Vret := SQLExecDirect(vhstmt, Texto, StrLen(Texto));
         vEof := False;
         vBof := True;
         Vejecutada := False;
         vrow := 0;
         If Vret <> 0 Then
         Begin
            Msg := SQLErrormsgplus(vHstmt, 'S', Estado, Nativo);
            if (Nativo <> 100) Then
            Begin
               raise Error_Odbc.Create(Msg, Estado, Nativo);
               vBof := False;
            End
         End
         Else
            Vejecutada := True;
      End;
End;

Function Todbcst.First : Boolean;
Begin
   inc(vrow);
   if vRow = 1 Then // Primer Registro
   Begin
      Vret := SQLFetch(vHstmt);
      vEof := (Vret <> 0);
   End;
   Result := (Vret = 0);
End;

Function Todbcst.Next : Boolean;
Begin
   inc(vrow);
   Vret := SQLFetch(vHstmt);
   vEof := (Vret <> 0);
   Result := (Vret = 0);
End;

Function Todbcst.Prev : Boolean;
Begin
   Result := False;
End;

Function Todbcst.Last : Boolean;
Begin
   Result := False;
End;

Function Todbcst.CellInteger(i:integer): integer;
Var
    Ss : Array[0..32] of Char;
    N : Integer;
Begin
   If Vejecutada Then
   Begin
      If vBof Then First;
      Fillchar(Ss, Sizeof(Ss), 0);
      N := 0;
      SQLGetData(vHstmt, i, gSQLCHAR, Ss, 32, N);
      If N > 0 Then
      Begin
         Try
            Result := strtoint(Strpas(Ss));
         Except
            Result := 0;
         End;
      End
      Else
         Result := 0;
   End
   Else
      raise Error_Odbc.Create('Query, no retorna Registros', 'S1000', 100);
End;

Function Todbcst.CellString(i:integer): String;
Var
    Ss : Array[0..255] of Char;
    N : Integer;
Begin
   If Vejecutada Then
   Begin
      If vBof Then First;
      Fillchar(Ss, Sizeof(Ss), 0);
      N := 0;
      SQLGetData(vHstmt, i, gSQLCHAR, Ss, 255, N);
      If N > 0 Then
         Result := Strpas(Ss)
      Else
         Result := '';
   End
   Else
      raise Error_Odbc.Create('Query, no retorna Registros', 'S1000', 100);
End;

Function Todbcst.CellSingle(i:integer) : Single;
Var
   Ss : Array[0..32] of Char;
   N : Integer;
Begin
   If Vejecutada Then
   Begin
      If vBof Then First;
      Fillchar(Ss, Sizeof(Ss), 0);
      N := 0;
      SQLGetData(vHstmt, i, gSQLCHAR, Ss, 32, N);
      If N > 0 Then
      Begin
         Try
            Result := strtofloat(Strpas(Ss));
         Except
            Result := 0;
         End;
      End
      Else
         Result := 0; // Null
   End
   Else
      raise Error_Odbc.Create('Query, no retorna Registros', 'S1000', 100);
End;

Procedure TodbcSt.Free;
Begin
   SQLFreeStmt(vhstmt, 0);
   Destroy;
End;

Procedure TodbcSt.Close;
Begin
   If vEjecutada Then
   Begin
      vColumnas.Clear;
      vSql := '';
      vPSql := '';
      vEjecutada := false;
      SQLFreeStmt(vhstmt, 0);
      vhstmt := 0;
   End;
End;

Procedure TodbcSt.Load_Fields;
Var
   szColName : Array[0..256] of char;
   cbColNameMax:Smallint;
   pcbColName:Smallint;
   pfSqlType:Smallint;
   pcbColDef:Integer;
   pibScale:Smallint;
   pfNullable:Smallint;
   nf : smallint;
   i : integer;
Begin
   SQLNumResultCols( vHstmt, nf);
   cbColNameMax := 255;

   if nf >= 1 Then
      for i := 1 to nf do
      Begin
         SQLDescribeCol(vHstmt, i, szColName, cbColNameMax, pcbColName, pfSqlType, pcbColDef, pibScale, pfNullable);
         vColumnas.Add(UpperCase(StrPas(szColName)));
      End;
End;

Function TodbcSt.CellIntegerByName(i:string): integer;
Var
  n : integer;
Begin
   If Not vEjecutada Then
   Begin
      raise Error_Odbc.Create('Error CellintegerByName(1), Campo Inexistente ' + i,'',0);
   End
   Else
   Begin
      if vColumnas.Count = 0 Then Load_Fields;
      n := Vcolumnas.IndexOf(i) + 1;
      if n > 0 Then
         result := Cellinteger(n)
      else
         raise Error_Odbc.Create('Error CellintegerByName(2), Campo Inexistente ' + i,'',0);
   End;
End;

Function TodbcSt.CellStringByName(i:string): String;
Var
  n : integer;
Begin
   If Not vEjecutada Then
   Begin
      //Raise Error_Odbc(PSQLErrormsg('C'));
      raise Error_Odbc.Create('Error CellStringByName(1), Campo Inexistente ' + i,'',0);
   End
   Else
   Begin
      if vColumnas.Count = 0 Then Load_Fields;
      n := Vcolumnas.IndexOf(i) + 1;
      if n > 0 Then
         result := Cellstring(n)
      else
         raise Error_Odbc.Create('Error CellStringByName(2), Campo Inexistente ' + i,'',0);;
   End;
End;

Function TodbcSt.CellSingleByName(i:string) : Single;
Var
  n : integer;
Begin
   If Not vEjecutada Then
   Begin
      //Raise Error_Odbc(PSQLErrormsg('C'));
      raise Error_Odbc.Create('Error CellSingleByName(1), Campo Inexistente ' + i,'',0);
   End
   Else
   Begin
      if vColumnas.Count = 0 Then Load_Fields;
      n := Vcolumnas.IndexOf(i) + 1;
      if n > 0 Then
         result := CellSingle(n)
      else
         raise Error_Odbc.Create('Error CellSingleByName(2), Campo Inexistente ' + i,'',0);;
   End;
End;


//*-------------------------------------------------------------------------*//


Procedure SetAutoCommit(Sw : Boolean);
Var
   I : integer;
Begin
   I := 1;
End;

Function CommitTran :Smallint;
Var
   Msg : String;
   Estado : String;
   Nativo : integer;
Begin
   if SQLTransact(ghenv, ghdbc, 1) <> 0 Then // ? ftype
   Begin
      Msg := SQLErrormsgplus(0, 'C', Estado, Nativo);
      raise Error_Odbc.Create(Msg, Estado, Nativo);
   End;
End;

Function RollBackTran :Smallint;
Var
   Msg : String;
   Estado : String;
   Nativo : integer;
Begin
   if SQLTransact(ghenv, ghdbc, 2) <> 0 Then // ? ftype
   Begin
      Msg := SQLErrormsgplus(0, 'C', Estado, Nativo);
      raise Error_Odbc.Create(Msg, Estado, Nativo);
   End;
End;

Function PSQLExecDirect(SqlStr:PCHAR) :Smallint;
Begin
   PSQLExecDirect := SQLExecDirect(Ghstmt,SqlStr,StrLen(SqlStr));
End;

Function PSQLFetch:Smallint;
Begin
    PSQLFetch := SQLFetch(Ghstmt)
End;

Function PSQLFreeStmt(fOption:Smallint):Smallint;
Begin
    PSQLFreeStmt := SQLFreeStmt(Ghstmt,fOption);
End;

Function PSQLGetData(icol:Smallint; fCType:Smallint; RGBValue:PCHAR; cbValueMax:Integer; var pcbValue:Integer):Smallint;
Begin
   PSQLGetData := SQLGetData(Ghstmt,icol,fCType,RGBValue,cbValueMax,pcbValue);
End;

Function PSQLNumResultCols(var pccol:Smallint):Smallint;
Begin
   PSQLNumResultCols:=SQLNumResultCols(Ghstmt,pccol);
End;

Function PSQLRowCount(var pcrow:Integer) :Smallint;
Begin
    PSQLRowCount := SQLRowCount(Ghstmt,pcrow);
End;

Function PSQLAllocEnv:Smallint;
Begin
    PSQLAllocEnv := SQLAllocEnv(Ghenv);
End;

Function PSQLFreeEnv:Smallint;
Begin
   PSQLFreeEnv := SQLFreeEnv(Ghenv);
End;

Function PSQLAllocConnect:Smallint;
Begin
   PSQLAllocConnect := SQLAllocConnect(ghenv,ghdbc);
End;

Function PSQLFreeConnect:Smallint;
Begin
   PSQLFreeConnect := SQLFreeConnect(ghdbc);
End;

Function PSQLDisconnect: smallint;
Begin
   Result := SQLDisconnect(ghdbc);
End;

Function PSQLConnect(szDSN:PCHAR; szUID:PCHAR; szAuthStr:PCHAR) :Smallint;
Begin
    PSQLConnect := 0;
    if SQLConnect(ghdbc,szDSN,SQL_NTS,szUID,SQL_NTS,szAuthStr,SQL_NTS) = SQL_ERROR then
    begin
       PSQLError('C');
       PSQLConnect := -1;
    end;
    //else
    //   if SQLAllocStmt(ghdbc,ghstmt) <> 0 then
    //   begin
    //      PSQLError('C');
    //      PSQLConnect := -2
    //   end;
End;

Function PSQLError(tipo:char):Smallint;
Var
szSqlState:ARRAY[0..8] OF CHAR;
pfNativeError:Integer;
szErrorMsg:ARRAY[0..256] OF CHAR;
cbErrorMsgMax:Smallint;
pcbErrorMsg:Smallint;

Begin
   case Tipo of
      'S' : SQLError(0,0,ghstmt,szSqlState,pfNativeError,szErrorMsg,256,pcbErrorMsg);
      'C' : SQLError(0,ghdbc,0,szSqlState,pfNativeError,szErrorMsg,256,pcbErrorMsg);
      'E' : SQLError(ghenv,0,0,szSqlState,pfNativeError,szErrorMsg,256,pcbErrorMsg);
   End;
   PSQLError := pfNativeError;
   (*MessageBox(null,PCHAR(Format('Error %d %s', [pfNativeError,szErrorMsg])),'Error ODBC',IDOK);*)
   ShowMessage(Format('Error %d %s', [pfNativeError,szErrorMsg]));
End;

Function PSQLErrormsg(tipo:char):String;
Var
szSqlState:ARRAY[0..8] OF CHAR;
pfNativeError:Integer;
szErrorMsg:ARRAY[0..256] OF CHAR;
cbErrorMsgMax:Smallint;
pcbErrorMsg:Smallint;
Begin
   case Tipo of
      'S' : if Ghstmt <> 0 then
               SQLError(0,0,ghstmt,szSqlState,pfNativeError,szErrorMsg,256,pcbErrorMsg)
            else
               szErrorMsg := 'hstmt - Ejecución Invalida';

      'C' : if ghdbc <> 0 then
               SQLError(0,ghdbc,0,szSqlState,pfNativeError,szErrorMsg,256,pcbErrorMsg)
            else
               szErrorMsg := 'hdbc - Comunicación Invalida';

      'E' : if ghenv <> 0 then
               SQLError(ghenv,0,0,szSqlState,pfNativeError,szErrorMsg,256,pcbErrorMsg)
            else
               szErrorMsg := 'henv - Memoria Invalida';
   End;
   PSQLErrormsg := string(szErrorMsg);
End;

Function SQLErrormsg(ghstmt: integer; tipo:char):String;
Var
szSqlState:ARRAY[0..8] OF CHAR;
pfNativeError:Integer;
szErrorMsg:ARRAY[0..256] OF CHAR;
cbErrorMsgMax:Smallint;
pcbErrorMsg:Smallint;
Begin
   case Tipo of
      'S' : if Ghstmt <> 0 then
               SQLError(0,0,ghstmt,szSqlState,pfNativeError,szErrorMsg,256,pcbErrorMsg)
            else
               szErrorMsg := 'hstmt - Ejecución Invalida';

      'C' : if ghdbc <> 0 then
               SQLError(0,ghdbc,0,szSqlState,pfNativeError,szErrorMsg,256,pcbErrorMsg)
            else
               szErrorMsg := 'hdbc - Comunicación Invalida';

      'E' : if ghenv <> 0 then
               SQLError(ghenv,0,0,szSqlState,pfNativeError,szErrorMsg,256,pcbErrorMsg)
            else
               szErrorMsg := 'henv - Memoria Invalida';
   End;
   SQLErrormsg := string(szErrorMsg);
End;

Function SQLErrormsgPlus(ghstmt: integer; tipo:char; Var State:String; Var Nativo: integer):String;
Var
szSqlState:ARRAY[0..8] OF CHAR;
pfNativeError:Integer;
szErrorMsg:ARRAY[0..256] OF CHAR;
cbErrorMsgMax:Smallint;
pcbErrorMsg:Smallint;
Begin
   case Tipo of
      'S' : if Ghstmt <> 0 then
               SQLError(0,0,ghstmt,szSqlState,pfNativeError,szErrorMsg,256,pcbErrorMsg)
            else
               szErrorMsg := 'hstmt - Ejecución Invalida';

      'C' : if ghdbc <> 0 then
               SQLError(0,ghdbc,0,szSqlState,pfNativeError,szErrorMsg,256,pcbErrorMsg)
            else
               szErrorMsg := 'hdbc - Comunicación Invalida';

      'E' : if ghenv <> 0 then
               SQLError(ghenv,0,0,szSqlState,pfNativeError,szErrorMsg,256,pcbErrorMsg)
            else
               szErrorMsg := 'henv - Memoria Invalida';
   End;
   State := Strpas(szSqlState);
   Nativo := pfNativeError;
   SQLErrormsgplus := string(szErrorMsg);
End;


function TOdbcSt.NumbCols: Integer;
var
 nf : smallint ;
begin
  SQLNumResultCols( vHstmt, nf);
  result := nf ;
end;

initialization
  Ghenv := 0;
  Ghdbc := 0;
  Ghstmt := 0;

{
Finalization
   SQLFreeEnv(Genv)
}
end.

