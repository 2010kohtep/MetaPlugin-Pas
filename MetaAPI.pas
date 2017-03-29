unit MetaAPI;

{$I Default.inc}

{$MinEnumSize 4}

interface

uses
  SDK;

const
  META_INTERFACE_VERSION = '5:13';

type
  va_args = PAnsiChar;
  QBoolean = Integer;

type
  TMetaRes = (MRES_UNSET = 0, MRES_IGNORED, MRES_HANDLED, MRES_OVERRIDE, MRES_SUPERCEDE);

  PMetaGlobals = ^TMetaGlobals;
  TMetaGlobals = record
    MRes, PrevMRes, Status: TMetaRes;
    OrigRet, OverrideRet: Pointer;
  end;

  PMetaFunctions = ^TMetaFunctions;
  TMetaFunctions = record
    GetEntityAPI, GetEntityAPIPost: function(var FunctionTable: TDLLFunctions; InterfaceVersion: Integer): Integer; cdecl;
    GetEntityAPI2, GetEntityAPI2Post: function(var FunctionTable: TDLLFunctions; var InterfaceVersion: Integer): Integer; cdecl;
    GetNewDLLFunctions, GetNewDLLFunctionsPost: function(var FunctionTable: TDLLFunctions; InterfaceVersion: Integer): Integer; cdecl;
    GetEngineFunctions, GetEngineFunctionsPost: function(var Engine: TEngineFuncs; var InterfaceVersion: Integer): Integer; cdecl;
  end;

// plinfo.h

type
  TPlugLoadTime = (PT_NEVER = 0, PT_STARTUP, PT_CHANGELEVEL, PT_ANYTIME,
    PT_ANYPAUSE);

  TPlugUnloadReason = (PNL_NULL = 0, PNL_INI_DELETED, PNL_FILE_NEWER,
  PNL_COMMAND, PNL_CMD_FORCED, PNL_DELAYED, PNL_PLUGIN, PNL_PLG_FORCED,
	PNL_RELOAD);

  PPluginInfo = ^TPluginInfo;
  TPluginInfo = record
    InterfaceVersion, Name, Version, Date, Author, URL, LogTag: PAnsiChar;
    Loadable, Unloadable: TPlugLoadTime;
  end;

  plid_t = PPluginInfo;

// mutil.h

const
  MAX_LOGMSG_LEN = 1024;

type
  GInfo = (GINFO_NAME = 0, GINFO_DESC, GINFO_GAMEDIR, GINFO_DLL_FULLPATH,
  GINFO_DLL_FILENAME, GINFO_REALDLL_FULLPATH);

  TMetaUtilsFuncs = record
    LogConsole: procedure(PLID: plid_t; Fmt: PAnsiChar); cdecl varargs;
    LogMessage: procedure(PLID: plid_t; Fmt: PAnsiChar); cdecl varargs;
    LogError: procedure(PLID: plid_t; Fmt: PAnsiChar); cdecl varargs;
    LogDeveloper: procedure(PLID: plid_t; Fmt: PAnsiChar); cdecl varargs;
    LogCenterSay: procedure(PLID: plid_t; Fmt: PAnsiChar); cdecl varargs;
    CenterSayParms: procedure(PLID: plid_t; TParms: THUDTextParms; Fmt: PAnsiChar); cdecl varargs;

    CenterSayVarargs: procedure(PLID: plid_t; TParms: THUDTextParms; Fmt: PAnsiChar; AP: va_args); cdecl;

    CallGameEntity: function(PLID: plid_t; EntStr: PAnsiChar; PEV: PEntVars): QBoolean; cdecl;
    GetUserMsgID: function(PLID: plid_t; MsgName: PAnsiChar; var Size: Integer): Integer; cdecl;
    GetUserMsgName: function(PLID: plid_t; MsgID: Integer; var Size: Integer): PAnsiChar; cdecl;
    GetPluginPath: function(PLID: plid_t): PAnsiChar; cdecl;
    GetGameInfo: function(PLID: plid_t): PAnsiChar; cdecl;

    LoadPlugin: function(PLID: plid_t; CmdLine: PAnsiChar; Now: TPlugLoadTime; var PluginHandle: Pointer): Integer; cdecl;
    UnloadPlugin: function(PLID: plid_t; CmdLine: PAnsiChar; Now: TPlugLoadTime; Reason: TPlugUnloadReason): Integer; cdecl;
    UnloadPluginByHandle: function(PLID: plid_t; PluginHandle: Pointer; Now: TPlugLoadTime; Reason: TPlugUnloadReason): Integer; cdecl;

    IsQueryingClientCvar: function(PLID: plid_t; const Player: TEdict): PAnsiChar; cdecl;

    MakeRequestID: function(PLID: plid_t): Integer; cdecl;

    GetHookTables: procedure(PLID: plid_t; var PEng: PEngineFuncs; var PDLL: PDLLFunctions; var PNewDLL: PNewDLLFunctions); cdecl;
  end;

procedure META_SET_RESULT(Globals: PMetaGlobals; Result: TMetaRes);
function META_RESULT_STATUS(Globals: PMetaGlobals): TMetaRes;
function META_RESULT_PREVIOUS(Globals: PMetaGlobals): TMetaRes;
function META_RESULT_ORIG_RET(Globals: PMetaGlobals): Pointer;
function META_RESULT_OVERRIDE_RET(Globals: PMetaGlobals): Pointer;

implementation

procedure META_SET_RESULT(Globals: PMetaGlobals; Result: TMetaRes);
begin
  Globals^.MRes := Result;
end;

function META_RESULT_STATUS(Globals: PMetaGlobals): TMetaRes;
begin
  Result := Globals^.Status;
end;

function META_RESULT_PREVIOUS(Globals: PMetaGlobals): TMetaRes;
begin
  Result := Globals^.MRes;
end;

function META_RESULT_ORIG_RET(Globals: PMetaGlobals): Pointer;
begin
  Result := Globals^.OrigRet;
end;

function META_RESULT_OVERRIDE_RET(Globals: PMetaGlobals): Pointer;
begin
  Result := Globals^.OverrideRet;
end;

end.
