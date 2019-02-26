require"Toolbox.Import.Install".All()
local Tools = require"Toolbox.Tools"

local DebugOutput = require"Toolbox.Debug.Registry".GetDefaultPipe()
DebugOutput.IncludeSource = false
DebugOutput.Enabled = false

local Vlpeg = require"Sisyphus.Vlpeg"
local Compiler = require"Sisyphus.Compiler"

local TemplateGrammar = require"Sisyphus.Grammar"
local AliasableGrammar = TemplateGrammar()
local Grammar = AliasableGrammar/"userdata"

local InputPath = arg[1] or error"Supply filename"
local OutputPath = arg[2] or error"Supply filename"

local InputFile = io.open(InputPath, "r")
local Input = InputFile:read"a"
InputFile:close()

local Output = Tools.Filesystem.ChangePath(
	Tools.Path.Join(Tools.Path.DirName(InputPath)),
	Vlpeg.Match,
	Grammar, Input, 1, {
		Grammar = AliasableGrammar;
		Variables = {};
	}
)
for Name, Amount in pairs(Compiler.Object.TotalCopies) do
	--print(Amount .." ".. Name .." copies created")
end
local OutputFile = io.open(OutputPath, "w")
OutputFile:write(Output .."\n")
OutputFile:close()
