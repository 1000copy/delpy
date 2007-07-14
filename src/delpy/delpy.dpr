program delpy;

{$I Definition.Inc}

uses
  //Forms,
  PythonEngine,
  //PythonGUIInputOutput,
  classes,
  SysUtils;

{$R *.res}
var
  PythonEngine1 : TPythonEngine ;
var
  sl : TStringList ;

begin
  PythonEngine1 := TPythonEngine.Create (nil);
  sl := TStringList.Create ;
  try
    PythonEngine1.LoadDll ;
    sl.LoadFromFile(ParamStr(1));
    PythonEngine1.ExecStrings( sl);
  finally
    Freeandnil(sl);
    Freeandnil(PythonEngine1);
  end;
end.

{
begin

  Application.Initialize;
  Application.ShowMainForm := False ;
  Form1 := TForm1.Create(Application);
  Form1.RunPy ;
  Application.Run;


end.
}


