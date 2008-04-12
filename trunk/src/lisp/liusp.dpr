program liusp;

{changelog
  OK 2004/11/11 ����cmdline��Ư���ĸ�ʽ����ӡ Print Beauty !
  �޸�lisplang.iprint,lispnode.iprint,lisplist.iprint �Ա���õĸ�ʽ����ӡ���ǳ�Ư��

  TD 2004/11/11 ����CreateTable����������ʵ��createtable.txt�ڵ�table������ͨ��odbc�ﵽ�����ݿ��޹ء�

}uses
  SysUtils,
  Classes,
  uDb in 'uDb.pas',
  uLang in 'uLang.pas',
  ulangException in 'ulangException.pas',
  uMain in 'uMain.pas' {Form1},
  uNet in 'uNet.pas',
  uParser in 'uParser.pas',
  uString in 'uString.pas',
  ODBC in 'odbc\Odbc.pas',
  uCodeAnalyis in 'uCodeAnalyis.pas',
  uFile in 'uFile.pas';

procedure Usage ;
Const Use = 'syntax : liusp -f/-l/-v filename.lsp';
begin
  WriteLn(Use);
end;
var
  i : Integer ;
  ListStr : String ;
begin
  {
  if ParamCount < 2 then
  begin
    Usage ;
    exit ;
  end;
  }
  ListStr := '';
  //LispLang := TLispLang.create;
  try
    if (ParamStr(1)='-f') then begin
      //FLispLang.EvalFile(ParamStr(2));
    end else if ParamStr(1)='-l' then  begin
      for i := 2 to ParamCount do
        //ListStr := ListStr + ParamStr(i);
        ListStr := Copy(CmdLine,Pos('-l',CmdLine)+2,length(CmdLine));
      //FLispLang.EvalStr(ListStr);
    end else if ParamStr(1)='-v' then  begin
      Usage
    end else while true do begin
      Write(#13#10'lisp console>>>');
      ReadLn(ListStr);
      //FLispLang.EvalStr(ListStr);
    end;
  finally
  //FLispLang.Free ;
  end;

end.
