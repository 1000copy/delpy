unit ulangException;

interface
uses sysutils ;
type
  ELispTokenNotInit = class(Exception)
    constructor Create(T : String);
  end;
  ELispSize = class(Exception);
  ELispParameterNotEnough=class(Exception);
  ELispParameterTypeNotMatch=class(Exception)
    constructor Create;
  end;
  ELispParameterSize=class(Exception)
    constructor Create;
  end;
  ELispFileNotExist=class(Exception)
  constructor Create;
  end;
  ELispNthIndexOver=class(Exception)
    constructor Create(S,I : Integer);
  end;
  ELispNoFunction =class(Exception)
    constructor Create(fn :String);
  end;


implementation

{ ELispNoFunction }

constructor ELispNoFunction.Create(fn :String);
begin
  inherited Create('ELispNoFunction :'+fn)
end;

{ ELispParameterTypeNotMatch }

constructor ELispParameterTypeNotMatch.Create;
begin
  inherited Create('ELispParameterTypeNotMatch ')
end;

{ ELispParameterSize }

constructor ELispParameterSize.Create;
begin
  inherited Create('ELispParameterSize ')
end;

{ ELispFileNotExist }

constructor ELispFileNotExist.Create;
begin
  inherited Create('ELispFileNotExist ')

end;

{ ELispTokenNotInit }

constructor ELispTokenNotInit.Create(T: String);
begin
  inherited Create('ELispTokenNotInit: '+T)
end;

{ ELispNthIndexOver }

constructor ELispNthIndexOver.Create(S, I: Integer);
begin
  inherited Create(Format('ELispNthIndexOver,Index=%d,Size=%d ',[I,S]));
end;

{ ELispFileNotFound }

//

end.
