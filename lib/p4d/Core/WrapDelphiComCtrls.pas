unit WrapDelphiComCtrls;

{$I Definition.Inc}

interface

uses
  Classes, SysUtils, PythonEngine, WrapDelphi, WrapDelphiClasses,
  WrapDelphiControls, Windows, ComCtrls, TypInfo;

type
  TTabChangingEventHandler = class(TEventHandler)
  protected
    procedure DoEvent(Sender: TObject; var AllowChange: Boolean);
  public
    constructor Create(PyDelphiWrapper : TPyDelphiWrapper; Component : TObject;
      PropertyInfo : PPropInfo; Callable : PPyObject); override;
    class function GetTypeInfo : PTypeInfo; override;
  end;

  TPyDelphiDateTimePicker = class (TPyDelphiWinControl)
  private
    function  GetDelphiObject: TDateTimePicker;
    procedure SetDelphiObject(const Value: TDateTimePicker);
  public
    class function  DelphiObjectClass : TClass; override;
    // Properties
    property DelphiObject: TDateTimePicker read GetDelphiObject write SetDelphiObject;
  end;

  TPyDelphiTabSheet = class (TPyDelphiWinControl)
  private
    function  GetDelphiObject: TTabSheet;
    procedure SetDelphiObject(const Value: TTabSheet);
  protected
    // Property Getters
    function Get_TabIndex( AContext : Pointer) : PPyObject; cdecl;
    function Get_PageControl( AContext : Pointer) : PPyObject; cdecl;
    // Property Setters
    function Set_PageControl( AValue : PPyObject; AContext : Pointer) : integer; cdecl;
  public
    class function  DelphiObjectClass : TClass; override;
    class procedure RegisterGetSets( PythonType : TPythonType ); override;
    // Properties
    property DelphiObject: TTabSheet read GetDelphiObject write SetDelphiObject;
  end;

  {
    Access to the child pages of a TPageControl.Pages collection.
  }
  TPagesAccess = class(TContainerAccess)
  private
    function GetContainer: TPageControl;
  public
    function GetItem(AIndex : Integer) : PPyObject; override;
    function GetSize : Integer; override;
    function IndexOf(AValue : PPyObject) : Integer; override;

    class function ExpectedContainerClass : TClass; override;
    class function SupportsIndexOf : Boolean; override;
    class function Name : String; override;

    property Container : TPageControl read GetContainer;
  end;

  TPyDelphiPageControl = class (TPyDelphiWinControl)
  private
    function  GetDelphiObject: TPageControl;
    procedure SetDelphiObject(const Value: TPageControl);
  protected
    // methods
    function  IndexOfTabAt_Wrapper(args : PPyObject) : PPyObject; cdecl;
    function  GetHitTestInfoAt_Wrapper(args : PPyObject) : PPyObject; cdecl;
    function  TabRect_Wrapper(args : PPyObject) : PPyObject; cdecl;
    function  ScrollTabs_Wrapper(args : PPyObject) : PPyObject; cdecl;
    function  FindNextPage_Wrapper(args : PPyObject) : PPyObject; cdecl;
    function  SelectNextPage_Wrapper(args : PPyObject) : PPyObject; cdecl;
    // Property Getters
    function Get_ActivePage( AContext : Pointer) : PPyObject; cdecl;
    function Get_ActivePageIndex( AContext : Pointer) : PPyObject; cdecl;
    function Get_Canvas( AContext : Pointer) : PPyObject; cdecl;
    function Get_PageCount( AContext : Pointer) : PPyObject; cdecl;
    function Get_Pages( AContext : Pointer) : PPyObject; cdecl;
    function Get_RowCount( AContext : Pointer) : PPyObject; cdecl;
    // Property Setters
    function Set_ActivePage( AValue : PPyObject; AContext : Pointer) : integer; cdecl;
    function Set_ActivePageIndex( AValue : PPyObject; AContext : Pointer) : integer; cdecl;
  public
    class function  DelphiObjectClass : TClass; override;
    class procedure RegisterGetSets( PythonType : TPythonType ); override;
    class procedure RegisterMethods( PythonType : TPythonType ); override;
    // Properties
    property DelphiObject: TPageControl read GetDelphiObject write SetDelphiObject;
  end;

implementation

uses
  WrapDelphiTypes;

