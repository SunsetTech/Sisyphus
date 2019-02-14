local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"

local Vlpeg = Import.Module.Relative"Vlpeg"

local DecomposableObject = Import.Module.Relative"DecomposableObject"

return DecomposableObject(
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
	}
)
