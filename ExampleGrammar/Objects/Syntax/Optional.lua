local Compiler = require"Sisyphus.Compiler"

return Compiler.Object(
	"Nested.PEG.Syntax.Optional", {
		Construct = function(self, InnerPattern)
			self.InnerPattern = InnerPattern
		end;

		Decompose = function(self, Canonical)
			return self.InnerPattern(Canonical)^-1
		end;

		Copy = function(self)
			return -self.InnerPattern
		end;
	}
)
