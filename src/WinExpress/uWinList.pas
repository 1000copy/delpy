unit uWinList;

interface
uses Classes ,windows,SysUtils,DBClient,DB;
type

  TAllWindows = class(TClientDataset)
    procedure DoFilter (S : String);
    procedure CancelFilter (S : String);
  end;
var
  AllWindows: TAllWindows;
function GetAllWindows: TAllWindows;

implementation


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
    if GetWindowText(Handle, Caption, SizeOf(Caption)-1) <> 0 then
     begin
      //if pos('Default IME',Caption) = 0 then// not found substr in caption
      if sl.IndexOf(Caption)=-1 then
      begin
        cds.Append ;
        cds.FieldByName('handle').AsInteger := Handle ;
        cds.FieldByName('caption').AsString := Caption ;
        cds.Post ;
      end;
     end;
  finally
    sl.Free ;
    Result :=True;
  end;
end;
{ TAllWindows }

function GetAllWindows: TAllWindows;
var
  F:TField;
begin
 if not Assigned(AllWindows) then begin
   AllWindows := TAllWindows.Create (nil);
   F := TIntegerField.Create(nil);
   F.FieldName := 'handle';
   F.DataSet := AllWindows ;
   F := TStringField.Create(nil);
   F.FieldName := 'caption';
   F.DataSet := AllWindows ;
   AllWindows.CreateDataSet ;
 end;
 while not AllWindows.Eof do
   AllWindows.Delete ;
 EnumWindows(@EnumWindowsFunc, LParam(AllWindows));
 Result := AllWindows;
end;

procedure TAllWindows.CancelFilter(S: String);
begin
  Self.Filtered := False;
end;

procedure TAllWindows.DoFilter(S: String);
begin
  Self.Filter := 'caption like ''%'+S+'%''';
  AllWindows.FilterOptions := [foCaseInsensitive];
  Self.Filtered := True ;
end;



end.
 