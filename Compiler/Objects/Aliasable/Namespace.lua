local Import = require"Moonrise.Import"

local Object = Import.Module.Relative"Object"
local Map = Import.Module.Relative"Objects.Map"
local Basic = Import.Module.Relative"Objects.Basic"

return Object(
	"Aliasable.Namespace", {
		Construct = function(self, Children, Base, _Children)
			self.Base = Base or Basic.Namespace()
			if _Children then 
				self.Children = _Children
			else
				self.Children = Map({"Aliasable.Namespace", "Aliasable.Type.Definition"}, Children)
			end
		end;

		Decompose = function(self) -- into a Basic.Namespace
			return 
				self.Base
				+ Basic.Namespace(self.Children())
		end;

		Copy = function(self)
			return nil, -self.Base, -self.Children
		end;

		Merge = function(Into, From)
			Into.Base = Into.Base + From.Base
			Into.Children = Into.Children + From.Children
		end;
	}
)
