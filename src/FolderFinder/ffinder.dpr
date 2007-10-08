program ffinder;

uses
  Forms,
  fuMain in 'fuMain.pas' {Form1},
  uWinList in 'uWinList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
