unit Utils;

{$I Default.inc}

interface

uses
  {$IFDEF LINUX} Libc {$ELSE} Windows {$ENDIF}, SysUtils, Global;

function GetModuleHandle(const Name: string): HMODULE;
function GetModuleSize(Module: HMODULE): Cardinal;
function GetProcAddress(Module: HMODULE; const Name: string): Pointer;

function BeginThread(ThreadFunc: TThreadFunc; Parameter: Pointer): Integer;

procedure Print(const Text: string); overload;
procedure Print(const Fmt: string; const Args: array of const); overload; stdcall;

implementation

function GetModuleHandle(const Name: string): HMODULE;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetModuleHandle(PChar(Name));
{$ELSE}
  Result := HMODULE(dlopen(PChar(Name), RTLD_NOW));
{$ENDIF}
end;

function GetModuleSize(Module: HMODULE): Cardinal;
{$IFDEF MSWINDOWS}
var
  Nt: PImageNtHeaders;
begin
  Nt := Pointer(Integer(Module) + PImageDosHeader(Module)^._lfanew);
  Result := Nt^.OptionalHeader.SizeOfImage;
end;
{$ELSE}
begin
  Result := 0;

  {$MESSAGE WARN 'Not implemented.'}
end;
{$ENDIF}

// FIXME: GetDataAddress?
function GetProcAddress(Module: HMODULE; const Name: string): Pointer;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetProcAddress(Module, PChar(Name));
{$ELSE}
  Result := dlsym(Pointer(Module), PChar(Name));
{$ENDIF}
end;

function BeginThread(ThreadFunc: TThreadFunc; Parameter: Pointer): Integer;
begin
  {$IFDEF MSWINDOWS}
  Result := System.BeginThread(nil, 0, ThreadFunc, Parameter, 0, PCardinal(nil)^);
  {$ELSE}
  Result := System.BeginThread(nil, ThreadFunc, Parameter, PCardinal(nil)^);
  {$ENDIF}
end;

procedure Print(const Text: string);
begin
  Write('[', PLUGIN_NAME, '] ', Text);
end;

procedure Print(const Fmt: string; const Args: array of const); stdcall;
var
  Text: string;
begin
  try
    Text := Format(Fmt, Args);
    Print(Text);
  except
    on E: Exception do
    begin
      WriteLn('[', PLUGIN_NAME, '] Print: ', E.Message);
      WriteLn('[', PLUGIN_NAME, '] Fmt = ', Fmt);
    end;
  end;
end;

end.
