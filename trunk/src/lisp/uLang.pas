unit uLang;

interface

uses
  dialogs,contnrs,classes ,sysutils,uParser,ulangException,forms;
const
  CM_EQ = 1 ;CM_LT =2 ;CM_GT = 3 ;CM_LE = 4 ;CM_GE = 5 ;CM_NE = 6 ;
  CR_EQ = 1 ;CR_LT = 2 ;CR_GT = 3 ;CR_NE = 4 ;

type
  TLispList = class;
  TLispNode = class
  private
    isAtom : Boolean ;
    datatype :integer ;
    entity : string ;      // or
    lispList : TLispList ; // or
  public
    function iDup : TLispNode ;
    procedure registerToReturnList ;
    constructor create(token : string ;ll : TLispList ;dt : integer;toReturnList:boolean=false) ;
    destructor destroy ;override ;
    function iPrint : TLispNode;
    function isNumb : boolean;
    function isStr : boolean;
    function isInt : boolean;
    function isList : boolean;
    procedure checkNumb ;
    procedure checkToken ;
    procedure checkStr ;
    procedure checkInt;
    procedure checkList ;
    procedure checkBool ;
    function getList : TLispList ;
    function getInt : Integer ;
    function getNumb : double ;
    function getStr : string ;
    function getBool : Boolean ;
    // second
    function iEvaluate:TLispNode ;
  end;
  //TLispNode = class;
  TLispList = class
  private
    //fIndent : Integer  ;
    fIndentLen : Integer ;
    fName : String ;
    lispNodes : TList ;
    function iCompare( n1,n2:TLispNode):Integer;
    function iCompare1 (compMethod : integer):TLispNode;
    function iPrint : TLispNode ;
    function iEvaluate:TLispNode ; // evaluate self
    function iDup : TLispList ;
    function GetIndent(Level:Integer):String;
    function isDeepestList : Boolean;
  private
    // 用户表函数
    function lAdd :TLispNode;
    function lEvaluate :TLispNode; // run evaluate function
    function lsetq :TLispNode;
    function ldefun: TLispNode ;
    function lprint :TLispNode;
    function lquote :TLispNode;
    function ldec :TLispNode;
    function lmulti :TLispNode;
    function ldivide :TLispNode;
    function iADMD(admd : integer) :TLispNode;
    function lge :TLispNode;
    function lle :TLispNode;
    function lgt :TLispNode;
    function llt :TLispNode;
    function leq :TLispNode;
    function lrepeat :TLispNode;
    function lif :TLispNode;
    function ldo :TLispNode;
    function lload :TLispNode;
    function lnth :TLispNode;
    function llen :TLispNode;
    function lhomedir :TLispNode;
    function ltestpackage:TLispNode;
    function luserdefun(fName : String):TLispNode;
  public
    constructor create ;
    destructor destroy ;override ;
    // 内部表函数
    function size : integer ;
    procedure append(ln : TLispNode);
    function nth(i:integer):TLispNode ;
    procedure checkSizeEquals(A:Integer);overload ;
    procedure checkSizeGE(A:Integer);overload ;
    procedure checkSizeEquals(A:Array of Integer);overload ;
  end;
  THashTable = class(TStringList)
    constructor create ;
    destructor destroy ;override ;
    procedure setValue(Index : string; obj :TLispNode);
    function getValue(Index : string):TLispNode ;
  end;


type
  ILispPackage = interface
    function CallFunction(fnName:String;list: TLispList):TLispNode;
    function GetName:String;
    function GetTestSrc:String;
  end;
  TLispPackageBase = class(TInterfacedObject,ILispPackage)
    function CallFunction(fnName:String;list: TLispList):TLispNode;virtual;
    function GetName:String;virtual;
    function GetTestSrc:String;virtual;
  end;
