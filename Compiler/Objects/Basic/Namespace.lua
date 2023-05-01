local Import = require"Moonrise.Import"
local Tools = require"Moonrise.Tools"

local Object = Import.Module.Relative"Object"
local Map = Import.Module.Relative"Objects.Map"
local Nested = Import.Module.Relative"Objects.Nested"


return Object(
	"Basic.Namespace", {
		Construct = function(self, Children, _Children)
			if _Children then 
				self.Children = _Children
			else
				self.Children = Map({"Basic.Namespace", "Basic.Type.Definition", "Basic.Type.Set"},Children or {})
			end
		end;

		Decompose = function(self) --into a Nested.Grammar
			return 
				Nested.Grammar(self.Children())
		end;

		Copy = function(self)
			return nil, (-self.Children)
		end;

		Merge = function(Into, From)
			Into.Children = Map({"Basic.Namespace","Basic.Type.Definition","Basic.Type.Set"},{}) + {Into.Children, From.Children}
		end;
	}
)


