unit Cmds;

{$I Default.inc}

interface

uses
  Utils;

procedure Cmd_Example_f; cdecl;

implementation

procedure Cmd_Example_f; cdecl;
begin
  Print('Example command.'#10);
end;

end.
