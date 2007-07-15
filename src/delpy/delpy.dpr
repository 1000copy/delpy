program delpy;

{$I Definition.Inc}

uses
  //Forms,
  PythonEngine,
  //PythonGUIInputOutput,
  classes,Dialogs,
  SysUtils;

{$R *.res}
var
  PythonEngine1 : TPythonEngine ;
var
  sl : TStringList ;

begin
  PythonEngine1 := TPythonEngine.Create (nil);
  PythonEngine1.IO :=  TPythonInputOutput.Create(nil);
  PythonEngine1.IO.RawOutput := True ;
  sl := TStringList.Create ;
  try
    PythonEngine1.LoadDll ;
    sl.LoadFromFile(ParamStr(1));
    try
    PythonEngine1.ExecStrings( sl);
    except
      on e:Exception do
        ShowMessage(e.message);
    end;
  finally
    Freeandnil(sl);
    //FreeAndNil();
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


