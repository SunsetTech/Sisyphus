local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"

local rawtype = type
local type = Tools.Type.GetType

local DecomposableObject = Import.Module.Relative"DecomposableObject"
local Namer = Import.Module.Relative"Decomposable.Namer"
local Merger = Import.Module.Relative"Decomposable.Merger"

local Flat = Import.Module.Relative"Decomposable.Flat"

local NestedRule = Import.Module.Sister"Rule";


return DecomposableObject(
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
			local ConvertedRules = -self.Rules

			for Name, Rule in pairs(self.Rules.Entries) do
				if Rule%"Nested.PEG" then
					ConvertedRules.Entries[Name] = NestedRule(Rule)
				end
			end
			
			local Flattened = Merger("Flat.Grammar", ConvertedRules(Canonical))()
			return 
				Flattened
				and Flattened + self.Base
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
			
			Into.Rules = Into.Rules + From.Rules
		end;
	}
);
