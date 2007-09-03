unit uWinList;

interface
uses Classes ,windows,SysUtils,DBClient,DB,Dialogs ,ShellAPI,Forms,IMCode;

type
  //TFindListType = (fwFindDirectory,fwFindWindows,fwFindProgram);
  TFindListType = (fwFindDirectory,fwFindWindows,fwFor1000copy);
  TFindList = class(TClientDataset)
  protected 
    procedure Init ;virtual;
  public
    constructor Create (O : TComponent);override ;
    procedure DoFilter (S : String;Exactly:Boolean = false);virtual;
    procedure CancelFilter (S : String);virtual;
    procedure Fill(Argument:String);virtual;abstract;
    procedure DoRun ;virtual ;abstract ;
  end;
  TAllWindows = class(TFindList)
    procedure Fill(Argument:String);override;
    procedure DoRun ;override ;
  end;
  TAllDirectory = class(TFindList)
    procedure Fill(Argument:String);override;
    procedure DoRun ;override ;
  end;
  TFor1000copy = class(TFindList)
    procedure Fill(Argument:String);override;
    procedure DoRun ;override ;
  end;
  TFindListFactory = class
  private
    AllWindows : TFindList ;
    AllDirectory: TFindList ;
    For1000copy: TFindList;
    function GetFor1000copy: TFindList;
  public
   constructor Create;reintroduce ;
   destructor Destroy ;override ;
   function GetFindList(Value : TFindListType): TFindList;
  end;


implementation

{ TAllWindows }
function TFindListFactory.GetFor1000copy:TFindList;
var
  F:TField;
begin
 if not Assigned(For1000copy) then begin

    For1000copy := TFor1000copy.Create (nil);
    {
    F := TStringField.Create(nil);
    F.Size := 255 ;
    F.FieldName := 'key';
    F.DataSet := For1000copy ;
    F := TStringField.Create(nil);
    F.FieldName := 'value';
    F.Size := 255 ;
    F.DataSet := For1000copy ;
    For1000copy.CreateDataSet ;
    }
    For1000copy.Append;
    For1000copy.FieldByName('key').asString := 'Name';
    For1000copy.FieldByName('value').asString := 'Liu Chuanjun';
    For1000copy.Post ;
    For1000copy.Append;
    For1000copy.FieldByName('key').asString := 'Blog';
    For1000copy.FieldByName('value').asString := '1000copy.spaces.live.com';
    For1000copy.Post ;
    For1000copy.Append;
    For1000copy.FieldByName('key').asString := 'Email';
    For1000copy.FieldByName('value').asString := '1000copy@gmail.com';
    For1000copy.Post ;
 end;
 Result := For1000copy ;
end;




procedure TAllWindows.DoRun;
begin
  SetForegroundWindow(fieldByName('key').AsInteger);
end;

procedure TAllWindows.Fill(Argument: String);
  function EnumWindowsFunc(Handle: THandle; cds: TClientDataSet): boolean ; stdcall;
  var Caption: array[0..256] of Char;
  var
    i : integer ;
    sl : TStringList;
  begin
    sl := TStringList.Create ;
    try
      sl.Add('Default IME');
      sl.Add('SpyHideBy Sanrex@163.com');
      sl.Add('DDE Server Window');
      sl.Add('M');
      sl.Add('GPY_UI');
      sl.Add('GDI+ Window');
      sl.Add('SysFader');
      if GetWindowText(Handle, Caption, SizeOf(Caption)-1) <> 0 then
       begin
        //if pos('Default IME',Caption) = 0 then// not found substr in caption
        if sl.IndexOf(Caption)=-1 then
        begin
          cds.Append ;
          cds.FieldByName('key').AsInteger := Handle ;
          cds.FieldByName('value').AsString := String( Caption) ;
          cds.Post ;
        end;
        Application.ProcessMessages;
       end;
      Result :=True;
      cds.First; 
    finally
      sl.Free ;
    end;
  end;
begin
  while not Eof do
    Delete ;
  EnumWindows(@EnumWindowsFunc, LParam(Self));
end;

{ TAllDirectory }


procedure TAllDirectory.DoRun;
begin
  inherited;
  //ShowMessage(fieldByName('key').AsString);
  ShellExecute(0,nil,PChar(fieldByName('key').AsString),nil,nil,SW_SHOWNORMAL);
  
  {
  我们一般使用 ShellExecute 来打开一个文件或者目录，也可以用其来打开一个IE窗口、
  打印窗等等。现在很多软件在打开文件所在目录的同时都会贴心的把该文件选中，
  比如 FlashGet，BitComet。//打开目录并选定文件
  ShellExecute(NULL, _T("open"), _T("Explorer.exe"), _T(" /select,") + filePath, NULL, SW_SHOWDEFAULT);
  }

