local Import = require"Moonrise.Import"

local Object = Import.Module.Relative"Compiler.Object"

return Object(
	"Nested.PEG.Optional", {
		Construct = function(self, InnerPattern)
			assert(type(InnerPattern) ~= "string")
			self.InnerPattern = InnerPattern
		end;

		Decompose = function(self, Canonical)
			return self.InnerPattern(Canonical)^-1
		end;

		Copy = function(self)
			return -self.InnerPattern
		end;

		ToString = function(self)
			return tostring(self.InnerPattern) .."?"
		end;
	}
)
