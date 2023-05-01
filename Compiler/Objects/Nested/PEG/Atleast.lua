local Import = require"Moonrise.Import"

local Object = Import.Module.Relative"Compiler.Object"

return Object(
	"Nested.PEG.Atleast", {
		Construct = function(self, Amount, InnerPattern)
			self.Amount = Amount
			self.InnerPattern = InnerPattern
		end;

		Decompose = function(self, Canonical)
			return self.InnerPattern(Canonical)^self.Amount
		end;

		Copy = function(self)
			return self.Amount, -self.InnerPattern
		end;

		ToString = function(self)
			return tostring(self.InnerPattern) .."^".. self.Amount
		end;
	}
)
