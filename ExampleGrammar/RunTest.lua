require"Toolbox.Import.Install".All()

local DebugOutput = require"Toolbox.Debug.Registry".GetDefaultPipe()
DebugOutput.IncludeSource = false
DebugOutput.Enabled = false


local Vlpeg = require"Sisyphus.Vlpeg"
local ExampleTemplateGrammar = require"Sisyphus.ExampleGrammar"

local ExampleAliasableGrammar = ExampleTemplateGrammar()

local ExampleGrammar = ExampleAliasableGrammar/"userdata"

local ExampleText = 
[[WithTemplates<
	Declaration<Greet <Data.String Phrase, Data.String Noun> Templates.Functions.Concat>Concat<^Phrase" "^Noun"!">
>Greet"Hello""World"]]

DebugOutput.Enabled = true
print(
	Vlpeg.Match(
		ExampleGrammar, ExampleText, 1, {
			Grammar = ExampleAliasableGrammar;
			Variables = {};
		}
	)
)
