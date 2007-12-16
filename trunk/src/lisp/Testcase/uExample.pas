unit uExample;

interfaceuses  Classes, SysUtils,  TestFrameWork;type  TTestcaseTemplate = class(TTestCase)  protected    procedure SetUp; override;    procedure TearDown; override;  published    procedure TestOnePlusOne;
  end;implementation

{ TTestCaseList }

//------------------------------------------------------------------------------
procedure TTestcaseTemplate.SetUp;beginend;procedure TTestcaseTemplate.TearDown;
var
begin
end;

procedure TTestcaseTemplate.TestOnePlusOne;begin
  Check(2=1+1,'OnePlusOneNotEqualsTwo');
end;
initialization
  RegisterTest('', TTestcaseTemplate.Suite);end.