{ Register the wrappers, the globals and the constants }
type
  TComCtrlsRegistration = class(TRegisteredUnit)
  public
    function Name : String; override;
    procedure RegisterWrappers(APyDelphiWrapper : TPyDelphiWrapper); override;
    procedure DefineVars(APyDelphiWrapper : TPyDelphiWrapper); override;
  end;

{ TComCtrlsRegistration }

procedure TComCtrlsRegistration.DefineVars(APyDelphiWrapper: TPyDelphiWrapper);
begin
  inherited;
end;

function TComCtrlsRegistration.Name: String;
begin
  Result := 'ComCtrls';
end;

procedure TComCtrlsRegistration.RegisterWrappers(APyDelphiWrapper: TPyDelphiWrapper);
begin
  inherited;
  APyDelphiWrapper.RegisterDelphiWrapper(TPyDelphiDateTimePicker);
  APyDelphiWrapper.RegisterDelphiWrapper(TPyDelphiPageControl);
  APyDelphiWrapper.RegisterDelphiWrapper(TPyDelphiTabSheet);

  APyDelphiWrapper.EventHandlers.RegisterHandler(TTabChangingEventHandler);
end;

{ TPyDelphiDateTimePicker }

class function TPyDelphiDateTimePicker.DelphiObjectClass: TClass;
begin
  Result := TDateTimePicker;
end;

function TPyDelphiDateTimePicker.GetDelphiObject: TDateTimePicker;
begin
  Result := TDateTimePicker(inherited DelphiObject);
end;

procedure TPyDelphiDateTimePicker.SetDelphiObject(const Value: TDateTimePicker);
begin
  inherited DelphiObject := Value;
end;

{ TPyDelphiPageControl }

class function TPyDelphiPageControl.DelphiObjectClass: TClass;
begin
  Result := TPageControl;
end;

function TPyDelphiPageControl.FindNextPage_Wrapper(
  args: PPyObject): PPyObject;
var
  _CurPage: TObject;
  _pCurPage: PPyObject;
  _pGoForward, _pCheckTabVisible: PPyObject;
begin
  //  function FindNextPage(CurPage: TTabSheet; GoForward, CheckTabVisible: Boolean): TTabSheet;
  with GetPythonEngine do begin
    // We adjust the transmitted self argument
    Adjust(@Self);
    if PyArg_ParseTuple( args, 'OOO:FindNextPage', [@_pCurPage, @_pGoForward, @_pCheckTabVisible] ) <> 0 then begin
      if CheckObjAttribute(_pCurPage, 'CurPage', TTabSheet, _CurPage) then
        Result := Wrap( DelphiObject.FindNextPage(TTabSheet(_CurPage), PyObject_IsTrue(_pGoForward)<>0, PyObject_IsTrue(_pCheckTabVisible)<>0) )
      else
        Result := nil;
    end else
      Result := nil;
  end;
end;

function TPyDelphiPageControl.GetDelphiObject: TPageControl;
begin
  Result := TPageControl(inherited DelphiObject);
end;

function TPyDelphiPageControl.GetHitTestInfoAt_Wrapper(
  args: PPyObject): PPyObject;

  procedure AppendString(const AText : String);
  var
    _text : PPyObject;
  begin
    with GetPythonEngine do
    begin
      _text := PyString_FromString(PChar(AText));
      PyList_Append(Result, _text);
      Py_DecRef(_text);
    end;
  end;

var
  x, y: Integer;
  _result : THitTests;
begin
  with GetPythonEngine do begin
    // We adjust the transmitted self argument
    Adjust(@Self);
    if PyArg_ParseTuple( args, 'ii:GetHitTestInfoAt', [@x, @y] ) <> 0 then begin
      _result := DelphiObject.GetHitTestInfoAt(x, y);
      Result := PyList_New(0);
      if htAbove in _result then
        AppendString('htAbove');
      if htBelow in _result then
        AppendString('htBelow');
      if htNowhere in _result then
        AppendString('htNowhere');
      if htOnItem in _result then
        AppendString('htOnItem');
      if htOnButton in _result then
        AppendString('htOnButton');
      if htOnIcon in _result then
        AppendString('htOnIcon');
      if htOnIndent in _result then
        AppendString('htOnIndent');
      if htOnLabel in _result then
        AppendString('htOnLabel');
      if htOnRight in _result then
        AppendString('htOnRight');
      if htOnStateIcon in _result then
        AppendString('htOnStateIcon');
      if htToLeft in _result then
        AppendString('htToLeft');
      if htToRight in _result then
        AppendString('htToRight');
    end else
      Result := nil;
  end;
end;

