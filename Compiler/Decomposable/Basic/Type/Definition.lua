local type = require"Toolbox.Utilities.Type".GetType

local Import = require"Toolbox.Import"
local DecomposableObject = Import.Module.Relative"DecomposableObject"
local Nested = Import.Module.Relative"Decomposable.Nested"

local Basic = {
	Grammar = Import.Module.Relative"Grammar";
	Namespace = Import.Module.Relative"Namespace";
}

return DecomposableObject(
	"Basic.Type.Definition", {
		Construct = function(self, Pattern, Syntax, Types)
			self.Pattern = Pattern
			self.Syntax = Syntax or Nested.Grammar()
			self.Types = Types or Basic.Namespace();
		end;

		Decompose = function(self)
			return Basic.Grammar(
				self.Pattern,
				self.Types,
				self.Syntax
			)()
		end;
		
		Copy = function(self)
			return -self.Pattern, -self.Syntax, -self.Types
		end;
	}
)
