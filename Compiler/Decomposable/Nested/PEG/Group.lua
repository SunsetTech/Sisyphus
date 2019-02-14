local Import = require"Toolbox.Import"

local Vlpeg = Import.Module.Relative"Vlpeg"
local DecomposableObject = Import.Module.Relative"DecomposableObject"

return DecomposableObject(
	"Nested.PEG.Group", {
		Construct = function(self, Name, InnerPattern)
			self.Name = Name
			self.InnerPattern = InnerPattern
		end;
		Decompose = function(self, Canonical)
			return Vlpeg.Group(self.InnerPattern(Canonical), self.Name)
		end;
		Copy = function(self)
			return self.Name, -self.InnerPattern
		end;
	}
)
