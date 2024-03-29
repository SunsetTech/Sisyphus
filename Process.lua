unpack = unpack or table.unpack
table.unpack = table.unpack or unpack
require"Moonrise.Import.Install".All()
local Tools = require"Moonrise.Tools"

--[[local DebugOutput = require"Toolbox.Debug.Registry".GetDefaultPipe()
DebugOutput.IncludeSource = false
DebugOutput.Enabled = false]]

local Vlpeg = require"Sisyphus_Old.Vlpeg"
local Compiler = require"Sisyphus_Old.Compiler"

local TemplateGrammar = require"Sisyphus_Old.Grammar"
local AliasableGrammar = TemplateGrammar()
local Grammar = AliasableGrammar/"userdata"

local InputPath = arg[1] or error"Supply filename"
local OutputPath = arg[2] or error"Supply filename"

local InputFile = io.open(InputPath, "r")
local Input = InputFile:read"a"
InputFile:close()

print"-------"
local Output = Tools.Filesystem.ChangePath(
	Tools.Path.Join(Tools.Path.DirName(InputPath)),
	Vlpeg.Match,
	Grammar, Input, 1, {
		Grammar = AliasableGrammar;
		Variables = {};
	}
)
print"-------"

for Name, Amount in pairs(Compiler.Object.TotalCopies) do
	--print(Amount .." ".. Name .." copies created")
end

local OutputFile = io.open(OutputPath, "w")
OutputFile:write(Output .."\n")
OutputFile:close()
