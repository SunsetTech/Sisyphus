local Import = require"Moonrise.Import"
local Tools = require"Moonrise.Tools"

local rawtype = type
local type = Tools.Inspect.GetType

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
		Construct = function(self, Rules, Base, _Rules)
			if _Rules then
				self.Rules = _Rules
			else
				self.Rules = Namer({"Nested.Grammar", "Nested.Rule"}, Rules)
			end
			self.Base = Base or Flat.Grammar()
			assert(self.Base%"Flat.Grammar")
			--[[for k,v in pairs(Rules or {}) do
				assert(type(v) ~= "table")
			end]]
		end;

		Decompose = function(self, Canonical)
			local ConvertedRules = Namer({"Nested.Grammar", "Nested.Rule"})
			--for Name, Rule in pairs(self.Rules.Entries.Pairs) do
			for NameIndex = 1, self.Rules.Entries:NumKeys() do
				local Name,Rule = self.Rules.Entries:GetPair(NameIndex)
				if Rule%"Nested.PEG" then
					ConvertedRules.Entries:Add(Name,Nested.Rule(Rule))
				elseif Rule%"Nested.Grammar" or Rule%"Nested.Rule" then
					ConvertedRules.Entries:Add(Name, Rule)
				end
			end
			
			local Flattened = Merger("Flat.Grammar", ConvertedRules(Canonical))()
			
			return 
				Flattened
				and self.Base + Flattened
				or self.Base
		end;


		Copy = function(self)
			--return (-self.Rules).Entries, -self.Base
			return nil, -self.Base, -self.Rules
		end;

		Merge = function(Into, From)
			if From.Base then
				if Into.Base then
					Into.Base = Into.Base + From.Base
				else
					Into.Base = From.Base
				end
			end
			Into.Rules = Namer({"Nested.Grammar", "Nested.Rule"}) + {Into.Rules, From.Rules}
		end;
	}
);
return Class
