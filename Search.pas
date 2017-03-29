unit Search;

{$I Default.inc}

interface

uses
  Utils, Global;

function FindEngine: Boolean;

implementation

function FindEngine: Boolean;
var
  Lib: HMODULE;
begin
  {$IFDEF MSWINDOWS}
  Lib := GetModuleHandle('swds.dll');
  {$ELSE}
  Lib := GetModuleHandle('engine_i486.dll');
  {$ENDIF}

  if Lib = 0 then
  begin
    Print('Failed to find engine library.'#10);
    Result := False;
  end
  else
  begin
    EngineBase := Lib;
    Result := True;
  end;
end;

end.