function TPyDelphiPageControl.Get_ActivePage(AContext: Pointer): PPyObject;
begin
  Result := Wrap(DelphiObject.ActivePage);
end;

function TPyDelphiPageControl.Get_ActivePageIndex(
  AContext: Pointer): PPyObject;
begin
  with GetPythonEngine do begin
    Adjust(@Self);
    Result := PyInt_FromLong(DelphiObject.ActivePageIndex);
  end;
end;

function TPyDelphiPageControl.Get_Canvas(AContext: Pointer): PPyObject;
begin
  Result := Wrap(DelphiObject.Canvas);
end;

function TPyDelphiPageControl.Get_PageCount(AContext: Pointer): PPyObject;
begin
  with GetPythonEngine do begin
    Adjust(@Self);
    Result := PyInt_FromLong(DelphiObject.PageCount);
  end;
end;

function TPyDelphiPageControl.Get_Pages(AContext: Pointer): PPyObject;
begin
  with GetPythonEngine do begin
    Adjust(@Self);
    Result := Self.PyDelphiWrapper.DefaultContainerType.CreateInstance;
    with PythonToDelphi(Result) as TPyDelphiContainer do
      Setup(Self.PyDelphiWrapper, TPagesAccess.Create(Self.PyDelphiWrapper, Self.DelphiObject));
  end;
end;

function TPyDelphiPageControl.Get_RowCount(AContext: Pointer): PPyObject;
begin
  with GetPythonEngine do begin
    Adjust(@Self);
    Result := PyInt_FromLong(DelphiObject.RowCount);
  end;
end;

function TPyDelphiPageControl.IndexOfTabAt_Wrapper(
  args: PPyObject): PPyObject;
var
  x, y: Integer;
begin
  with GetPythonEngine do begin
    // We adjust the transmitted self argument
    Adjust(@Self);
    if PyArg_ParseTuple( args, 'ii:IndexOfTabAt', [@x, @y] ) <> 0 then begin
      Result := VariantAsPyObject( DelphiObject.IndexOfTabAt(x, y) );
    end else
      Result := nil;
  end;
end;

class procedure TPyDelphiPageControl.RegisterGetSets(
  PythonType: TPythonType);
begin
  inherited;
  PythonType.AddGetSet('ActivePage', @TPyDelphiPageControl.Get_ActivePage, @TPyDelphiPageControl.Set_ActivePage,
        'Specifies the page currently displayed by the page control.', nil);
  PythonType.AddGetSet('ActivePageIndex', @TPyDelphiPageControl.Get_ActivePageIndex, @TPyDelphiPageControl.Set_ActivePageIndex,
        'Specifies the page currently displayed by the page control.', nil);
  PythonType.AddGetSet('Canvas', @TPyDelphiPageControl.Get_Canvas, nil,
        'Gives access to the tab controlís canvas.', nil);
  PythonType.AddGetSet('PageCount', @TPyDelphiPageControl.Get_PageCount, nil,
        'Indicates the number of pages in the TPageControl object.', nil);
  PythonType.AddGetSet('Pages', @TPyDelphiPageControl.Get_Pages, nil,
        'Lists all the pages in the TPageControl.', nil);
  PythonType.AddGetSet('RowCount', @TPyDelphiPageControl.Get_RowCount, nil,
        '', nil);
end;

class procedure TPyDelphiPageControl.RegisterMethods(
  PythonType: TPythonType);
begin
  inherited;
  PythonType.AddMethod('IndexOfTabAt', @TPyDelphiPageControl.IndexOfTabAt_Wrapper,
    'TPageControl.IndexOfTabAt()'#10 +
    'Indicates the index of the tab at a specified point.');
  PythonType.AddMethod('GetHitTestInfoAt', @TPyDelphiPageControl.GetHitTestInfoAt_Wrapper,
    'TPageControl.GetHitTestInfoAt()'#10 +
    'Returns information about the location of a point relative to the client area of the tab control.');
  PythonType.AddMethod('TabRect', @TPyDelphiPageControl.TabRect_Wrapper,
    'TPageControl.TabRect()'#10 +
    'Returns the bounding rectangle for a specified tab.');
  PythonType.AddMethod('ScrollTabs', @TPyDelphiPageControl.ScrollTabs_Wrapper,
    'TPageControl.ScrollTabs()'#10 +
    'Scrolls the tabs that are visible when the tab control is not multi-line.');
  PythonType.AddMethod('FindNextPage', @TPyDelphiPageControl.FindNextPage_Wrapper,
    'TPageControl.FindNextPage()'#10 +
    'Returns the next page in the page control before or after a specified page.');
  PythonType.AddMethod('SelectNextPage', @TPyDelphiPageControl.SelectNextPage_Wrapper,
    'TPageControl.SelectNextPage()'#10 +
    'Changes the ActivePage to the first visible page that is before or after the currently active page.');
