local lpeg = require"lpeg"
local Import = require"Toolbox.Import"

local DecomposableObject = Import.Module.Relative"DecomposableObject"
local Vlpeg = Import.Module.Relative"Vlpeg"
local Array = Import.Module.Relative"Decomposable.Array"

return DecomposableObject(
	"Nested.PEG.Sequence", {
		Construct = function(self, Parts)
			self.Parts = Array("Nested.PEG", Parts)
		end;

		Decompose = function(self, Canonical)
			local Patterns = self.Parts(Canonical)
			return Vlpeg.Sequence(table.unpack(Patterns))
		end;

		Copy = function(self)
			return (-self.Parts).Items
		end;
	}
)
