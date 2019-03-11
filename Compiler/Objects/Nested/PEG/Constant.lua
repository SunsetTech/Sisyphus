local Vlpeg = require"Sisyphus.Vlpeg"
local Import = require"Toolbox.Import"

local Object = Import.Module.Relative"Object"

return Object(
	"Nested.PEG.Constant", {
		Construct = function(self, Value)
			self.Value = Value
		end;
		
		Decompose = function(self, Canonical)
			return Vlpeg.Constant(self.Value)
		end;
		
		Copy = function(self)
			return self.Value
		end;
	}
)
