unit uCodeAnalyis;
{
(= a (rfilelist (homedir) "*.pas"))
(= i 0 )

(repeat (len a)
  (do
     (= i (+ i 1))
     (print  (nth a i)  (loc (nth a i) true))
     (print "#10")
  )
)
}//
interface
uses
  classes ,SysUtils,uLang ,uparser ;
type
  ELispFileNotFound =class(Exception)
    constructor Create(fn :String);
  end;
  TLispCA = class(TLispPackageBase)
  private
    function GetLOC(N : String;IgnoreBlank:Boolean):Integer;
  private
    function LOC(l : TlispList) :TLispNode ;
  public
    function CallFunction(fnName:String;list: TLispList):TLispNode;override ;
    function GetName:String;override ;
    function GetTestSrc:String;override ;
  end;
var
  LispCA : TLispCA ;
implementation

{ TlispString }

function TLispCA.CallFunction(fnName: String;
  list: TLispList): TLispNode;
begin
  Result := nil ;
  if SameText(fnName ,'loc') then
    Result := LOC(list);
end;

function TLispCA.LOC(l : TlispList): TLispNode;
var
  n1,n2 : TLispNode ;
  I ,R: integer ;
begin
  l.checkSizeEquals(3);
  n1 := l.nth(1).iEvaluate;
  n1.checkStr ;
  n2 := l.nth(2).iEvaluate;
  n2.checkBool;
  //result := TLispNode.create(InttoStr(GetLoc(n1.getStr,n2.getBool)),nil,TT_INT);
  result := TLispNodeInt.create(FLispLang,InttoStr(GetLoc(n1.getStr,n2.getBool)));
end;
function TLispCA.GetName: String;
begin
  Result := 'LispCA';
end;

function TLispCA.GetTestSrc: String;
begin
  Result := '(loc "uCodeAnalyis.pas" true )';
end;

function TLispCA.GetLOC(N: String;IgnoreBlank:Boolean): Integer;
var
  Lines : TStringList ;
  K : integer ;
begin
  Lines := TStringList.Create;
  Result := -1 ;
  try
    try
    Lines.LoadFromFile(N);
    Result := Lines.Count;
    if IgnoreBlank then
    begin
      for k:=Lines.Count-1 downto 0 do
        if Lines[k]= '' then
          Dec(Result);
    end;
    except
      Raise  ELispFileNotFound.Create(N);
  end;
  finally
    Lines.Free ;
  end;
end;
constructor ELispFileNotFound.Create(fn: String);
begin
  inherited Create(Format('ELispFileNotFound,FileName=%s ',[fn]));
end;
initialization

end.
