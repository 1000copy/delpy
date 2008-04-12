
{$IFDEF LINUX}
{$DEFINE DUNIT_CLX}
{$ENDIF}
program ListTest;

uses
  TestFramework,
  GUITestRunner;

{$R *.res}

begin
  TGUITestRunner.runRegisteredTests;
end.
