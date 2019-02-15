local lpeg = require"lpeg"
local Import = require"Toolbox.Import"

local Object = Import.Module.Relative"Object"
local Vlpeg = Import.Module.Relative"Vlpeg"
local Array = Import.Module.Relative"Objects.Array"

return Object(
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

		ToString = function(self)
			local Strings = {}
			for _, Part in pairs(self.Parts.Items) do
				table.insert(Strings, tostring(Part))
			end
			return table.concat(Strings,"*")
		end;
	}
)
