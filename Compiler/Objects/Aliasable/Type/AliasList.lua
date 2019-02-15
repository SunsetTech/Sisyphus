local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"

local Object = Import.Module.Relative"Object"
local Nested = Import.Module.Relative"Objects.Nested"

local PEG = Nested.PEG

return Object(
	"Aliasable.Type.AliasList", {
		Construct = function(self, Names)
			self.Names = Names or {}
		end;
		Decompose = function(self)
			local Variables = {}
			for Index, Name in pairs(self.Names) do
				Variables[Index] = PEG.Variable.Canonical(Name)
			end
			return PEG.Select(Variables)
		end;
		Copy = function(self)
			return Tools.Table.Copy(self.Names)
		end;
	}
)
