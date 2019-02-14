local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"

local Vlpeg = Import.Module.Relative"Vlpeg"

local DecomposableObject = Import.Module.Relative"DecomposableObject"

return DecomposableObject(
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
	}
)
