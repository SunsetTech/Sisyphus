local Import = require"Toolbox.Import"

local Vlpeg = Import.Module.Relative"Vlpeg"
local Flat = Import.Module.Relative"Decomposable.Flat"

return function()
	local TestFlatGrammarA = Flat.Grammar{
		A = Vlpeg.Pattern"A";
	}

	local TestFlatGrammarB = Flat.Grammar{
		B = Vlpeg.Pattern"B";
	}
	
	local TestFlatGrammar =
		Flat.Grammar{
			Vlpeg.Select(Vlpeg.Variable"A", Vlpeg.Variable"B")
		}
		+ TestFlatGrammarA
		+ TestFlatGrammarB
	
	local TestGrammar = TestFlatGrammar()

	assert(Vlpeg.Match(TestGrammar,"A"))
	assert(Vlpeg.Match(TestGrammar,"B"))
end
