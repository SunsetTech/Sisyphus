local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"

local rawtype = type
local type = Tools.Type.GetType

local Object = Import.Module.Relative"Object"
local Namer = Import.Module.Relative"Objects.Namer"
local Merger = Import.Module.Relative"Objects.Merger"

local Flat = Import.Module.Relative"Objects.Flat"

local Nested = {
	Rule = Import.Module.Sister"Rule";
}


local Class 
Class = Object(
	"Nested.Grammar", {
		Construct = function(self, Rules, Base)
			self.Rules = Namer({"Nested.Grammar", "Nested.Rule"}, Rules or {})
			self.Base = Base or Flat.Grammar()
			assert(self.Base%"Flat.Grammar")
			for k,v in pairs(Rules or {}) do
				assert(type(v) ~= "table")
			end
		end;

		Decompose = function(self, Canonical)
			local ConvertedRules = Namer({"Nested.Grammar", "Nested.Rule"}, {})

			for Name, Rule in pairs(self.Rules.Entries) do
				if Rule%"Nested.PEG" then
					ConvertedRules.Entries[Name] = Nested.Rule(Rule)
				elseif Rule%"Nested.Grammar" or Rule%"Nested.Rule" then
					ConvertedRules.Entries[Name] = Rule
				end
			end
			
			local Flattened = Merger("Flat.Grammar", ConvertedRules(Canonical))()
			
			return 
				Flattened
				and self.Base + Flattened
				or self.Base
		end;


		Copy = function(self)
			return (-self.Rules).Entries, -self.Base
		end;

		Merge = function(Into, From)
			if From.Base then
				if Into.Base then
					Into.Base = Into.Base + From.Base
				else
					Into.Base = From.Base
				end
			end
			
			Into.Rules = Namer({"Nested.Grammar", "Nested.Rule"},{}) + {Into.Rules, From.Rules}
		end;
	}
);
return Class
