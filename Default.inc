{*******************************************************}
{                                                       }
{       MetaPlug                                        }
{                                                       }
{       Copyright (C) 2017 Alexander B.                 }
{                                                       }
{*******************************************************}

{$IFDEF MSWINDOWS}
  {$IF CompilerVersion = 15} (* Delphi 7 *)
    {$WARN UNSAFE_CODE OFF}
    {$WARN UNSAFE_TYPE OFF}
    {$WARN UNSAFE_CAST OFF}
  {$IFEND}
{$ELSE}
  {$DEFINE LINUX}
{$ENDIF}
