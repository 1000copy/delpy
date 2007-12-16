program lisp;

uses
  Forms,
  uParser in 'uParser.pas',
  uMain in 'uMain.pas' {fmLiusp},
  uLang in 'uLang.pas',
  ulangException in 'ulangException.pas',
  uString in 'uString.pas',
  uNet in 'uNet.pas',
  uDb in 'uDb.pas',
  ODBC in 'odbc\Odbc.pas',
  uCodeAnalyis in 'uCodeAnalyis.pas',
  uFile in 'uFile.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmLiusp, fmLiusp);
  Application.Run;
end.