end;

function TPyDelphiPageControl.ScrollTabs_Wrapper(
  args: PPyObject): PPyObject;
var
  delta: Integer;
begin
  with GetPythonEngine do begin
    // We adjust the transmitted self argument
    Adjust(@Self);
    if PyArg_ParseTuple( args, 'i:ScrollTabs', [@delta] ) <> 0 then begin
      DelphiObject.ScrollTabs(delta);
      Result := ReturnNone;
    end else
      Result := nil;
  end;
end;

function TPyDelphiPageControl.SelectNextPage_Wrapper(
  args: PPyObject): PPyObject;
var
  _pGoForward, _pCheckTabVisible: PPyObject;
begin
  // procedure SelectNextPage(GoForward: Boolean; CheckTabVisible: Boolean = True);
  with GetPythonEngine do begin
    // We adjust the transmitted self argument
    Adjust(@Self);
    if PyArg_ParseTuple( args, 'OO:SelectNextPage', [@_pGoForward, @_pCheckTabVisible] ) <> 0 then begin
      DelphiObject.SelectNextPage(PyObject_IsTrue(_pGoForward)<>0{$IFDEF DELPHI6_OR_HIGHER}, PyObject_IsTrue(_pCheckTabVisible)<>0{$ENDIF});
      Result := ReturnNone;
    end else
      Result := nil;
  end;

end;

procedure TPyDelphiPageControl.SetDelphiObject(const Value: TPageControl);
begin
  inherited DelphiObject := Value;
end;

function TPyDelphiPageControl.Set_ActivePage(AValue: PPyObject;
  AContext: Pointer): integer;
var
  _object : TObject;
begin
  with GetPythonEngine do begin
    Adjust(@Self);
    if CheckObjAttribute(AValue, 'ActivePage', TTabSheet, _object) then
    begin
      Self.DelphiObject.ActivePage := TTabSheet(_object);
      Result := 0;
    end
    else
      Result := -1;
  end;
end;

function TPyDelphiPageControl.Set_ActivePageIndex(AValue: PPyObject;
  AContext: Pointer): integer;
var
  _value : Integer;
begin
  with GetPythonEngine do begin
    Adjust(@Self);
    if CheckIntAttribute(AValue, 'ActivePageIndex', _value) then
    begin
      DelphiObject.ActivePageIndex := _value;
      Result := 0;
    end
    else
      Result := -1;
  end;
end;

function TPyDelphiPageControl.TabRect_Wrapper(args: PPyObject): PPyObject;
var
  idx: Integer;
begin
  with GetPythonEngine do begin
    // We adjust the transmitted self argument
    Adjust(@Self);
    if PyArg_ParseTuple( args, 'i:TabRect', [@idx] ) <> 0 then begin
      Result := WrapRect(PyDelphiWrapper, DelphiObject.TabRect(idx));
    end else
      Result := nil;
  end;
end;

{ TPyDelphiTabSheet }

class function TPyDelphiTabSheet.DelphiObjectClass: TClass;
begin
  Result := TTabSheet;
end;

function TPyDelphiTabSheet.GetDelphiObject: TTabSheet;
begin
  Result := TTabSheet(inherited DelphiObject);
end;

function TPyDelphiTabSheet.Get_PageControl(AContext: Pointer): PPyObject;
begin
  with GetPythonEngine do begin
    Adjust(@Self);
    Result := Wrap(DelphiObject.PageControl);
  end;
end;

function TPyDelphiTabSheet.Get_TabIndex(AContext: Pointer): PPyObject;
begin
  with GetPythonEngine do begin
    Adjust(@Self);
    Result := PyInt_FromLong(DelphiObject.TabIndex);
  end;
end;

class procedure TPyDelphiTabSheet.RegisterGetSets(PythonType: TPythonType);
begin
  inherited;
  PythonType.AddGetSet('TabIndex', @TPyDelphiTabSheet.Get_TabIndex, nil,
        'Indicates the position of the tab sheet in the set of visible tabs in a TPageControl object.', nil);
  PythonType.AddGetSet('PageControl', @TPyDelphiTabSheet.Get_PageControl, @TPyDelphiTabSheet.Set_PageControl,
        'Indicates the page control object that contains the tab sheet.', nil);
