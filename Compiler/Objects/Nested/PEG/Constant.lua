local Vlpeg = require"Sisyphus_Old.Vlpeg"
local Import = require"Moonrise.Import"

local Object = Import.Module.Relative"Object"

return Object(
	"Nested.PEG.Constant", {
		Construct = function(self, Value)
			self.Value = Value
		end;
		
		Decompose = function(self, Canonical)
			local t = Vlpeg.Constant(self.Value)
			return t
		end;
		
		Copy = function(self)
			return self.Value
		end;
	}
)
