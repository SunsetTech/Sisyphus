local Vlpeg = require"Sisyphus_Old.Vlpeg"

local Import = require"Moonrise.Import"
local Object = Import.Module.Relative"Object"
local CanonicalName = Import.Module.Relative"CanonicalName"

return Object(
	"Nested.PEG.Variable.Child", {
		Construct = function(self, Target)
			assert(Target)
			self.Target = Target
		end;
		
		Decompose = function(self, Canonical)
			return Vlpeg.Variable(
				CanonicalName(self.Target, Canonical)()
			)
		end;
		
		Copy = function(self)
			return self.Target
		end;
		
		ToString = function(self)
			return ">".. self.Target
		end;
	}
);
