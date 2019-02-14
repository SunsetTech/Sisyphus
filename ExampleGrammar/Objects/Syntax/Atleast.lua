local Compiler = require"Sisyphus.Compiler"

return Compiler.Object(
	"Nested.PEG.Syntax.Atleast", {
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
	}
)
