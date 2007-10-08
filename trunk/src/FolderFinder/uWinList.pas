unit uWinList;

interface
uses Classes ,windows,SysUtils,DBClient,DB,Dialogs ,ShellAPI,Forms,IMCode,uFolder;

type
  TResultDataset = class(TClientDataset)
  private
    procedure MergeFrom(Src: TClientDataset);
  protected
    procedure Init ;virtual;
  public
    constructor Create (O : TComponent);override ;
    procedure DoFilter (S : String;Exactly:Boolean = false);virtual;
    procedure CancelFilter ;virtual;
    procedure DoRun ;virtual ;
  end;

type
  TIndexThread = class(TThread)
  private
    Fcds: TClientDataSet;
    FRootFolder: String;
    procedure Setcds(const Value: TClientDataSet);
    procedure SetRootFolder(const Value: String);
    procedure DeleteLastChar(var S: string);
    procedure FillDir(s: String; var Dataset: TClientDataSet);
    function GetLastChar(S: string): String;
    function GetLastDir(S: string): String;
    { Private declarations }
  protected
    procedure Execute; override;
    property cds :TClientDataSet  read Fcds write Setcds;
    property RootFolder :String  read FRootFolder write SetRootFolder;
    destructor Destroy ;override ;
  public
  end;
function GetFixDisk:string ;
type
  TIndexer =class
    class function IndexAll : TResultDataset;
  end;
implementation

{ TAllWindows }
procedure TResultDataset.MergeFrom(Src:TClientDataset);
var
  i : integer;
  Dst:TClientDataset;
begin
   Src.First ;
   Dst := Self;
   while not Src.eof do begin
     Dst.Append;
     for i :=0 to Dst.Fields.Count -1 do
      Dst.Fields[i].Asstring := Src.Fields[i].Asstring ;
     Dst.Post ;
     Src.Next ;
   end;
end;
class function TIndexer.IndexAll : TResultDataset;
var
  IndexThread:array of TIndexThread;
  sl : TStringList ;
  i : Integer ;
begin
   sl := TStringList.Create ;
   try
     TFolder.GetLevel1Sons(sl);
     SetLength(IndexThread,sl.Count);
     for i := 0 to sl.Count -1 do begin
        IndexThread[i] := TIndexThread.Create(true);
        IndexThread[i].cds := TResultDataset.create(nil);
        IndexThread[i].RootFolder := sl.Strings[i] ;
        IndexThread[i].FreeOnTerminate := False;
        IndexThread[i].Resume;
     end;
     for i := 0 to sl.Count -1 do
       IndexThread[i].WaitFor ;
     Result := TResultDataset.Create (nil);
     if sl.count >=1 then begin
       for i := 0 to sl.count -1 do begin
         Result.MergeFrom(IndexThread[i].cds);
         //ShowMessage(IntToStr(IndexThread[i].cds.RecordCount));
       end;
     end;
     Result.First ;      
   finally
     for i := 0 to sl.Count -1 do begin
        IndexThread[i].Free;
     end;
     sl.Free ;              
   end;
end;




procedure TResultDataset.DoRun;
begin
  inherited;
  ShellExecute(0,nil,PChar(fieldByName('key').AsString),nil,nil,SW_SHOWNORMAL);
end;
procedure TIndexThread.DeleteLastChar(var S:string);
begin
  S := Copy(S,1,Length(S)-1);
end;
function TIndexThread.GetLastChar(S:string):String;
begin
  Result := Copy(S,Length(S),1);
end;
function TIndexThread.GetLastDir(S:string):String;
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
procedure TIndexThread.FillDir(s:String;var Dataset :TClientDataSet);
var
  temPath:String;
  sr:TSearchRec;
  function EnsureSlash(a:string):String;
  begin
     if a[Length(a)]<>'\' then
       result := a+'\';
  end;
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
      Dataset.FieldByName('key').asString := s+'\'+sr.name;
      //Dataset.FieldByName('value').asString := getPyString(GetLastDir(s+sr.name));
      Dataset.FieldByName('value').asString := getPyString(s+sr.name);
      Dataset.Post ;
      Application.ProcessMessages;
      FillDir(s+'\'+sr.Name,Dataset);
      //FillDir(EnsureSlash(s)+sr.Name+'\',Dataset);
    end;
  until SysUtils.FindNext(sr)<>0 ;
  SysUtils.FindClose(sr);
  Dataset.First; 
end;




procedure TResultDataset.CancelFilter;
begin
  Self.Filtered := False;
end;

constructor TResultDataset.Create(O: TComponent);
begin
  inherited;
  Init ;
end;

procedure TResultDataset.DoFilter(S: String;Exactly:Boolean = false);
begin
  FilterOptions := [foCaseInsensitive];
  if Exactly then
    Filter := 'value ='''+S+''''
  else
    Filter := 'value like ''%'+S+'%''';
  Filtered := True ;
end;

procedure TResultDataset.Init;
var
  F :TStringField ;
begin
   F := TStringField.Create(nil);
   F.Size := 255 ;
   F.DisplayWidth := 80;
   F.FieldName := 'key';
   F.DataSet := Self ;
   F := TStringField.Create(nil);
   F.FieldName := 'value';
   F.Size := 255 ;
   F.Visible:= False;
   F.DataSet := Self ;
   CreateDataSet ;
end;

{ TIndexThread }

procedure TIndexThread.Execute;
begin
  inherited;
  FillDir(FRootFolder,Fcds);
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

procedure TIndexThread.Setcds(const Value: TClientDataSet);
begin
  Fcds := Value;
end;

procedure TIndexThread.SetRootFolder(const Value: String);
begin
  FRootFolder := Value;
end;


destructor TIndexThread.Destroy;
begin
  if Assigned(Fcds)then
    Fcds.Free ;
  inherited;
end;


end.
