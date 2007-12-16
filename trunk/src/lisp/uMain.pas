unit uMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,ulang,uparser,ulangException, ExtCtrls;

type
  TfmLiusp = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    Button3: TButton;
    Button2: TButton;
    btnRun: TButton;
    Splitter1: TSplitter;
    btnTestPackage: TButton;
    procedure btnRunClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnTestPackageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmLiusp: TfmLiusp;

implementation

{$R *.DFM}

procedure TfmLiusp.btnRunClick(Sender: TObject);
begin
  btnRun.Enabled := false ;
  try
    LispLang.EvalStr(memo1.lines.Text);
  finally
    btnRun.Enabled := true ;
  end;
end;

procedure TfmLiusp.Button2Click(Sender: TObject);
begin
  memo2.Clear ;
end;

procedure TfmLiusp.Button3Click(Sender: TObject);
begin
  //output('ReturnLen'+Inttostr(lispLang.returnlistSize)+#13#10) ;
  lispLang.returnlistPrint ;
  //outPut(#13#10);
  //lispLang.nodeListPrint ;
end;

procedure TfmLiusp.FormCreate(Sender: TObject);
begin                                 
  //LispLang := TLispLang.create;
  LispLang.StdOut := Memo2.Lines ;
end;

procedure TfmLiusp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LispLang.free ;
end;

procedure TfmLiusp.btnTestPackageClick(Sender: TObject);
begin
  btnTestPackage.Enabled := false ;
  try
    LispLang.EvalStr('(testpackage)');
  finally
    btnTestPackage.Enabled := true ;
  end;

end;

end.
