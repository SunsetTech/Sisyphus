local Tools = require"Toolbox.Tools"
local Import = require"Toolbox.Import"

local Object = Import.Module.Relative"Object"
local Array = Import.Module.Relative"Objects.Array"
local Vlpeg = Import.Module.Relative"Vlpeg"

local PEG = {
	Debug = Import.Module.Sister"Debug";
	Pattern = Import.Module.Sister"Pattern";
}


return Object(
	"Nested.PEG.Select", {
		Construct = function(self, Options)
			self.Options = Tools.Error.NotMine(Array,"Nested.PEG", Options)
		end;
		
		Decompose = function(self, Canonical)
			local Patterns = self.Options(Canonical)
			return Vlpeg.Select(table.unpack(Patterns)) or PEG.Pattern(false)()
		end;
		
		Copy = function(self)
			return (-self.Options).Items
		end;

		ToString = function(self)
			local Strings = {}
			for _, Item in pairs(self.Options.Items) do
				table.insert(Strings, tostring(Item))
			end
			return "(".. table.concat(Strings, "|") ..")"
		end;
	}
)
