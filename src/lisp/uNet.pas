unit uNet;
// 2001.12.3
interface

uses uParser,uLangException,uLang ,scktcomp,classes,dialogs ,SysUtils;
type
  ENetNoAnswer =class(Exception) ;
  ENetNoConnection =class(Exception) ;
  TLispNet = class(TLispPackageBase)
    private
      socket1 : TClientsocket ;
      procedure DownloadFile(strHost, strRemoteFileName, strLocalFileName: string; ClientSocket: TClientSocket);
      function Downfile(lispList: TLispList): TLispNode;
    public
      constructor create ;
      destructor destory ;                              
      function CallFunction(fnName: String;list: TLispList): TLispNode;override ;
      function GetName:String;override ;
      function GetTestSrc:String;override ;
  end;
var
  lispNet : TLispNet ;
implementation
procedure TLispNet.DownloadFile(strHost, strRemoteFileName, strLocalFileName: string; ClientSocket: TClientSocket);
var
  intReturnCode,i,j: Integer;
  s: string;
  tempbuffer,szBuffer: array[0..128] of Char;
  FileOut: TFileStream;
  findFlag : boolean ;
  ch,ch1,ch2,ch3 : char ;
begin
  if strRemoteFileName[1] <> '/' then
    strRemoteFileName := '/' + strRemoteFileName;
  FileOut := TFileStream.Create(strLocalFileName, fmCreate);
  try
    with ClientSocket do
    begin
      close ;
      Host := strHost;
      ClientType := ctBlocking;
      Port := 80;
      try
        Open;
        s := 'GET ' + strRemoteFileName + '   HTTP/1.0'#13#10 +
             'Host: ' + strHost + #13#10#13#10;
        intReturnCode := Socket.SendBuf(Pointer(s)^, Length(s));
        if intReturnCode > 0 then
        begin
          while (intReturnCode > 0) do
          begin
            FillChar(szBuffer, SizeOf(szBuffer), 0);
            //caption := inttostr(intReturnCode);
            intReturnCode := Socket.ReceiveBuf(szBuffer, SizeOf(szBuffer));
            // if szbuffer contains #10#13#10#13
            if (intReturnCode <= 0) then
              continue ;
            if findFlag then
              FileOut.Write(szBuffer, intReturnCode)
            else
            for i := 0 to 125 do
            begin
              ch := szBuffer[i];
              ch1 := szBuffer[i+1];
              ch2 := szBuffer[i+2];
              ch3 := szBuffer[i+3];
              if (findflag = false)and ((ch = #13) and (ch1 = #10) and (ch2 = #13) and (ch3 = #10 )) then
              begin
                findflag := true ;
                if intReturnCode > 0 then
                begin
                  fillchar(tempbuffer,sizeOf(tempBuffer),#0);
                  for j := i+ 4  to 128 do
                    tempbuffer[j-(i+4)] := szBuffer[j] ;
                  FileOut.Write(tempbuffer, 128-(i+4)+1);
                  break ;
                end;
              end ;
            end;
        end
        end
        else
          raise ENetNoAnswer.Create ('ENetNoAnswer'); ;
          //MessageDlg('No answer from server', mtError, [mbOk], 0);
        Close;
      except
        raise ENetNoConnection.Create ('ENetNoConnection');
        //MessageDlg('No connection', mtError, [mbOk], 0);
      end;
    end;
  finally
    FileOut.Free
  end;
  end;

{ Tnet }

function TLispNet.Downfile(lispList: TLispList): TLispNode;
var
  i : integer ;
  locallispnode : TLispNode ;
  h,r,l : string ;
begin
  lispList.checkSizeEquals(4);
  for i := 1 to lispList.size -1 do
  begin
    lispList.nth(i).iEvaluate.checkStr ;
  end;
  locallispnode := lispList.nth(1).iEvaluate ;
  h := locallispnode.getStr ;
  locallispnode := lispList.nth(2).iEvaluate ;
  r := locallispnode.getStr ;
  locallispnode := lispList.nth(3).iEvaluate ;
  l := locallispnode.getStr ;
  downloadFile(h,r,l,socket1);
  result := TLispNode.create('',NIL,TT_TRUE,true);
end;

constructor TLispNet.create;
begin
  socket1 := TClientSocket.Create (nil);
end;

destructor TLispNet.destory;
begin
  socket1.free ;
end;

function TLispNet.CallFunction(fnName: String; list: TLispList): TLispNode;
begin
  Result := nil ;
  if SameText(fnName ,'Downfile') then
    Result := Downfile(list);
end;
function TLispNet.GetName: String;
begin
  Result := 'LispNet';
end;

function TLispNet.GetTestSrc: String;
begin
  Result := '(downfile    "www.163.com"   "/"    "d:\f.txt")';
end;

initialization
  
end.
