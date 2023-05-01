local Import = require"Moonrise.Import"

local Object = Import.Module.Relative"Object"
local Nested = Import.Module.Relative"Objects.Nested"

local Basic = {
	Namespace = Import.Module.Sister"Namespace";
}

return Object(
	"Basic.Grammar", {
		Construct = function(self, InitialPattern, Types, Syntax)
			self.InitialPattern = InitialPattern
			self.Types = Types or Basic.Namespace()
			self.Syntax = Syntax or Nested.Grammar()
		end,

		Decompose = function(self)
			return Nested.Grammar{
				self.InitialPattern,
				Types = self.Types();
				Syntax = self.Syntax;
			}
		end;
	}
)
