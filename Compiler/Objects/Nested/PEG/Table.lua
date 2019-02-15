local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"

local Vlpeg = Import.Module.Relative"Vlpeg"

local Object = Import.Module.Relative"Object"

return Object(
	"Nested.PEG.Range", {
		Construct = function(self, InnerPattern)
			self.InnerPattern = InnerPattern
		end;

		Decompose = function(self, Canonical)
			return Vlpeg.Table(self.InnerPattern(Canonical))
		end;

		Copy = function(self)
			return -self.InnerPattern
		end;

		ToString = function(self)
			return "{".. self.InnerPattern .."}"
		end;
	}
)
