unit fuMain;

{$I Definition.Inc}

interface

uses
  Classes, SysUtils,
  Windows, Messages, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,
  PythonEngine, PythonGUIInputOutput;

type
  TForm1 = class(TForm)
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    PythonEngine1: TPythonEngine;
  private
    { Déclarations privées }
//    PythonEngine1 :  TPythonEngine ;
//    PythonGUIInputOutput1: TPythonGUIInputOutput;
  public
    { Déclarations publiques }
    procedure RunPy;
  end;



var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.RunPy;
var
  sl : TStringList ;
begin
  sl := TStringList.Create ;
  sl.LoadFromFile(ParamStr(1));
  PythonEngine1.ExecStrings( sl);
  sl.free ;
end;
// PythonEngine1 := TPythonEngine.Create (Self);
//  //PythonEngine1.Initialize ;
//  PythonGUIInputOutput1:= TPythonGUIInputOutput.Create(Self);
//  PythonEngine1.IO :=  PythonGUIInputOutput1 ;
//  //Memo1 := TMemo.Create(Self);
//  PythonGUIInputOutput1.Output := Memo1

end.


