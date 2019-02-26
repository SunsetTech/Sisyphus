local Import = require"Toolbox.Import"

local Object = Import.Module.Relative"Object"
local Map = Import.Module.Relative"Objects.Map"
local Nested = Import.Module.Relative"Objects.Nested"
local PEG = Nested.PEG
local Variable = PEG.Variable

return Object(
	"Basic.Type.Set", {
		Construct = function(self, Children)
			self.Children = Map({"Basic.Type.Definition", "Basic.Type.Set"}, Children or {})
		end;

		Decompose = function(self)
			local Options = {}
			
			for Name, _ in pairs(self.Children.Entries) do
				table.insert(Options, Variable.Child(Name))
			end
			
			return 
				Nested.Grammar{
					PEG.Select(Options)
				}
				+ Nested.Grammar(self.Children())
		end;

		Copy = function(self)
			return (-self.Children).Entries
		end;
	}
)
