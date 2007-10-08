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
  fmSplash.Update ;//不做update的话，上面的label显示不出来。
  Application.CreateForm(TForm1, Form1);
  fmSplash.Free ;
  Application.Run;
end.
