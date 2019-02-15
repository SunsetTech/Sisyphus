local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"

local Vlpeg = Import.Module.Relative"Vlpeg"

local Object = Import.Module.Relative"Object"

return Object(
	"Nested.PEG.Range", {
		Construct = function(self, ...)
			self.Sets = {...}
		end;

		Decompose = function(self)
			return Vlpeg.Range(table.unpack(self.Sets))
		end;

		Copy = function(self)
			return table.unpack(Tools.Table.Copy(self.Sets))
		end;

		ToString = function(self)
			return '"'.. table.concat(self.Sets,",") ..'"'
		end;
	}
)
