program delpy;

{$I Definition.Inc}

uses
  Forms,
  fuMain in 'fuMain.pas' {Form1};

{$R *.res}
//var
//  PythonEngine1 : TPythonEngine ;
//  PythonGUIInputOutput1: TPythonGUIInputOutput;
//var
//  sl : TStringList ;
begin
  Application.Initialize;
  Application.ShowMainForm := False ;
  Form1 := TForm1.Create(Application);
  Form1.RunPy ;
  Application.Run;
  {
  Application.CreateForm(TForm1, Form1);
  PythonEngine1 := TPythonEngine.Create (Form1);
  PythonEngine1.Initialize ;
  PythonGUIInputOutput1:= TPythonGUIInputOutput.Create(Application);
  PythonEngine1.io := PythonGUIInputOutput1 ;

  sl := TStringList.Create ;
  sl.LoadFromFile(ParamStr(1));
  PythonEngine1.ExecStrings( sl);
  sl.free ;
  Application.Run;
  }
end.



