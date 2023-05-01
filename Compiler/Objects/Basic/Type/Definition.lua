local type = require"Moonrise.Tools.Inspect".GetType

local Import = require"Moonrise.Import"
local Object = Import.Module.Relative"Object"
local Nested = Import.Module.Relative"Objects.Nested"

local Basic = {
	Grammar = Import.Module.Relative"Grammar";
	Namespace = Import.Module.Relative"Namespace";
}

return Object(
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
