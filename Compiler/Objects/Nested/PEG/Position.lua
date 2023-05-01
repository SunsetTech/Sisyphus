local lpeg = require"lpeg"
local Import = require"Moonrise.Import"

local Vlpeg = require"Sisyphus_Old.Vlpeg"

local Object = Import.Module.Relative"Object"

return Object(
	"Nested.PEG.Position", {
		Construct = function(self)
		end;
		Decompose = function(self, Canonical)
			return Vlpeg.Position()
		end;
		Copy = function(self)
			return "@"
		end;
	}
)
