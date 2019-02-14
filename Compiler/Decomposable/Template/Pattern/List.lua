local Module = require"Toolbox.Module"

local PEG = Module.Import.Relative"PEG"
local Syntax = Module.Import.Relative"Sisyphus.Pattern.Syntax"
local Join = Module.Import.Relative"Sisyphus.Pattern.Join"

local DecomposableObject = Module.Import.Relative"DecomposableObject"

return DecomposableObject(
	"Template.Pattern.List" {
		Construct = function(self, Patterns)
			self.Patterns = Array("Nested.Pattern", Patterns)
		end;

		Decompose = function(self, Canonical)
			local Start = PEG.Optional"<"
			local Patterns = self.Patterns(Canonical)
			local Seperator = Syntax.Centered(PEG.Optional",")
			local Contents = Syntax.Seperated(Patterns, Seperator)
			local End = PEG.Optional">"
			return Syntax.Delimited(Start, Contents, End)
		end;

		Copy = function(self)
			return -self.Patterns
		end;
	}
)
