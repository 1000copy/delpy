unit TListTestCase;interface
uses
  Classes, SysUtils,
  TestFrameWork;
type
  TTestCaseList = class(TTestCase)
  private
    FEmpty: TList;
    FFull: TList;                  protected    procedure SetUp; override;    procedure TearDown; override;  published    procedure testAdd;    procedure testIndexTooHigh;
    procedure testWillGoWrong;
    procedure testOopsAnError;
  end;

implementation
procedure TTestCaseList.SetUp;
begin
  FEmpty := TList.Create;

  FFull := TList.Create;

  FFull.Add(TObject.Create);
  FFull.Add(TObject.Create);
end;
//------------------------------------------------------------------------------
procedure TTestCaseList.TearDown;
var
  I: Integer;
begin
  for I := 0 to FEmpty.Count - 1 do
    TObject(FEmpty.Items[I]).Free;

  FEmpty.Free;

  for I := 0 to FFull.Count - 1 do
    TObject(FFull.Items[I]).Free;

  FFull.Free;
end;
//------------------------------------------------------------------------------
{
This test checks if an added item is actually in the list.
}
procedure TTestCaseList.TestAdd;
var
  AddObject: TObject;
begin
  AddObject := TObject.Create;

  FEmpty.Add(AddObject);

  Check(FEmpty.Count = 1);
  Check(FEmpty.Items[0] = AddObject);
end;
//------------------------------------------------------------------------------
procedure TTestCaseList.TestIndexTooHigh;
begin
  try
    FFull.Items[2];

    Check(false, 'There should have been an EListError.');
  except on E: Exception do
    begin
      Check(E is EListError);
    end;
  end;
end;
procedure TTestCaseList.TestOopsAnError;
begin
  raise Exception.Create('This error message will show up in TestResult');
end;
procedure TTestCaseList.TestWillGoWrong;
begin
  Check(false, 'This failure message will show up in the TestResult.');
end;
//------------------------------------------------------------------------------

initialization
  RegisterTest('', TTestCaseList.Suite);
end.
