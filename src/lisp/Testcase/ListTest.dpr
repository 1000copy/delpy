
{$IFDEF LINUX}
{$DEFINE DUNIT_CLX}
{$ENDIF}
program ListTest;

uses
  TestFramework,
{$IFDEF DUNIT_CLX}
  QGUITestRunner,
{$ELSE}
  GUITestRunner,
{$ENDIF}
  TListTestCase in 'TListTestCase.pas';

{$R *.res}

begin
  TGUITestRunner.runRegisteredTests;
end.