type
  TLispLang = class
  private
   FParser : TLispParser ;
   FPackageList : Array of ILispPackage ;
   nodeList : TLispList ;
   varList : THashtable ;
   funcList : THashtable ;
   returnList : TLispList ;
   FStdOut: TStrings;
   function byLoad (s : TStream):TLispList;
  private
   procedure iLoad (s : TStream);overload;
   procedure iLoad (FileName:String);overload;
   procedure iPrint;
   function lEvaluate:TLispNode;
   function VarValue(s : String):TLispNode;
   procedure tPrint1(ln : TLispNode) ;
   function returnlistSize :integer;
   procedure nodeListPrint ;
   procedure returnlistClear ;
   procedure put (s : string);
   function iCallPackage(fName : String;list:TLispList):TLispNode;
  public
   constructor Create ;
   destructor Destroy;override ;
   function  EvalFile (FileName : String):TLispList;
   function  EvalStr (ListStr : String):TLispList ;
   property StdOut : TStrings read FStdOut write FStdOut;
   procedure RegisterPackage(I:ILispPackage);
   procedure returnlistPrint ;
  end;
  function LispLang : TLispLang ;

/////////////
procedure output(S:String);
implementation
uses uMain,uString ,uNet ,uDb;
var
  FLispLang : TLispLang ;
  fIndent : Integer  ;TestIP:ILispPackage;
function LispLang : TLispLang ;
begin
  if FLispLang = nil then
    FLispLang := TLispLang.create;
  Result := FLispLang ;
end;
procedure TLispLang.RegisterPackage(I:ILispPackage);
var
  j : Integer ;
begin
  SetLength(FPackageList,high(FPackageList)+2);
  FPackageList[high(FPackageList)] := I ;
end;
procedure output(S:String);
begin
  LispLang.put(s);
  // Is Console Application
  if Application.MainForm = nil then
  //if pos('liusp.exe', .ExeName) > 0 then
    Write (s) ;
end;
procedure TLispLang.put (s : string);
begin
  if not (FStdOut = nil) then FStdOut.Text := FStdOut.Text + S;
end;

constructor TLispLang.create ;
begin
  FParser := TLispParser.create ;
  NodeList := TLispList.create ;
  varList := Thashtable.create ;
  funcList := Thashtable.create ;
  ReturnList := TLispList.create ;
  SetLength(FPackageList,0);
end;
destructor TLispLang.destroy;
begin
  SetLength(FPackageList,0);
  // content dispose in parent
  // functionEntryList.Free ;
  returnList.free ;
  // varlist MUST BEFORE nodeList ,else will 'Invalid Pointer '
  varList.free ;
  funcList.Free ;
  NodeList.free ;
  FParser.free;
  // var dispose in hashfree
end;
function TLispLang.lEvaluate :TLispNode;
var
  i : integer ;
begin
  // nodelist is program ,NOT A LIST
  for i:= 0 to Nodelist.size -1 do
    result := nodeList.nth(i).iEvaluate ;
  Result.iPrint ;
end;

procedure TLispLang.iLoad (s : TStream);
begin
  NodeList := byLoad(s) ;
end;
var
  // for  print
  Indent : String;
  level : Integer;
procedure TLispLang.iPrint ;
var
 i : integer;
 ln : TLispNode ;
