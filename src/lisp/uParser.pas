unit uParser;

interface
uses classes ;
const
  TT_NUMB =1 ;
  TT_STRING =2 ;
  TT_TOKEN = 3 ;
  TT_LEFT = 4 ;
  TT_RIGHT = 5 ;
  TT_INT = 6 ;
  TT_EOF = 0 ;
  TT_NOTMATCH = -1 ;
  TT_NULL = 7 ;
  TT_TRUE = 8;
  TT_FALSE = 9 ;
  TT_LIST = 101 ;
type
  TLispParser = class
    private
      mStream : TStream ;
      function isDelimiter(ch : char):boolean ;
      function isQDelimiter(ch : char):boolean ;
      function isEnter(ch : char):boolean ;
      function TokenType(token : string): Integer ;
    public
      //constructor create (s : TStream);
      procedure load (s : TStream);
      function nextToken (var token : String):Integer;
  end;
implementation

{ TLispParser }

//constructor TLispParser.create(s: TStream);
procedure TLispParser.load(s: TStream);
begin
  mstream := s ;
  mstream.position := 0 ;
end;

function TLispParser.nextToken(var token: String): Integer;
var
  ch : char ;
  i, frontpos,backpos : longint;
  buffer : array [0..128] of char ;
label
  retry ;
begin
  if mstream.Position = mstream.Size then
  begin
    result := TT_EOF ;
    EXIT
  end;
  mstream.Read(ch,1);
  while ((ch = ' ') or (ch = #10) or (ch= #13))  and (mstream.Position<mstream.Size) do
  begin
      mstream.read(ch,1);
  end;
  if  ((ch = ' ') or (ch = #10) or (ch= #13))  and (mstream.Position = mstream.Size)   then
  begin
    result := TT_EOF ;
    EXIT
  end;
  case ch of
  '(':
  begin
    result := TT_LEFT ;
  end;
  ')':
  begin
   result := TT_RIGHT ;
  end;
  ''''://SKIP COMMENTS
  begin
    mstream.read(ch,1);
    while not isEnter(ch) do
      mstream.read(ch,1);
  end;
  '"':
  begin
    frontpos := mstream.position ;
    mstream.read(ch,1);
    while not isQDelimiter(ch) do
    begin
      mstream.read(ch,1);
    end;
    if ch <> '"' then
    begin
      result := TT_NOTMATCH ;
      exit;
    end;
    backpos := mstream.Position -1 ;
    mstream.Seek(frontpos,soFromBeginning);
    fillchar(buffer,sizeof(buffer),#0);
    mstream.read(buffer,backpos-frontpos);
    //add
    mstream.Seek(backpos+1,soFromBeginning);
    i := 0 ;
    while (buffer[i]<> #0) do
    begin
      token := token + buffer[i];
      inc(i);
    end;
    Result := TT_STRING ;
  end;
  {#10:
  begin
  end;
  #13:
  begin
  end;}
  else
  begin
    // NEXT delimeter
    frontpos := mstream.Position -1;
    mstream.read(ch,1);
    while not isDelimiter(ch) do
        mstream.read(ch,1);
    //if (pos(ch,'''"()')<>0) then
    begin
      backpos := mstream.Position-1 ;
      mstream.Seek(frontpos,soFromBeginning);
      fillchar (buffer ,sizeof(buffer),#0);
      mstream.read(buffer,backpos-frontpos);
      i := 0 ;
      while (buffer[i]<> #0) do
      begin
        token := token + buffer[i];
        inc(i);
      end;
      mstream.Seek(backPos,soFromBeginning);
      // is numberic
      result := TokenType(token);
    end;
  end;
  end;//case
end;
function TLispParser.isDelimiter(ch : char):boolean ;
begin
    result := not ((pos(ch,'''"() '#13#10)=0) and (mstream.Position<mstream.Size));
end;
function TLispParser.isEnter(ch : char):boolean ;
begin
    result := not ((pos(ch,#13#10)=0) and (mstream.Position<mstream.Size));
end;
function TLispParser.TokenType(token : string): Integer ;
var
  dotcount ,i : integer ;
begin
    dotcount := 0 ;
    //flag := false ;
    if (length(token) = 1) and (pos(token,'0123456789') = 0 )then begin
      result := TT_TOKEN;
      exit ;
    end;
    for i := 1 to length(token) do
    begin
      if (token[i]='.') then
        inc(dotcount) ;
      if (i = 1) then
      begin
       if (pos(token[i],'-0123456789.') = 0 ) or (dotcount>1)  then
       begin
           result := TT_TOKEN;
           exit ;
       end;
      end
      else
      if (pos(token[i],'0123456789.') = 0 ) or (dotcount>1) then
       begin
           result := TT_TOKEN;
           exit ;
       end;
    end;
    if (dotcount=0 ) then begin
      if (length(token) = 1) and (pos(token,'0123456789')=-1)  then
        Result := TT_TOKEN
      else
        Result := TT_INT
    end
    else
      Result := TT_NUMB ;
end;

function TLispParser.isQDelimiter(ch: char): boolean;
begin
   // Quote Delimeter NOT include space
   result := not ((pos(ch,'''"()'#13#10)=0) and (mstream.Position<mstream.Size));
end;

end.