end;

procedure TPyDelphiTabSheet.SetDelphiObject(const Value: TTabSheet);
begin
  inherited DelphiObject := Value;
end;

function TPyDelphiTabSheet.Set_PageControl(AValue: PPyObject;
  AContext: Pointer): integer;
var
  _object : TObject;
begin
  with GetPythonEngine do begin
    Adjust(@Self);
    if CheckObjAttribute(AValue, 'PageControl', TPageControl, _object) then
    begin
      Self.DelphiObject.PageControl := TPageControl(_object);
      Result := 0;
    end
    else
      Result := -1;
  end;
end;

{ TPagesAccess }

class function TPagesAccess.ExpectedContainerClass: TClass;
begin
  Result := TPageControl;
end;

function TPagesAccess.GetContainer: TPageControl;
begin
  Result := TPageControl(inherited Container);
end;

function TPagesAccess.GetItem(AIndex: Integer): PPyObject;
begin
  Result := Wrap( Container.Pages[AIndex] );
end;

function TPagesAccess.GetSize: Integer;
begin
  Result := Container.PageCount;
end;

function TPagesAccess.IndexOf(AValue: PPyObject): Integer;
var
  i : Integer;
  S : string;
  _obj : TPyObject;
  _value : TObject;
  _ctrl : TTabSheet;
begin
  Result := -1;
  with GetPythonEngine do
  begin
    if PyString_Check(AValue) then
    begin
      S := PyString_AsString(AValue);
      for i := 0 to Container.PageCount-1 do
        if SameText( Container.Pages[i].Name, S) then
        begin
          Result := i;
          Break;
        end;
    end
    else if IsDelphiObject(AValue) then
    begin
      _obj := PythonToDelphi(AValue);
      if _obj is TPyDelphiObject then
      begin
        _value := TPyDelphiObject(_obj).DelphiObject;
        if _value is TTabSheet then
        begin
          _ctrl := TTabSheet(_value);
          for i := 0 to Container.PageCount-1 do
            if Container.Pages[i] = _ctrl then
            begin
              Result := i;
              Break;
            end;
        end;
      end;
    end;
  end;
end;

class function TPagesAccess.Name: String;
begin
  Result := 'Pages';
end;

class function TPagesAccess.SupportsIndexOf: Boolean;
begin
  Result := True;
end;

{ TTabChangingEventHandler }

constructor TTabChangingEventHandler.Create(
  PyDelphiWrapper: TPyDelphiWrapper; Component: TObject;
  PropertyInfo: PPropInfo; Callable: PPyObject);
var
  Method : TMethod;
begin
  inherited;
  Method.Code := @TTabChangingEventHandler.DoEvent;
  Method.Data := Self;
  SetMethodProp(Component, PropertyInfo, Method);
end;

procedure TTabChangingEventHandler.DoEvent(Sender: TObject;
  var AllowChange: Boolean);
Var
  PyObject, PyTuple, PyResult, PyAllowChange: PPyObject;
  _varParam : TPyDelphiVarParameter;
begin
  Assert(Assigned(PyDelphiWrapper));
  if Assigned(Callable) and PythonOK then
    with GetPythonEngine do begin
      PyObject := PyDelphiWrapper.Wrap(Sender);
      PyAllowChange := CreateVarParam(PyDelphiWrapper, AllowChange);
      _varParam := PythonToDelphi(PyAllowChange) as TPyDelphiVarParameter;
      PyTuple := PyTuple_New(2);
      GetPythonEngine.PyTuple_SetItem(PyTuple, 0, PyObject);
      GetPythonEngine.PyTuple_SetItem(PyTuple, 1, PyAllowChange);
      try
        PyResult := PyObject_CallObject(Callable, PyTuple);
        if Assigned(PyResult) then
        begin
          Py_DECREF(PyResult);
          AllowChange := PyObject_IsTrue(_varParam.Value) = 1;
        end;
      finally
        Py_DECREF(PyTuple);
      end;
      CheckError;
    end;
end;

class function TTabChangingEventHandler.GetTypeInfo: PTypeInfo;
begin
  Result := System.TypeInfo(TTabChangingEvent);
end;

initialization
  RegisteredUnits.Add( TComCtrlsRegistration.Create );
  Classes.RegisterClasses([TDateTimePicker]);
end.
