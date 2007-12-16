unit TListTestCase1;interface
uses
  Classes, SysUtils,
  TestFrameWork;
type
  TTestCaseList1 = class(TTestCase)
  private

  protected    procedure SetUp; override;    procedure TearDown; override;  published    procedure testAdd;  end;
implementation
procedure TTestCaseList1.SetUp;
beginend;procedure TTestCaseList1.TearDown;
begin
end;

procedure TTestCaseList1.TestAdd;begin  check(1=1+0,'Error');
end;initialization
  RegisterTest('', TTestCaseList1.Suite);
end.
