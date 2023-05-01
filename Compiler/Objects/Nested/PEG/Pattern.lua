local lpeg = require"lpeg"

local Import = require"Moonrise.Import"

local Object = Import.Module.Relative"Object"

return Object(
	"Nested.PEG.Pattern", {
		Construct = function(self, Pattern)
			self.Pattern = Pattern
		end;
		
		Decompose = function(self, Canonical)
			return lpeg.P(self.Pattern)
		end;
		
		Copy = function(self)
			return self.Pattern
		end;

		ToString = function(self)
			if type(self.Pattern) == "userdata" then
				return"\27[34m".. tostring(self.Pattern) .."\27[0m"
			else
				return "\27[30m\27[4m".. tostring(self.Pattern):gsub("\r","\\r"):gsub("\n","\\n") .."\27[0m"
			end
		end;
	}
)
