program ffinder;

uses
  Forms,
  MidasLib,
  fuMain in 'fuMain.pas' {Form1},
  uWinList in 'uWinList.pas',
  uFolder in 'uFolder.pas',
  fuSplash in 'fuSplash.pas' {fmSplash};

{$R *.res}

begin
  Application.Initialize;
  //Application.ShowMainForm := False;
  fmSplash :=  TfmSplash.Create(nil);
  fmSplash.Show ;
  fmSplash.Update ;//����update�Ļ��������label��ʾ��������
  Application.CreateForm(TForm1, Form1);
  fmSplash.Free ;
  Application.Run;
end.