end;
function GetFixDisk:string ;
var
  i,len : Integer ;
  A  : Array [0..255] of char ;
  B : String ;
  sl :TStringList ;
begin
 FillChar(A,255,#0);
 len := GetLogicalDriveStrings(255,A);
 sl := TStringList.Create ;
 try
   for I := 0 to len -1 do
     if A[I] = #0 then begin
       if (b <> '') and (GetDriveType(PChar(b)) = DRIVE_FIXED) then
          sl.Add(b);
       b := '';
     end else
       b := b + A[I] ;
   Result := sl.CommaText ;
 finally
   sl.Free ;
 end;
end;
procedure TAllDirectory.Fill(Argument: String);
  procedure DeleteLastChar(var S:string);
  begin
    S := Copy(S,1,Length(S)-1);
  end;
  function GetLastChar(S:string):String;
  begin
    Result := Copy(S,Length(S),1);
  end;
  function GetLastDir(S:string):String;
  var
    i :Integer ;
  begin
    if GetLastChar(S) ='\' then
      DeleteLastChar(S);
    i := Length(s);
    while i > 0 do
    begin
      if Copy(S,i,1) ='\' then begin
        Result := Copy(S,i+1,Length(s));
        Exit;
      end;
      Dec(i);
    end;
    Result := s ;
  end;
  procedure FillDir(s:String;var Dataset :TAllDirectory);
  var
    temPath:String;
    sr:TSearchRec;
  begin
    temPath:=s+'\*.*';
    if SysUtils.FindFirst(temPath,faAnyFile,sr)=0 then
    repeat
      if (sr.Name='.') or (sr.Name='..') then continue
      else
      //if (sr.Attr and faDirectory)=sr.Attr then
      // 上面这个方法是delphi给的例子，但是找不到program files 之类的17属性的目录
      // 下面是我试验处理的。
      if ((sr.Attr and faDirectory)= faDirectory)
         and ((sr.Attr and faHidden)<> faHidden)
      then
      begin
        Dataset.Append;
        Dataset.FieldByName('key').asString := s+sr.name;
        Dataset.FieldByName('value').asString := getPyString(GetLastDir(s+sr.name));
        Dataset.Post ;
        Application.ProcessMessages;
        FillDir(s+sr.Name+'\',Dataset);
      end;
    until SysUtils.FindNext(sr)<>0 ;
    SysUtils.FindClose(sr);
    Dataset.First; 
  end;
var
   sl :TStringList;
   i : Integer ;
begin
   sl := TStringList.Create ;
   try
     sl.CommaText := GetFixDisk;
     //sl.CommaText := 'F:\'; //just for test
     for i := 0 to sl.Count -1 do
        FillDir(sl.Strings[i],Self);
   finally
     sl.Free ;
   end;
end;


constructor TFindListFactory.Create;
begin
  inherited;
  AllWindows := nil ;
  AllDirectory:= nil ;
  For1000copy := nil ;
end;

destructor TFindListFactory.Destroy;
begin
  FreeAndNil(AllWindows);
  FreeAndNil(AllDirectory);
  FreeAndNil(For1000copy);
  inherited;
end;



function TFindListFactory.GetFindList(Value : TFindListType): TFindList;
begin
  if Value = fwFindWindows then begin
     if not Assigned(AllWindows) then begin
       AllWindows := TAllWindows.Create (nil);
       AllWindows.Fill('');
     end;
     Result := AllWindows;
  end
  else  if Value = fwFindDirectory then  begin
   if not Assigned(AllDirectory) then begin
     AllDirectory := TAllDirectory.Create (nil);
     AllDirectory.Fill('');
   end;
   Result := AllDirectory;
  end
  else   if Value = fwFor1000copy then
    //ShowMessage('not yet implement!');
    Result := GetFor1000copy;
end;
{ TFindList }

procedure TFindList.CancelFilter(S: String);
begin
  Self.Filtered := False;
end;

constructor TFindList.Create(O: TComponent);
begin
  inherited;
  Init ;
end;

procedure TFindList.DoFilter(S: String;Exactly:Boolean = false);
begin
  FilterOptions := [foCaseInsensitive];
  if Exactly then
    Filter := 'value ='''+S+''''
  else
    Filter := 'value like ''%'+S+'%''';
  Filtered := True ;
end;

procedure TFindList.Init;
var
  F :TStringField ;
begin
   F := TStringField.Create(nil);
   F.Size := 255 ;
   F.FieldName := 'key';
   F.DataSet := Self ;
   F := TStringField.Create(nil);
   F.FieldName := 'value';
   F.Size := 255 ;
   F.DataSet := Self ;
   CreateDataSet ;  
end;

{ TFor1000copy }

procedure TFor1000copy.DoRun;
begin
  inherited;

end;

procedure TFor1000copy.Fill(Argument: String);
var f : TField ;
begin
  inherited;

end;

end.
