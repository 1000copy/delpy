unit fmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Registry, DB, DBCtrls, Grids, DBGrids;
type
  TForm1 = class(TForm)
    pnl1: TPanel;
    edt1: TEdit;
    ds1: TDataSource;
    dbgrd1: TDBGrid;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    txt1: TStaticText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt1Change(Sender: TObject);
    procedure edt1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    IsHide : Boolean ;
    procedure DelReg;
    procedure Reg;
  public
    procedure WMHotKey(var Msg: TMessage); message WM_HOTKEY;
  end;

var
  Form1: TForm1;

implementation

uses uWinList;

{$R *.dfm}





procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnRegisterHotKey(handle,1001);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i : Integer ;
begin
 IsHide := True ;
 RegisterHotKey(handle,1001,MOD_CONTROL ,VK_F12);
 ds1.DataSet := GetAllWindows ;
end;


procedure TForm1.FormShow(Sender: TObject);
begin
  edt1.SetFocus ;
  edt1.Clear ;
end;

procedure TForm1.WMHotKey(var Msg: TMessage);
begin
  if Msg.WParam=1001 then
      if IsHide then begin
         show ;
         SetForegroundWindow(handle);
        end
      else    begin
        Hide ;
      end;
end;

procedure TForm1.Reg;
var
  RegF:TRegistry;
begin
  RegF:=TRegistry.Create;
  RegF.RootKey:=HKEY_LOCAL_MACHINE;
  try
    RegF.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',True);
    RegF.WriteString('icq',application.exename);
  except
    application.MessageBox('注册未成功！','提示',mb_ok+mb_iconinformation);
  end;
  RegF.CloseKey;
  RegF.Free;
end;
procedure TForm1.DelReg;
var
  RegF:TRegistry;
begin
  RegF:=TRegistry.Create;
  RegF.RootKey:=HKEY_LOCAL_MACHINE;
  try
    RegF.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',True);
    RegF.DeleteValue('SpyHide');
  except
    application.MessageBox('注册未成功！','提示',mb_ok+mb_iconinformation);
  end;
  RegF.CloseKey;
  RegF.Free;
end;

procedure TForm1.edt1Change(Sender: TObject);
begin
  GetAllWindows.DoFilter(edt1.Text );
end;

procedure TForm1.edt1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i : Integer ;
begin
  //ShowMessage(IntToStr(Key));
  i := 0 ;
  // 40 down
  // 38 up
  // 33 pageup
  // 34 pagedown
  // 39 left
  // 37 right 
  if Key = 40 then
    AllWindows.Next ;
  if Key = 38 then
    AllWindows.Prior;
  if Key = 33 then
    while (not AllWindows.eof) and (i < 10) do begin
      AllWindows.Prior ;
      Inc(i);
    end;
  if Key = 34 then
    while (not AllWindows.eof) and (i < 10) do begin
      AllWindows.next ;
      Inc(i);
    end;
  if key = 27 then
    hide;
  if key = 39 then
    lbl2.Font.Style := lbl2.Font.Style+[fsBold];
  if key = 37 then
    lbl2.Font.Style := lbl2.Font.Style-[fsBold];
  if Key = 13 then begin
    hide ;
    //ShowWindow(AllWindows.fieldByName('handle').AsInteger, SW_SHOWNORMAL		 );//SW_SHOWNORMAL
    //SetSysFocus(AllWindows.fieldByName('handle').AsInteger);
    SetForegroundWindow(AllWindows.fieldByName('handle').AsInteger);
  end;
  Key := 0 ;
end;

end.
