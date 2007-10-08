unit fuMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, StdCtrls, ExtCtrls,uWinList, ComCtrls;

type
  TForm1 = class(TForm)
    ds1: TDataSource;
    dbgrd1: TDBGrid;
    pnl1: TPanel;
    edt1: TEdit;
    btnReindex: TButton;
    btnQuery: TButton;
    btnRun: TButton;
    stat1: TStatusBar;
    lbl: TLabel;
    procedure btnReindexClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure edt1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Frds : TResultDataset;
    procedure WMHotKey(var Msg: TMessage); message WM_HOTKEY;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
procedure TForm1.btnReindexClick(Sender: TObject);
begin
  if Assigned(ds1.DataSet) then
    ds1.Dataset.Free;
  Frds := TIndexer.IndexAll ;
  ds1.Dataset :=  Frds;
  self.stat1.SimplePanel := true;
  self.stat1.SimpleText := 'It is ok.' +IntToStr(Frds.RecordCount)+' items Indexed. ';

end;

procedure TForm1.btnQueryClick(Sender: TObject);
var
   s :string;
begin
  if Assigned(ds1.DataSet) then
    if edt1.Text = '' then
      FRds.CancelFilter()
    else begin
      //Frds.DoFilter(edt1.Text ,false);
      s := StringReplace(edt1.Text,'\','\\',[rfReplaceAll, rfIgnoreCase]);
      Frds.DoFilter(s ,false);
    end;
end;

procedure TForm1.btnRunClick(Sender: TObject);
begin
  if Assigned(ds1.DataSet) then
    Frds.DoRun;
end;

procedure TForm1.edt1Change(Sender: TObject);
begin
  btnQueryClick(nil);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  edt1.SetFocus ;
  edt1.Clear ;
end;

procedure TForm1.dbgrd1DblClick(Sender: TObject);
begin
  if Assigned(ds1.DataSet) then
    Frds.DoRun;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RegisterHotKey(handle,1001,MOD_CONTROL ,VK_F12);
  btnReindexClick(nil)
end;

procedure TForm1.WMHotKey(var Msg: TMessage);
begin
  if Msg.WParam=1001 then
    SetForegroundWindow(handle);

end;

end.
