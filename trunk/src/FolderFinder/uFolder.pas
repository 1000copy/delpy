unit uFolder;

interface
uses Classes,windows,SysUtils;
type
   TFolder = class
   public
    class procedure GetFixDisk(var sl : TStringList);
    class procedure GetSons(Root:String;var sl : TStringList;Rescue:Boolean=False);
    class procedure GetLevel1Sons(var sl : TStringList);
   end;
implementation


class procedure TFolder.GetFixDisk(var sl : TStringList);
var
  i,len : Integer ;
  A  : Array [0..255] of char ;
  B : String ;
begin
 FillChar(A,255,#0);
 len := GetLogicalDriveStrings(255,A);
 try
   for I := 0 to len -1 do
     if A[I] = #0 then begin
       if (b <> '') and (GetDriveType(PChar(b)) = DRIVE_FIXED) then
          sl.Add(b);
       b := '';
     end else
       b := b + A[I] ;
 finally
 end;
end;
class procedure TFolder.GetLevel1Sons(var sl: TStringList);
var
  slFixDisk: TStringList;i:Integer;
begin
  slFixDisk := TStringList.Create;
  try
    GetFixDisk(slFixDisk);
    for i := 0 to slFixDisk.Count -1 do
     GetSons(slFixDisk.Strings[i],sl,False);
  finally
    slFixDisk.Free ;
  end;
end;

class procedure TFolder.GetSons(Root: String; var sl: TStringList;Rescue:Boolean=False);
var
  temPath,s:String;
  sr:TSearchRec;
begin
  s := Root ;
  temPath:=s+'*.*';
  if SysUtils.FindFirst(temPath,faAnyFile,sr)=0 then
  repeat
    if (sr.Name='.') or (sr.Name='..') then continue
    else
    if ((sr.Attr and faDirectory)= faDirectory)
       and ((sr.Attr and faHidden)<> faHidden)
    then
    begin
      sl.Add(s+''+sr.name);
      if Rescue then
        GetSons(s+sr.Name+'\',sl,Rescue);
    end;
  until SysUtils.FindNext(sr)<>0 ;
  SysUtils.FindClose(sr);
end;

end.
