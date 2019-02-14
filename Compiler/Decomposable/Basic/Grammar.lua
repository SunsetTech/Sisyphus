local Import = require"Toolbox.Import"

local DecomposableObject = Import.Module.Relative"DecomposableObject"
local Nested = Import.Module.Relative"Decomposable.Nested"

local Basic = {
	Namespace = Import.Module.Sister"Namespace";
}

return DecomposableObject(
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
