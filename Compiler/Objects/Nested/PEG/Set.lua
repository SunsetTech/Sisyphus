local Import = require"Moonrise.Import"
local Tools = require"Moonrise.Tools"

local Vlpeg = Import.Module.Relative"Vlpeg"

local Object = Import.Module.Relative"Object"

return Object(
	"Nested.PEG.Set", {
		Construct = function(self, Characters)
			self.Characters = Characters
		end;

		Decompose = function(self)
			return Vlpeg.Set(self.Characters)
		end;

		Copy = function(self)
			return self.Characters
		end;

		ToString = function(self)
			return '['.. self.Characters:gsub("\t","\\t") ..']'
		end;
	}
)
