local Vlpeg = require"Sisyphus.Vlpeg"
local Import = require"Toolbox.Import"

local Object = Import.Module.Relative"Object"

return Object(
	"Nested.PEG.Constant", {
		Construct = function(self, Name)
			self.Name = Name
		end;
		
		Decompose = function(self, Canonical)
			return Vlpeg.Stored(self.Name)
		end;
		
		Copy = function(self)
			return self.Name
		end;
	}
)
