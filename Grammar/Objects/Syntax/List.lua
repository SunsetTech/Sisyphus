local Import = require"Toolbox.Import"

local Compiler = require"Sisyphus.Compiler"

local Pattern = Import.Module.Relative"Pattern"

return Compiler.Object(
	"Nested.PEG.Syntax.List", {
		Construct = function(self, Patterns, Seperator)
			self.Patterns = Compiler.Objects.Array("Nested.PEG", Patterns)
			self.Seperator = Seperator
		end;

		Decompose = function(self, Canonical)
			return Pattern.Syntax.Concatenate(self.Seperator(Canonical), table.unpack(self.Patterns(Canonical)))
		end;
		
		Copy = function(self)
			return (-self.Patterns).Items, -self.Seperator
		end;

		ToString = function(self)
			local Strings = {}
			for _, Item in pairs(self.Patterns.Items) do
				table.insert(Strings, tostring(Item))
			end
			return table.concat(Strings, tostring(self.Seperator))
		end;
	}
)
