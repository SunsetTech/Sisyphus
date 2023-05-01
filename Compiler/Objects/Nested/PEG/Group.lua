local Tools = require"Moonrise.Tools"
local Import = require"Moonrise.Import"

local Vlpeg = Import.Module.Relative"Vlpeg"
local Object = Import.Module.Relative"Object"

return Object(
	"Nested.PEG.Group", {
		Construct = function(self, InnerPattern, Name)
			--Tools.Error.CallerAssert(type(InnerPattern) ~= "string", "huh")
			self.Name = Name
			self.InnerPattern = InnerPattern
		end;

		Decompose = function(self, Canonical)
			return Vlpeg.Group(self.InnerPattern(Canonical), self.Name)
		end;
		
		Copy = function(self)
			return -self.InnerPattern, self.Name
		end;

		ToString = function(self)
			return "[".. (tostring(self.Name) or "?") .."=".. tostring(self.InnerPattern) .."]"
		end;
	}
)
