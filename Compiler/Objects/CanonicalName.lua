local Import = require"Toolbox.Import"
local Error = require"Toolbox.Utilities.Error"

local Object = Import.Module.Relative"Object"

return Object(
	"CanonicalName", {
		Construct = function(self, Name, Namespace)
			Error.CallerAssert(type(Name) == "string", "Need a string for Name")
			
			self.Name = Name
			self.Namespace = Namespace
		end;
		Decompose = function(self)
			return
				self.Namespace
				and self.Namespace() ..".".. self.Name
				or self.Name
		end;
	}
)
