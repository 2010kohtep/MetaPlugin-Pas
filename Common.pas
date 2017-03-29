unit Common;

{$I Default.inc}

interface

uses
  {$IFDEF LINUX}Libc, {$ENDIF}SysUtils, Utils, Global, Math, SDK, Search;

function Init: Integer;

implementation

uses
  Cmds;

function Init: Integer;
begin
  Result := Ord(False);

  if not FindEngine then
    Exit;

  Engine.AddServerCommand('example', @Cmd_Example_f);

  Result := Ord(True);
end;

end.
