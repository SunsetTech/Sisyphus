local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"

local DecomposableObject = Import.Module.Relative"DecomposableObject"
local Map = Import.Module.Relative"Decomposable.Map"
local Nested = Import.Module.Relative"Decomposable.Nested"


return DecomposableObject(
	"Basic.Namespace", {
		Construct = function(self, Children)
			self.Children = Map({"Basic.Namespace", "Basic.Type.Definition"},Children or {})
		end;

		Decompose = function(self) --into a Nested.Grammar
			return 
				Nested.Grammar(self.Children())
		end;

		Copy = function(self)
			return (-self.Children).Entries
		end;

		Merge = function(Into, From)
			Into.Children = Into.Children + From.Children
		end;
	}
)


