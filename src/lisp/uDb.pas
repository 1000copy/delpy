unit uDb;

interface    //
uses ulang ,uparser,SysUtils;
type
  TLispDb = class(TLispPackageBase)
  private
    function ldbQuery(lispNodes : TLispList) : TlispNode ;
    function ldbUpdate(lispNodes : TLispList) : TlispNode ;
  public
    function CallFunction(fnName: String;list: TLispList): TLispNode;override ;
    function GetName:String;override ;
    function GetTestSrc:String;override ;
  end;
var
  LispDb : TLispDb;
implementation

uses odbc,ulangException ;
function dbupdate(aDsn ,aSql : string ;password:string ='';username:string =''):TLispNode;
var
query1 : Todbcst;
begin
 try
   PSQLAllocEnv;
   PSQLAllocConnect;
   If PSQLConnect(pchar(aDsn),'','') = 0 Then
   Begin
      Try
         Query1 := Todbcst.Create;
         With Query1 do
         Begin
            Try
               Sql := asql;
               execute;
            Except
               On E: Error_Odbc do
                  ;
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
 RESULT := TlispNode.create ('',nil,TT_TRUE)
end;
function dbquery(aDsn ,aSql : string ; password:string ='';username:string =''): TLispNode;
var
query1 : Todbcst;
i : integer ;
r : TLispNode ;
rl ,rl1: TLispList ;
begin
 try
   PSQLAllocEnv;
   PSQLAllocConnect;
   If PSQLConnect(pchar(aDsn),'','') = 0 Then
   Begin
      Try
         Query1 := Todbcst.Create;
         With Query1 do
         Begin
            Try
               Sql := asql;
               execute;
               //  table -
               rl := TLispList.create ;
               While Next do
               Begin
                 //  table -
                 rl1 := TLispList.create ;
                 for i :=1 to NumbCols do
                   //form1.caption := form1.caption + cellstring(i) ;
                 begin
                   rl1.append(TLispNode.create (cellstring(i),nil,TT_STRING));
                 end;
               End;
               rl.append (TLispNode.Create('',rl1,TT_LIST));
            Except
               On E: Error_Odbc do
                  ;
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
 result := TLispNode.Create('',rl1,TT_LIST);
end;


{ TLispDb }

function TLispDb.ldbQuery(lispNodes: TLispList): TlispNode;
var
  aDsn ,aSql : string ;
  password:string ;username:string ;
  lispNode : TLispNode ;
begin
 if ((lispnodes.size <> 3) and (lispnodes.size <> 5)) then
   raise   ELispParameterSize.Create ;
 lispNode := lispNodes.nth(1).iEvaluate;
 if not lispNode.isStr then
   raise ELispParameterTypeNotMatch.Create
 else  aDsn := lispNode.getStr ;
 lispNode := lispNodes.nth(2).iEvaluate;
 if not lispNode.isStr then
   raise ELispParameterTypeNotMatch.Create
 else  aSql := lispNode.getStr ;
 if (lispnodes.size = 5) then
 begin
   lispNode := lispNodes.nth(3).iEvaluate;
   if not lispNode.isStr then
     raise ELispParameterTypeNotMatch.Create
   else  username := lispNode.getStr ;
   //
   lispNode := lispNodes.nth(4).iEvaluate;
   if not lispNode.isStr then
     raise ELispParameterTypeNotMatch.Create 
   else  password := lispNode.getStr ;
 end;
 result := dbquery (adsn,asql,username,password);
end;

function TLispDb.ldbUpdate(lispNodes: TLispList): TlispNode;
var
  aDsn ,aSql : string ;
  password:string ;username:string ;
  lispNode : TLispNode ;
begin
 if not ((lispnodes.size = 3) or (lispnodes.size = 5)) then
   raise   ELispParameterSize.Create ;
 lispNode := lispNodes.nth(1).iEvaluate;
 if not lispNode.isStr then
   raise ELispParameterTypeNotMatch.Create 
 else  aDsn := lispNode.getStr ;
 lispNode := lispNodes.nth(2).iEvaluate;
 if not lispNode.isStr then
   raise ELispParameterTypeNotMatch.Create
 else  aSql := lispNode.getStr ;
 if (lispnodes.size = 5) then
 begin
   lispNode := lispNodes.nth(3).iEvaluate;
   if not lispNode.isStr then
     raise ELispParameterTypeNotMatch.Create
   else  username := lispNode.getStr ;
   //
   lispNode := lispNodes.nth(4).iEvaluate;
   if not lispNode.isStr then
     raise ELispParameterTypeNotMatch.Create 
   else  password := lispNode.getStr ;
 end;
  result := dbUpdate (adsn,asql,username,password);
end;
function TLispDb.CallFunction(fnName: String;list: TLispList): TLispNode;
begin
  Result := nil ;
  if SameText(fnName ,'dbQuery') then
    Result := ldbQuery(list)
  else if SameText(fnName ,'dbUpdate') then
    Result := ldbUpdate(list);
end;


function TLispDb.GetName: String;
begin
  Result := 'LispDb';
end;

function TLispDb.GetTestSrc: String;
begin
  Result := '(quote ("Not yet"))';
end;

initialization
 LispDb := TLispDb.Create ;
 lispLang.RegisterPackage(LispDb);
end.
