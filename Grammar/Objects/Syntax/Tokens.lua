local Import = require"Toolbox.Import"

local Compiler = require"Sisyphus.Compiler"

local Pattern = Import.Module.Relative"Pattern"

return Compiler.Object(
	"Nested.PEG.Syntax.Tokens", {
		Construct = function(self, Patterns)
			self.Patterns = Compiler.Objects.Array("Nested.PEG", Patterns)
		end;

		Decompose = function(self, Canonical)
			local v = Pattern.Syntax.Tokens(unpack(self.Patterns(Canonical)))
			assert(type(v) == "userdata")
			return v
		end;
		
		Copy = function(self)
			return (-self.Patterns).Items
		end;

		ToString = function(self)
			local Strings = {}
			for _, Item in pairs(self.Patterns.Items) do
				table.insert(Strings, tostring(Item))
			end
			return table.concat(Strings, " ")
		end;
	}
)
