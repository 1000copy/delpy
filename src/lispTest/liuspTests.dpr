program liuspTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options 
  to use the console test runner.  Otherwise the GUI test runner will be used by 
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  TestuLang in 'TestuLang.pas',
  Odbc in '..\lisp\Odbc.pas',
  uCodeAnalyis in '..\lisp\uCodeAnalyis.pas',
  uDb in '..\lisp\uDb.pas',
  uFile in '..\lisp\uFile.pas',
  uLang in '..\lisp\uLang.pas',
  ulangException in '..\lisp\ulangException.pas',
  uMain in '..\lisp\uMain.pas' {fmLiusp},
  uNet in '..\lisp\uNet.pas',
  uParser in '..\lisp\uParser.pas',
  uString in '..\lisp\uString.pas';

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.

