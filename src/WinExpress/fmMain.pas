unit fmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Registry, DB, DBCtrls, Grids, DBGrids,uWinList,
  Buttons;
const cWhoIsAuthor = 'Who is 1000copy?';  
type
  TForm1 = class(TForm)
    pnl1: TPanel;
    edt1: TEdit;
    ds1: TDataSource;
    dbgrd1: TDBGrid;
    lblWindows: TLabel;
    lblProgram: TLabel;
    lblDirectory: TLabel;
    txt1: TStaticText;
    lbl4: TLabel;
    btn1: TSpeedButton;
    CheckBox1: TCheckBox;
    lbl1: TLabel;
    mmo1: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt1Change(Sender: TObject);
    procedure edt1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbl1MouseEnter(Sender: TObject);
    procedure lbl1MouseLeave(Sender: TObject);
  private
    IsHide : Boolean ;
    FFindList:TFindList;
    FFindType : TFindListType ;
    FFindListFactory : TFindListFactory ;
    procedure DelReg;
    procedure Reg;
    procedure DoFind;
    procedure OnFindTypeChange;
  public
    procedure WMHotKey(var Msg: TMessage); message WM_HOTKEY;
  end;

var
  Form1: TForm1;

implementation


{$R *.dfm}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FFindListFactory.Free ;
  UnRegisterHotKey(handle,1001);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i,len : Integer ;
  A  : Array [0..255] of char ;
  B : String ;
  sl :TStringList ;
begin
 Application.ShowHint := True;
 KeyPreview := true ;
 IsHide := True ;
 //FormStyle := fsStayOnTop;
 dbgrd1.Enabled := True ;
 dbgrd1.Options := dbgrd1.Options + [dgTitles] ;
 //BorderStyle := bsNone ;
 RegisterHotKey(handle,1001,MOD_CONTROL ,VK_F12);
 //ds1.DataSet := GetAllDirectory;
 FFindListFactory := TFindListFactory.Create ;
 Visible := true ;
 
end;

procedure TForm1.DoFind;
begin                          
 FFindList := FFindListFactory.GetFindList(FFindType);
 ds1.DataSet := FFindList ;
 txt1.Caption := 'Search '+IntToStr(FFindList.RecordCount)+' items';
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
  if edt1.Text = cWhoisAuthor then begin
  //if edt1.Text = '1000' then begin
    ds1.DataSet :=FFindListFactory.GetFindList(fwFor1000copy);
    //DoFind;
  end  else
    FFindListFactory.GetFindList(FFindType).DoFilter(edt1.Text ,CheckBox1.Checked);
end;

procedure TForm1.edt1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i ,j: Integer ;
begin
  //ShowMessage(IntToStr(Key));
{}
end;

procedure TForm1.OnFindTypeChange;
begin
  lblWindows.Font.Style := lblWindows.Font.Style-[fsBold];
  lblDirectory.Font.Style := lblDirectory.Font.Style-[fsBold];
  lblProgram.Font.Style := lblProgram.Font.Style-[fsBold];
  if FFindType = fwFindWindows then
   lblWindows.Font.Style := lblWindows.Font.Style+[fsBold];
  if FFindType = fwFindDirectory then
   lblDirectory.Font.Style := lblDirectory.Font.Style+[fsBold];
  //if FFindType = fwFindProgram then
  // lblProgram.Font.Style := lblProgram.Font.Style+[fsBold];
  //ShowMessage(IntToStr(Integer(FFindType)));
  DoFind;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
   DoFind ;
   txt1.Caption := 'Indexed ';
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  edt1.Text := '';
  edt1.Text := cWhoIsAuthor;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i ,j: Integer ;


begin
  i := 0 ;
  // 40 down
  // 38 up
  // 33 pageup
  // 34 pagedown
  // 39 left
  // 37 right
  i := 0 ;
  if Key = 40 then
    FFindList.Next ;
  if Key = 38 then
    FFindList.Prior;
  if Key = 33 then
    while (not FFindList.bof) and (i < 10) do begin
      FFindList.Prior ;
      Inc(i);
    end;
  if Key = 34 then
    while (not FFindList.eof) and (i < 10) do begin
      FFindList.next ;
      Inc(i);
    end;
  if key = 27 then
    hide;
  if key = 39 then begin
    j := Integer(FFindType) +1;
    FFindType := TFindListType(j mod 2);
    OnFindTypeChange ;
  end;
  if key = 37 then begin
    if Integer(FFindType)= 0 then
      FFindType := TFindListType(Integer(FFindType)+2) ;
    j := Integer(FFindType) -1;
    FFindType := TFindListType(j mod 2);
    OnFindTypeChange ;
  end;
  if Key = 13 then begin
    hide ;
    //ShowWindow(FindList.fieldByName('handle').AsInteger, SW_SHOWNORMAL		 );//SW_SHOWNORMAL
    //SetSysFocus(FindList.fieldByName('handle').AsInteger);
    //SetForegroundWindow(FindList.fieldByName('key').AsInteger);
    FFindList.DoRun ;
  end;
  Key := 0 ;
end;

procedure TForm1.lbl1MouseEnter(Sender: TObject);
var
  i ,h,w: integer;
begin
  h := mmo1.Height ;
  mmo1.Height := 0 ;
  mmo1.Visible := true ;
  for i := 0 to h div 10 do begin
     Sleep(30);
     mmo1.Height :=  10*i ;
  end;
end;

procedure TForm1.lbl1MouseLeave(Sender: TObject);
begin
  mmo1.Visible := False ;
end;

end.
