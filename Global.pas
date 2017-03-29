unit Global;

{$I Default.inc}

interface

uses
  MetaAPI, SDK;

const
  PLUGIN_NAME = 'MetaPas';

var
  EngineBase: HMODULE;

  EngineFunctionTable: TEngineFuncs;
  DLLFunctionTable: TDLLFunctions;
  NewDLLFunctionTable: TNewDLLFunctions;
  MetaGlobals: PMetaGlobals;

  Engine: TEngineFuncs;
  GlobalVars: PGlobalVars;

  PluginInfo: TPluginInfo = (
    InterfaceVersion: META_INTERFACE_VERSION;
    Name: PLUGIN_NAME;
    Version: '1.0.0';
    Date: nil;
    Author: 'Me';
    URL: nil;
    LogTag: nil;
    Loadable: PT_ANYTIME;
    Unloadable: PT_ANYTIME);

implementation

end.

