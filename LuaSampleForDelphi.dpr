program LuaSampleForDelphi;

{%DotNetAssemblyCompiler 'lua.dll'}

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Lua in 'Lua.pas',
  LuaUtils in 'LuaUtils.pas',
  LauxLib in 'LauxLib.pas',
  LuaLib in 'LuaLib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
