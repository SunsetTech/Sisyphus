local Compiler = require"Sisyphus.Compiler"

return Compiler.Object(
	"Nested.PEG.Syntax.All", {
		Construct = function(self, InnerPattern)
			assert(InnerPattern)
			self.InnerPattern = InnerPattern
		end;

		Decompose = function(self, Canonical)
			return self.InnerPattern(Canonical)^0
		end;

		Copy = function(self)
			return -self.InnerPattern
		end;

		ToString = function(self)
			return tostring(self.InnerPattern) .."+"
		end;
	}
)

