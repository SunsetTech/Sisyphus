
local Import = require"Moonrise.Import"
local Tools = require"Moonrise.Tools"

local type = Tools.Inspect.GetType

local Object = Import.Module.Relative"Object"
local CanonicalName = Import.Module.Relative"CanonicalName"
local Flat = Import.Module.Relative"Flat"

return Object(
	"Nested.Rule", {
		Construct = function(self, Pattern)
			assert(Pattern ~= nil)
			self.Pattern = Pattern
		end;

		Decompose = function(self, Canonical)
			local Name = (
				Canonical
				and Canonical()
				or 1
			)
			--DebugOutput:Format"Generating rule %s = %s"(Name, type(self.Pattern))
			return Flat.Grammar{
				[Name] = self.Pattern(Canonical);
			}
		end;
		Copy = function(self)
			return -self.Pattern
		end;
	}
)
