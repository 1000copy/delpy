unit uString;

interface
uses
  {forms,}SysUtils,uLang ,uparser ;
type

  TlispString = class(TLispPackageBase)
  private
    function constr(l : TlispList) :TLispNode ;
  public
    function CallFunction(fnName:String;list: TLispList):TLispNode;override ;
    function GetName:String;override ;
    function GetTestSrc:String;override ;
  end;
var
  lispString : TLispString ;
implementation

{ TlispString }

function TlispString.CallFunction(fnName: String;
  list: TLispList): TLispNode;
begin
  Result := nil ;
  if SameText(fnName ,'constr') then
    Result := constr(list);
end;

function TlispString.constr(l : TlispList): TLispNode;
var
  rs : string ;
  n : TLispNode ;
  I : integer ;
begin
  rs := '' ;
  for i :=  1 to l.size -1 do
  begin
    n := l.nth(i).iEvaluate;
    if n.isStr then
      rs := rs + n.getStr ;
  end;
  //result := TLispNode.create(rs,nil,TT_STRING);
  result := TLispNodeString.create(FLispLang,rs);
  //TForm.Create(nil).Show;
  //Sleep(10000);
end;
function TlispString.GetName: String;
begin
  Result := 'LispString';
end;

function TlispString.GetTestSrc: String;
begin
  Result := '(constr "Lisp" "String")';
end;

initialization
finalization
//  作为接口，不再需要手工释放
//  lispString.Free ;
end.
