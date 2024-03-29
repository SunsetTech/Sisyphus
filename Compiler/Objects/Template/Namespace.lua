local Import = require"Moonrise.Import"

local Object = Import.Module.Relative"Object"
local Map = Import.Module.Relative"Objects.Map"
local Aliasable = Import.Module.Relative"Objects.Aliasable"

return Object(
	"Template.Namespace", {
		Construct = function(self, Children, Base)
			self.Base = Base or Aliasable.Namespace()
			self.Children = Map({"Template.Namespace", "Template.Definition"}, Children or {})
		end,

		Decompose = function(self)
			return
				self.Base
				+ Aliasable.Namespace(self.Children())
		end;

		Copy = function(self)
			return (-self.Children).Entries, self.Base
		end;

		Merge = function(Into, From)
			Into.Base = Into.Base + From.Base
			Into.Children = Into.Children + From.Children
		end
	}
)
