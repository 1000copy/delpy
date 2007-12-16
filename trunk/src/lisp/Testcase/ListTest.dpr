program ListTest;
uses  TestFramework,
  GUITestRunner,
  TextTestRunner,
  TListTestCase1 in 'TListTestCase1.pas',
  tcLang in 'tcLang.pas';

{$R *.res}

begin
  TGUITestRunner.runRegisteredTests;  //TextTestRunner.runRegisteredTests;

end.
