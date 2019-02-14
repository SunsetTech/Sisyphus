local DebugOutput = require"Toolbox.Debug.Registry".GetDefaultPipe()

local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"

local type = Tools.Type.GetType

local DecomposableObject = Import.Module.Relative"DecomposableObject"
local CanonicalName = Import.Module.Relative"CanonicalName"
local Flat = Import.Module.Relative"Flat"

return DecomposableObject(
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
