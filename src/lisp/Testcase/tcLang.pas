unit tcLang;
interface
uses
  Classes, SysUtils,
  TestFrameWork,uLang;
type
  TtcLang = class(TTestCase)
  private

  protected    procedure SetUp; override;    procedure TearDown; override;  published    procedure testAdd;  end;
implementation

procedure TtcLang.SetUp;
beginend;procedure TtcLang.TearDown;
begin
end;

procedure TtcLang.TestAdd;begin   LispLang.EvalStr('(print "ab")');  //check(1=1+0,'Error');end;initialization  RegisterTest('', TtcLang.Suite);
end;
end.

