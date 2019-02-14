local lpeg = require"lpeg"
local Import = require"Toolbox.Import"

local DecomposableObject = Import.Module.Relative"DecomposableObject"
local Array = Import.Module.Relative"Decomposable.Array"
local Vlpeg = Import.Module.Relative"Vlpeg"

local PEG = {
	Debug = Import.Module.Sister"Debug";
	Pattern = Import.Module.Sister"Pattern";
}


return DecomposableObject(
	"Nested.PEG.Select", {
		Construct = function(self, Options)
			self.Options = Array("Nested.PEG", Options)
		end;
		Decompose = function(self, Canonical)
			local Patterns = self.Options(Canonical)
			return Vlpeg.Select(table.unpack(Patterns)) or PEG.Pattern(false)()
		end;
		Copy = function(self)
			return (-self.Options).Items
		end;
	}
)
