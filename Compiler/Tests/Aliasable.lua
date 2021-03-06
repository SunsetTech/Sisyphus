local Import = require "Toolbox.Import"

local Vlpeg = Import.Module.Relative"Vlpeg"
local Aliasable = Import.Module.Relative"Objects.Aliasable"
local Nested = Import.Module.Relative"Objects.Nested"

return function()
	local TestAliasableGrammar = Aliasable.Grammar(
		Nested.PEG.Variable.Child"Types.Aliasable.A",
		Aliasable.Namespace{
			A = Aliasable.Type.Definition(
				Nested.PEG.Capture(Nested.PEG.Variable.Child"Syntax.Token"),
				function(Token)
					return Token .."+"
				end,
				Nested.Grammar{
					Token = Nested.PEG.Pattern"A"
				}
			)
		}
	)
	local TestBasicGrammar = TestAliasableGrammar()
	local TestNestedGrammar = TestBasicGrammar()
	local TestFlatGrammar = TestNestedGrammar()
	local TestGrammar = TestFlatGrammar()
	local TestOutput = Vlpeg.Match(TestGrammar,"A")
	assert(TestOutput == "A+")
	print(TestOutput)
end
