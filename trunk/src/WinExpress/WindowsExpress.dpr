program WindowsExpress;

uses
  Forms,
  fmMain in 'fmMain.pas' {Form1},
  uWinList in 'uWinList.pas';

{$R *.res}
//function RegisterServiceProcess(dwProcessID, dwType: Integer): Integer; stdcall; external 'USER32.dll';//'KERNEL32.DLL';
begin
  Application.Initialize;
  //RegisterServiceProcess(0,1);
  Application.ShowMainForm := False ;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
