local Import = require"Toolbox.Import"

local Vlpeg = Import.Module.Relative"Vlpeg"
local Object = Import.Module.Relative"Object"

return Object(
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

		ToString = function(self)
			return "[".. (self.Name or "?") .."=".. self.InnerPattern .."]"
		end;
	}
)