begin
  output('(');
  for i := 0 to nodeList.size -1 do
  begin
    inc(Level);
    ln := nodeList.nth(i);
    ln.iprint ;
    dec(Level);
  end;
  output(#13#10')');
end;

{ TLispList }

procedure TLispList.append(ln: TLispNode);
begin
  lispNodes.Add(ln);
  //**********************
  //*****other memory hole

  //result := TLispNode.create('',self,TT_LIST);

end;

constructor TLispList.create;
begin
  lispNodes := TList.Create ;
  fIndent := 0 ;
  fIndentLen := 2 ;
end;

destructor TLispList.destroy ;
var
  i : integer ;
begin
  for i := 0 to lispNodes.Count-1 do
    TLispNode(lispNodes.items[i]).Free ;
  lispNodes.Free;
end;

function TLispList.iEvaluate: TLispNode;
var
  ln : TLispNode ;
  i : integer;
begin
 if lispNodes.Count < 1 then
 begin
   result := TLispNode.create('',nil,TT_NULL,true) ;
   exit;
 end;

 ln := TLispNode(lispNodes.Items[0]); // .iEvaluate ; NOT EVALUATE!
 if not ((ln.isAtom) and (ln.datatype = TT_TOKEN)) then
 begin
   result := TLispNode.create('',nil,TT_NULL,true) ;
   exit;
 end;
 fName := ln.entity ;
 fName := lowerCase(fName);
 if fName = '+' then
   result := ladd
 else if fName = 'defun' then
   result := ldefun 
 else if fName = '=' then
   result := lsetq
 else if fName = 'print' then
   result := lprint
 else if fName = 'quote' then
   result := lquote
 else if fName = '-' then
   result := ldec
 else if fName = '*' then
   result := lmulti
 else if fName = '/' then
   result := ldivide
 else if fName = '>=' then
   result := lge
 else if fName = '<=' then
   result := lle
 else if fName = '>' then
   result := lgt
 else if fName = '<' then
   result := llt
 else if fName = '==' then
   result := leq
 else if fName = 'repeat' then
   result := lrepeat
 else if fName = 'if' then
   result := lif
 else if fName = 'do' then
   result := ldo
 else if fName = 'load' then
   result := lload
 // List
 else if fName = 'nth' then
   result := lnth
 else if fName = 'len' then
   result := llen
 else if fName = 'homedir' then
   result := lhomedir
  else if fName = 'testpackage' then
   result := ltestpackage
 else begin
   result := LispLang.iCallPackage(fName,Self);
   if result = nil then begin
     Result := luserdefun(fName);
   end;
   if result = nil then begin
     result := TLispNode.create('',nil,TT_NULL,true);
     raise ELispNoFunction.Create(fname);
   end;
 end;
 // 为什么这样?好像至少创建了一个Node，然后在formclose的时候释放，没有任何用处？
 result := result.iDup ;
 result.registerToReturnList ;
end;

function TLispList.isDeepestList : Boolean;
var i : integer ;
begin
   Result  := False ;
   for i := 0 to size-1 do
   begin
      Result  := Result  or nth(i).isList ;
      if Result  then break ;
   end;
   Result := not Result ;
end;
// (print (quote (1 2(3 4 )(3 4 (3 4 ((3 4 ) 3 4 )) )(3 4 ))))
function TLispList.iPrint: TLispNode;
var
  i ,j: integer ;
  ContainList : Boolean ;
  s : String;

  function RepeatStr(S:String;Len : Integer):String;
  var
    i : Integer ;
  begin
    for i := 0 to Len -1 do
      Result := Result + S ;
  end;
begin
     output(RepeatStr(' ',fIndent*fIndentLen)+'(');
     ContainList := False ;
     for i := 0 to size-1 do
     begin
        if nth(i).isList then
        begin
          output(#13#10);
          fIndent := fIndent + 1 ;
        end;
        result := nth(i).iprint ;
        if nth(i).isList then
        begin
          fIndent := fIndent - 1 ;
        end;
     end;
     if not isDeepestList then begin
       output(#13#10);
       output(RepeatStr(' ',fIndent*fIndentLen)+')');
     end else
       output(')'); 
end;

function TLispList.nth(i: integer): TLispNode;
begin
 try
  result := TLispNode(lispNodes.items[i]);
 except
   raise ELispNthIndexOver.create(size,i) ;
 end;
end;

function TLispList.size: integer;
begin
  result := lispNodes.Count ;
end;

function TLispList.lEvaluate: TLispNode;
var
  i : integer ;
begin
  for i := 1 to lispNodes.Count -1 do
  begin
   result := TLispNode(lispNodes.Items[i]).iEvaluate ;
  end;
  if lispNodes.Count = 1 then
  begin
   result := TLispNode.create('',nil,TT_NULL,true);
  end;
end;

function TLispList.lsetq: TLispNode;
var
  i : integer ;
  token : string;
  tokenNode : TLispNode ;
  valueNode : TLispNode ;
begin
  token := '';
  for i := 1 to size -1  do
  begin
    if odd(i) then
    begin
      tokenNode := nth(i);// NOT .iEvaluate ; for SETQ
      if tokenNode.datatype = TT_TOKEN then
        token := tokenNode.entity ;
    end else
    if (token <>'') then
    begin
      valueNode := nth(i).iEvaluate ;
      lispLang.varList.setValue(token,valueNode);
      token :='' ;
    end;
  end;
  //result := TLispNode.create(token,lispList,datatype,true);
  result :=  valueNode ;
end;

function TLispList.lprint: TLispNode;
var
 tokenNode : TLispNode;
 i :integer ;
begin
  for i := 1 to size -1  do
  begin
    tokenNode := nth(i).ievaluate;
    if tokenNode.isAtom then
    begin
      result := tokenNode.iPrint ;
    end else
      result := tokenNode.getList.iPrint ;
  end;
end;
// testcode :
//(print (quote 4))
//(print (quote (4 4))) 
function TLispList.lquote: TLispNode;
var
  rList : TlispList ;
  i : integer ;
begin
  checkSizeEquals(2);
  result := nth(1);
end;

function TLispList.iDup: TLispList;
var
  i : integer ;
begin
  Result := TLispList.create ;
  for i := 0 to size -1 do
  begin
    Result.append(nth(i).iDup) ;
  end;
end;

function TLispList.ldec: TLispNode;
begin
  result := iADMD(2);
end;

function TLispList.ldivide: TLispNode;
begin
  result := iADMD(4);
end;

function TLispList.ldo: TLispNode;
var
  i : Integer ;
begin
  for i := 1 to size -1 do
  begin
    Result := nth(i).iEvaluate ;
  end;
end;

function TLispList.leq: TLispNode;
begin
    result := iCompare1(CM_EQ);
end;

function TLispList.lle: TLispNode;
begin
    result := iCompare1(CM_LE);
end;

function TLispList.lgt: TLispNode;
begin
    result := iCompare1(CM_GT);
end;

function TLispList.lif: TLispNode;
var
  i : integer ;
begin
  CheckSizeEquals([3,4]);
  if nth(1).iEvaluate.datatype <> TT_FALSE then
    result := nth(2).ievaluate else
    if size = 4 then 
    result := nth(3).ievaluate ;
end;

function TLispList.lge: TLispNode;
var
  i : integer ;
  n1,n2 : TLispNode ;
  rb : boolean ;
begin
  result := iCompare1(CM_GE);
end;

function TLispList.llt: TLispNode;
begin
  //compMethod_EQ,LT,GT,LE,GE,NE
  result := iCompare1(CM_LT);
end;

function TLispList.lmulti: TLispNode;
begin
 result := iADMD(3);
end;

function TLispList.lrepeat: TLispNode;
var
  i ,j,k: integer ;
  tn : TLispNode ;
begin
  CheckSizeEquals(3);
  tn := nth(1).iEvaluate ;
  tn.checkInt;
  //tn.checkNumb;
  if tn.datatype = TT_INT then
    k :=  tn.getInt
  else
    k := trunc(tn.getnumb) ;
  if k = 0 then
    Result := TLispnode.create('',nil,TT_TRUE)
  else
  for j := 0 to k -1 do
    for i := 2 to size -1 do
    begin
      Result := nth(i).iEvaluate ;
    end;
end;

function TLispList.iADMD(admd:integer): TLispNode;
var
  i ,ri,ci: Integer ;
  rn ,cn: double ;
  ln : TLispNode ;
  fName : String ;
  numbCount : integer ;
  localNodes : TList ;
begin
 localNodes := lispNodes ;
 numbCount := 0 ;ri := 0 ;rn :=0.0;
 for i := 1 to localNodes.Count -1 do
 begin
   ln := TLispNode(localNodes.Items[i]).iEvaluate ;
   ci := 0 ;cn := 0 ;
   if ln.datatype = TT_NUMB then
   begin
     cn := StrtoFloat(ln.entity);
     inc(numbCount) ;
   end;
   if ln.datatype = TT_INT then
   begin
     ci := StrtoInt(ln.entity);
     cn := ci ;
   end;
   if i = 1 then
   begin
     ri := ci ;
     rn := cn ;
   end else
   if numbCount = 0 then
   begin
     case admd of
         1:
         begin
         ri := ri + ci ;
         rn := rn + ci ;
         end;
         2:
         begin
         ri := ri - ci ;
         rn := rn - ci ;
         end;
         3:
         begin
         ri := ri * ci ;
         rn := rn * ci ;
         end;
         4:
         begin
         ri := trunc(ri / ci) ;
         rn := rn / ci ;
        end;
     end;
   end else
   begin
     case admd of
       1: rn := rn + cn ;
       2: rn := rn - cn ;
       3: rn := rn * cn ;
       4: rn := rn / cn ;
     end;
   end;
 end;
 IF numbCount = 0 then
 result := TLispNode.create(inttoStr(ri),nil,TT_INT) else
 result := TLispNode.create(floatToStr(rn),nil,TT_NUMB);
 // remember return pointer ,so I can dispose later
 //LispLang.returnList.append(result);
end;

function TLispList.iCompare(n1, n2: TLispNode): Integer;
var
  i : integer ;
begin
  //EQ,LT,GT,NE
  if (n1.datatype = n2.datatype) or
   ((n1.datatype = TT_NUMB) and (n2.datatype = TT_INT)) or
   ((n2.datatype = TT_NUMB) and (n1.datatype = TT_INT))
  then
  begin
    if n1.isAtom then
    begin
      if n1.entity = n2.entity then
        result := CR_EQ
      else if n1.datatype = TT_STRING then
      begin
        if n1.entity > n2.entity then
          result := CR_GT
        else
          result := CR_LT ;
      end else
        if n1.entity > n2.entity then
          result := CR_GT
        else
          result := CR_LT ;
    end
    else // list
    begin
      result := CR_EQ ;
      if n1.getList.size = n2.getList.size then
        for i := 0 to n1.getlist.size -1 do
        begin
          if iCompare(n1.getList.nth(i),n2.getList.nth(i)) <> 1 then
          begin
            result := CR_NE; // NE
            break ;
          end;
        end;

    end;
  end else
    result := CR_NE ;
end;

function TLispList.iCompare1(compMethod: integer): TLispNode;
var
  i : integer ;
  n1,n2 : TLispNode ;
  rb : boolean ;
begin
  // CR_EQ,LT,GT,LE,GE,NE :   compMethod
  // CR_EQ,LT,GT,NE    : iCompare return
  checkSizeEquals(3);
  n1 := nth(1).iEvaluate;
  n2 := nth(2).iEvaluate;
  case compMethod of
    CM_EQ:
    begin
      rb := iCompare(n1,n2) = CR_EQ ;
    end;
    CM_LT:
    begin
      rb := iCompare(n1,n2) = CR_LT ;
    end;
    CM_GT:
    begin
      rb := iCompare(n1,n2) = CR_GT;
    end;
    CM_LE:
    begin
      rb := iCompare(n1,n2) in [CR_EQ,CR_LT] ;
    end;
    CM_GE:
    begin
      rb := iCompare(n1,n2) in [CR_EQ,CR_GT] ;
    end;
    CM_NE:
    begin
      rb := iCompare(n1,n2) = CR_NE  ;
    end;
  end;
  if rb then
  result := TLispNode.create('',nil,TT_TRUE) else
  result := TLispNode.create('',nil,TT_FALSE);
end;


function TLispList.lload: TLispNode;
var
  i : integer ;
  l : TLispList ;
  stream : TFileStream ;
  t : string ;
begin
  checkSizeEquals(2);
  nth(1).iEvaluate.checkStr ;
  t := nth(1).iEvaluate.getStr ;
  stream := TFileStream.create(t,fmOpenRead);
  try
    try
    l := lispLang.byLoad(stream);
    result := TLispNode.create ('',l,TT_LIST,true);
    except
      raise ELispFileNotExist.Create;
    end;
  finally   
    stream.Free ;
  end;

end;

function TLispList.lnth: TLispNode;
var
 i : integer;
 l : TLispList ;
begin
  checkSizeEquals(3);
  nth(1).iEvaluate.checkList ;
  nth(2).iEvaluate.checkInt ;
  i := nth(2).iEvaluate.getInt ;
  l := nth(1).iEvaluate.getList ;
  result := l.nth(i-1);
end;
// (print (len (quote(print "Hello Liusp"))))
function TLispList.llen: TLispNode;
var
  l : TLispList ;
begin
  checkSizeEquals(2);
  nth(1).iEvaluate.checkList;
  l := nth(1).iEvaluate.getList  ;
  result := TLispNode.create (inttoStr(l.size),nil,TT_INT);
end;

function TLispList.lhomedir: TLispNode;
begin
  Result := TLispNode.create (ExtractFilePath(application.ExeName),nil,TT_STRING);
end;

function TLispList.GetIndent(Level: Integer): String;
var
  J : Integer ;
begin
  Result := '';
  for j := 1 to level-1 do Result := Result  + '  ' ;
end;

procedure TLispList.checkSizeEquals(A: Integer);
begin
  checkSizeEquals([A]);
end;

procedure TLispList.checkSizeEquals(A: array of Integer);
var
  i : integer ;
  r : Boolean ;
begin
  r := False ;
  for i := low(A) to high(A) do
    r := r or (size = A[i] );
  if not r then
    raise ELispParameterSize.create;//
end;


function TLispList.ltestpackage: TLispNode;
var
  i :Integer ;
begin
  output('TestPackage'+#10);
  for i := low(LispLang.FPackageList) to high(LispLang.FPackageList) do begin
    output('###Name  :'+LispLang.FPackageList[i].GetName +#10);
    output('   Src   :'+LispLang.FPackageList[i].GetTestSrc+#10);
    output('   Result:');
    LispLang.EvalStr(LispLang.FPackageList[i].GetTestSrc);
    output(#10);
  end;
  result := TLispNode.create('',nil,TT_NULL,true) ;
end;

function TLispList.ldefun: TLispNode;
var
  i : integer ;
  token : string;
  tokenNode : TLispNode ;
  valueNode : TLispNode ;
  ll : TLispList ;
  //(defun a (bb) (print bb))  (a 4)
begin
  self.checkSizeGE(3);
  self.nth(1).CheckToken ;  //FunctionName
  self.nth(2).CheckList ; //Args
  ll := TLispList.create;
  for i := 2 to size -1 do
    ll.append(nth(i));
  //result := TLispNode.create('',ll,TT_LIST,true);
  result := TLispNode.create('',ll,TT_LIST);
  //LispLang.funcList.setValue(self.nth(1).GetStr,Result.iDup);
end;

procedure TLispList.checkSizeGE(A: Integer);
var
  i : integer ;
  r : Boolean ;
begin
  r := False ;
  if self.size < A then
    raise ELispParameterSize.create;//
end;

function TLispList.luserdefun(fName: String): TLispNode;
var
  FuncBody,Arg,n2 : TLispNode ;
  i : Integer ;
begin
  FuncBody := LispLang.funcList.getValue(fName);
  Arg  := FuncBody.GetList.nth(0) ; //Arg
  if Self.size <> Arg.getList.size + 1 then
    Raise ELispParameterSize.Create ;
  for i := 1 to self.size -1 do
    LispLang.varList.setValue(Arg.getList.nth(i-1).GetStr,nth(i).iEvaluate);
  for i := 1 to FuncBody.GetList.size -1 do
    Result := FuncBody.getList.nth(i).iEvaluate ;
end;

{ TLispNode }



procedure TLispNode.checkBool;
begin
  if not(datatype  in [ TT_TRUE,TT_FALSE]) then
    raise ELispParameterTypeNotMatch.Create;
end;

procedure TLispNode.checkInt;
begin
  if datatype <> TT_INT then
    raise ELispParameterTypeNotMatch.Create ;
end;

procedure TLispNode.checkList;
begin
  if datatype <> TT_LIST then
    raise ELispParameterTypeNotMatch.Create;
end;

procedure TLispNode.checkNumb;
begin
  if datatype <> TT_NUMB then
    raise ELispParameterTypeNotMatch.Create;
end;

procedure TLispNode.checkStr;
begin
  if datatype <> TT_STRING then
    raise ELispParameterTypeNotMatch.Create;
end;

procedure TLispNode.checkToken;
begin
  if datatype <> TT_TOKEN then
    raise ELispParameterTypeNotMatch.Create;
end;

constructor TLispNode.create(token: string; ll : TLispList;dt: integer;toReturnList:boolean=false);
begin
  Indent := '';
  Level:=0 ;
  isAtom := true ;
  datatype := dt ;
  case dt of
  TT_NUMB :
    entity := token ;
  TT_STRING:
  entity := token ;
  TT_TOKEN :
  entity := token ;
  TT_INT :
  entity := token ;
  TT_NULL :
  ;
  TT_TRUE :
  ;
  TT_FALSE :
  ;
  TT_LIST :
  begin
   lispList := ll ;
   isAtom := false ;
  end;
  end;
  if toReturnList then
    LispLang.returnList.append(self);
end;

destructor TLispNode.destroy;
begin
  if ( TT_LIST = datatype ) then
  begin
    if (lispList <> nil) then
    lispList.free ;
  end else
    ;//output('dispose list');
end;

function TLispNode.getBool: Boolean;
begin
  Result := datatype = TT_True ;
end;

function TLispNode.getInt: Integer;
begin
  result := strtoint(entity);
end;

function TLispNode.getList: TLispList;
begin
  result := lispList ;
end;

function TLispNode.getNumb: double;
begin
  result := strtoFloat(entity);
end;

function TLispNode.getStr: String;
begin
  result := entity ;
end;

function TLispNode.iDup: TLispNode;
begin

  if isAtom then
  begin
    //Result := TLispNode.create(entity,nil,datatype,true);
    Result := TLispNode.create(entity,nil,datatype);
  end else
  begin
    //Result := TLispNode.create('',lispList.iDup,TT_LIST,true);
    Result := TLispNode.create('',lispList.iDup,TT_LIST);
  end;

end;

function TLispNode.iEvaluate: TLispNode;
var
  i :integer ;
begin
  if isAtom  then
  begin
    case datatype of
    TT_TOKEN:
    begin
      if entity = 'true' then
        result := TLispNode.create('',nil,TT_TRUE)
      else if entity = 'false' then
        result := TLispNode.create('',nil,TT_FALSE)
      else if entity = 'nil' then
        result := TLispNode.create('',nil,TT_NULL)
      else
      begin
        result := LispLang.VarValue(entity);
        if result = nil then
        begin
          raise ELispTokenNotInit.Create(entity) ;
        end;
      end;
    end;
    else
        result := self ;
    end;
  end else
    result := lispList.iEvaluate ;
end;

function TLispNode.iPrint: TLispNode;
var
  i ,j: integer;
begin
   result := self ;
   if isAtom then
   begin
     case datatype of
     TT_STRING:
       output(QuotedStr(entity)) ;
     TT_NULL:
       output('nil');
     TT_TRUE:
       output('true');
     TT_FALSE:
       output('false');
     else
       output(entity);
     end;
     output(' ');
   end   else
     result := lispList.iPrint ;
end;

function TLispLang.VarValue(s: String): TLispNode;
begin
  result := TLispNode(varList.getValue(s));
end;


function TLispNode.isInt: boolean;
begin
  result := datatype = TT_INT ;
end;

function TLispNode.isList: boolean;
begin
  result := datatype = TT_LIST ;
end;

function TLispNode.isNumb: boolean;
begin
  result := datatype = TT_NUMB ;
end;

function TLispNode.isStr: boolean;
begin
  result := datatype = TT_STRING ;
end;

procedure TLispNode.registerToReturnList;
begin
  LispLang.returnList.append(self);
end;

{ THashTable }

constructor THashTable.create;
begin
  sorted := true ;
end;
// todo 1
destructor THashTable.destroy;
var
  i : integer ;
begin
  for i:=0 to Count -1 do
  begin
    TLispNode(Objects[i]).Free ;  //NOT SOLVE !!!
  end;
end;

function THashTable.getValue(Index: string): TLispNode;
var
  i :integer ;
begin
  result := nil ;
  if find(index,i) then
    result := TLispNode(Objects[i]);
end;

procedure THashTable.setValue(Index: string; obj: TLispNode);
var
  i :integer ;
  ln : TLispNode ;
begin
  // setvalue must copy a object ,else will "invalid pointer operation" when system exit
  if obj.datatype = TT_LIST then
    ln := TLispNode.create('',obj.lispList.idup,obj.datatype)
  else
    ln := TLispNode.create(obj.entity,nil,obj.datatype);
  // change copy tranmit to evaluate ,for simplize
  //ln := obj ;
  if find(Index,i) then
  begin
   Objects[i].free ;
   //Objects[i] :=  obj
   Objects[i] :=  ln ;
  end
  else
     //addObject(Index,obj);
     addObject(Index,ln);
end;

function TLispList.ladd:TLispNode;
begin
  result := iADMD(1);
end;
procedure TLispLang.tPrint1(ln: TLispNode);
begin
    ln.iPrint ;
end;

function TLispLang.returnlistSize: integer;
begin
  result := returnList.size ;
end;


procedure TLispLang.returnlistPrint;
begin
  returnlist.iPrint ;
end;

procedure TLispLang.returnlistClear ;
begin
  returnList.free ;
  returnList := TLispList.create ;
end;

procedure TLispLang.nodeListPrint;
begin
  nodelist.iPrint ;
end;

function TLispLang.byLoad(s: TStream): TLispList;
var
 f : Integer ;
 t : string ;
 historyStack : TStack ;
 list ,currList,tempList: TLispList ;
 tempNode : TLispNode ;
begin
  FParser.load(s);
  historyStack := TStack.Create ;
  list := TLispList.create ;
  currList := list ;
  f := FParser.nextToken(t) ;
  while (f > TT_EOF) do
  begin
    if (f = TT_NUMB) or (f = TT_INT) or(f = TT_TOKEN ) or (f = TT_STRING) then
    begin
      tempNode := TLispNode.create(t,nil,f);
      currList.append(tempNode);
    end
    else
    begin
      if f = TT_LEFT then
      begin
        tempList := TLispList.create ;
        tempNode := TLispNode.create('',tempList,TT_LIST);
        currList.append(tempNode);
        historyStack.push(currList);
        currList := tempList ;
      end else
      if f = TT_RIGHT then
      begin
        currList := TLisplist(historyStack.pop);
      end;
    end;
    T := '' ;f := FParser.nextToken(t);
  end;
  if (f = TT_NOTMATCH)then
    output('"不匹配');
  if historyStack.Count <> 0 then
    output('括号不匹配');

  historyStack.free ;
  //NodeList := list ;
  // result is ===
  result := list ;
end;
function  TLispLang.EvalFile (FileName : String):TLispList;
var
 t : string ;
 F : Integer ;
 S :TMemorystream ;
 p : TLispParser ;
 r : TLispNode ;
 fs : TFileStream ;
 sl : TStringList;
begin
  try
      sl := TStringList.Create ;
      EvalStr(sl.Text);
  finally
    sl.free ;
  end;       
end;

function  TLispLang.EvalStr (ListStr : String):TLispList ;
var
  MS : TStringStream ;
var
 t : string ;
 F : Integer ;
 S :TMemorystream ;
 p : TLispParser ;
 r : TLispNode ;
 fs : TFileStream ;
 sl : TStringList;
begin
  MS := TStringStream.Create (ListStr);
  //.WriteString(ListStr,Length(ListStr));
  try
  // change 2004/11/11
  iLoad(Ms);
  //NodeList := byLoad(s) ;
  self.lEvaluate ;
  except
    on E : ElispTokenNotInit do
      output(e.Message);
    on E : ELispSize do
      output(e.Message);
    on E : ELispParameterNotEnough do
      output(e.Message);
    on E : ELispParameterTypeNotMatch do
      output(e.Message);
    on E : ELispParameterSize do
      output(e.Message);
    on E : ELispFileNotExist do
      output(e.Message);
    on E : ELispNthIndexOver do
      output(e.Message);
    on E : EFOpenError do
      output('文件找不到');
    on E : ENetNoConnection do
      output('无法连接网络:'+e.Message);
    on E : ELispNoFunction do
      output(e.Message);
    on E : Exception do
      output('Unknown Except:'+e.Message);
  end;
end;

procedure TLispLang.iLoad(FileName: String);
var
  FS : TFileStream ;
begin
  FS := TFileStream.Create(FileName,fmOpenRead) ;
  try
    iLoad(FS);
  finally
   FS.Free ;
  end;
end;
function TLispLang.iCallPackage(fName : String;list:TLispList): TLispNode ;
var
  i : Integer ;
  il : ILispPackage ;
begin
  Result := nil ;
  for i := low(FPackageList) to high(FPackageList) do begin
    Result := FPackageList[i].CallFunction(fName,list);
    if not (Result = nil) then
      break ;
  end;
end;
{ TLispPackageBase }

function TLispPackageBase.CallFunction(fnName: String;
  list: TLispList): TLispNode;
begin
  Result := nil ;
end;

function TLispPackageBase.GetName: String;
begin
  Result := 'No Name';
end;

function TLispPackageBase.GetTestSrc: String;
begin
  Result := '(+ 1 1 )';
end;
  {

 When you will add new lisp function in TLispList,
 you can write code by the template:

 1.   get  lispNodes ;
 2.  foreach other element .deal by your function
      for i := 1 to localNodes.Count -1 do
      begin
      end;
 3. constructor ListNode for return
      result := TLispNode.create(token,lispList,datatype);
 4. remember return pointer ,so I can dispose later
     LispLang.returnList.append(result);

 Or you can copy it directly :

     //  lispNodes ;
     for i := 1 to lispNodes.Count -1 do
     begin
     end;
     result := TLispNode.create(token,lispList,datatype,true);

  }

end.


