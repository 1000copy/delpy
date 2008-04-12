unit uFile;

interface
uses
  Classes,SysUtils,uLang ,uparser ;
type

  TlispFile = class(TLispPackageBase)
  private
    procedure GetFileList(Dir,Mask:String;var sl : TStringList);
    function FileList(l : TlispList) :TLispNode ;
  public
    function CallFunction(fnName:String;list: TLispList):TLispNode;override ;
    function GetName:String;override ;
    function GetTestSrc:String;override ;
  end;
var
  lispFile : TlispFile ;
implementation

{ TlispString }

function TlispFile.CallFunction(fnName: String;
  list: TLispList): TLispNode;
begin
  Result := nil ;
  if SameText(fnName ,'rfilelist') then
    Result := FileList(list);
end;

function TlispFile.FileList(l : TlispList): TLispNode;
var
  rs : string ;
  n1,n2 : TLispNode ;
  I : integer ;
  sl : TStringList;
  ll : TLispList ;
  n : TLispNode ;
begin
  rs := '' ;
  l.checkSizeEquals(3);
  n1 := l.nth(1).iEvaluate;
  n1.checkStr;
  n2 := l.nth(2).iEvaluate;
  n2.checkStr;
  sl := TStringList.Create;
  try
    GetFileList(n1.getStr,n2.getStr,sl);
    ll := TLispList.create (FLispLang);
    for i := 0 to sl.Count -1 do
      //ll.append(TLispNode.create(sl.Strings[i],nil,TT_STRING));
      ll.append(TLispNodeString.create(FLispLang,sl.Strings[i]));
  finally
    sl.Free ;
  end;
  //result := TLispNode.create('',ll,TT_LIST);
  result := TLispNodeList.create(FLispLang,ll);
end;
procedure TlispFile.GetFileList(Dir, Mask: String; var sl: TStringList);
  procedure RescureFiles(Dir, Mask: String);
  var
    SR: TSearchRec;
    FileMask, Path, s: string;
    i: Integer;
    SearchResult: Integer;
  begin
    FileMask := Dir + Mask ;
    SearchResult := SysUtils.FindFirst(FileMask, faAnyFile , SR);
    if SearchResult <> 0 then 
      Exit ;
    repeat
      if (SR.Name  = '.') or (SR.Name  = '..') then
        continue ;
      if (SR.Attr and faDirectory ) <>0 then begin
        RescureFiles(Dir+SR.Name+'\',Mask);
        continue ;
      end;
      s := Dir + SR.Name;
      sl.Add(s);
    until FindNext(SR) <> 0;
    SysUtils.FindClose(SR);
  end;
begin
  RescureFiles(Dir,Mask);
end;

function TlispFile.GetName: String;
begin
  Result := 'LispFile';
end;

function TlispFile.GetTestSrc: String;
begin
  Result := '(rfilelist (homedir) "*.pas")';
end;

initialization
finalization
//  作为接口，不再需要手工释放
//  lispString.Free ;
end.
