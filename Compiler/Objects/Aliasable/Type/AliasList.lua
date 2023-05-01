local Import = require"Moonrise.Import"
local Tools = require"Moonrise.Tools"

local Object = Import.Module.Relative"Object"
local Nested = Import.Module.Relative"Objects.Nested"

local PEG = Nested.PEG

return Object(
	"Aliasable.Type.AliasList", {
		Construct = function(self, Names)
			self.Names = Names or {}
			--[[for Index, _ in pairs(self.Names) do
				Tools.Error.CallerAssert(type(Index) == "number", "hmm")
			end]]
		end;
		Decompose = function(self)
			local Variables = {}
			--for Index, Name in pairs(self.Names) do
			for Index = 1, #self.Names do local Name = self.Names[Index]
				Variables[Index] = PEG.Debug(PEG.Sequence{PEG.Pattern":", PEG.Variable.Canonical(Name)})
			end
			return PEG.Select(Variables)
		end;
		Copy = function(self)
			local Names = {}
			for Index = 1, #self.Names do local Name = self.Names[Index]
				Names[Index] = Name
			end
			return Names
			--return Tools.Table.Copy(self.Names)
		end;
	}
)
