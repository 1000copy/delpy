unit TListTestCase;

interface

uses
  Classes, SysUtils,
  TestFrameWork;
type
  TTestCaseList = class(TTestCase)
  private
    FEmpty: TList;
    FFull: TList;

  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestQuote;
    procedure TestQuote1;
    procedure testAdd;
  end;

implementation
uses uLang;
procedure TTestCaseList.SetUp;
begin
end;
procedure TTestCaseList.TearDown;
begin
end;

procedure TTestCaseList.TestAdd;
var
  n : TLispNode ;
begin
  n := LispLang.EvalStr('(print 2)');
  Check (n.isInt = true,'Not Success');
  Check(n.getInt = 2 ,'Not 2');
end;
procedure TTestCaseList.TestQuote;
var
  n : TLispNode ;
begin
  n := LispLang.EvalStr('(quote 2)');
  Check (n.isInt = true,'Not Success');
  n := LispLang.EvalStr('(quote (2))');
  Check (n.isList = true,'Not Success');
end;
procedure TTestCaseList.TestQuote1;
var
  n : TLispNode ;
begin
  n := LispLang.EvalStr('(downfile "www.163.com" "/" "c:\ff.htm")');
  n := LispLang.EvalStr('(ftp "user" "password" "ftp.163.com" "/adir" "c:\ff.htm"  3)');
end;

initialization
  RegisterTest('', TTestCaseList.Suite);
end.
