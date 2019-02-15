local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"

local Object = Import.Module.Relative"Object"
local Map = Import.Module.Relative"Objects.Map"
local Nested = Import.Module.Relative"Objects.Nested"


return Object(
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


