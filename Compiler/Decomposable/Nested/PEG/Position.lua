local lpeg = require"lpeg"
local Import = require"Toolbox.Import"

local Vlpeg = require"Sisyphus.Vlpeg"

local DecomposableObject = Import.Module.Relative"DecomposableObject"

return DecomposableObject(
	"Nested.PEG.Position", {
		Construct = function(self)
		end;
		Decompose = function(self, Canonical)
			return Vlpeg.Position()
		end;
		Copy = function(self)
		end;
	}
)
