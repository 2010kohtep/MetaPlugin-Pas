library MetaPlug;

{$I Default.inc}

uses
  SysUtils, Utils, Common, MetaAPI, SDK, Global;

procedure GiveFnptrsToDll(const Engine: TEngineFuncs; const GlobalVars: TGlobalVars); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
begin
  Move(Engine, Global.Engine, SizeOf(Global.Engine));
  Global.GlobalVars := @GlobalVars;
end;

function GetEntityAPI2(var FunctionTable: TDLLFunctions; var InterfaceVersion: Integer): Integer; cdecl;
begin
  if @FunctionTable = nil then
  begin
    Print('GetEntityAPI2: Invalid FunctionTable.'#10);
    Result := Ord(False);
    Exit;
  end;

  if InterfaceVersion <> 140 then
  begin
    Print('GetEntityAPI2: Incorrect interface version (requested: %d; expected: %d).'#10, [InterfaceVersion, 140]);
    InterfaceVersion := 140;
    Result := Ord(False);
    Exit;
  end;

  Move(Global.DLLFunctionTable, FunctionTable, SizeOf(FunctionTable));
  Result := Ord(True);
end;

function Meta_Query(InterfaceVersion: PAnsiChar; var PluginInfo: PPluginInfo;
  const MetaUtils: TMetaUtilsFuncs): Integer; cdecl;
begin
  PluginInfo := @Global.PluginInfo;
  Result := Ord(True);
end;

function Meta_Attach(Now: TPlugLoadTime; MetaFuncs: PMetaFunctions; MetaGlobals: PMetaGlobals;
  const GameDLLFuncs: TDLLFunctions): Integer; cdecl;
const
  MetaFunctionTable: TMetaFunctions = (GetEntityAPI2: GetEntityAPI2);
begin
  if MetaFuncs = nil then
  begin
    Print('Meta_Attach: Invalid MetaFuncs.'#10);
    Result := Ord(False);
  end
  else
  begin
    Global.MetaGlobals := MetaGlobals;
    Move(MetaFunctionTable, MetaFuncs^, SizeOf(MetaFuncs^));

    Result := Init;
  end;
end;

function Meta_Detach(LoadTime: TPlugLoadTime; Reason: TPlugUnloadReason): Integer; cdecl;
begin
  Result := Ord(True);
end;

exports
  GiveFnptrsToDll, Meta_Query, Meta_Attach, Meta_Detach;

begin
  Print('Hello, world!'#10);
end.
