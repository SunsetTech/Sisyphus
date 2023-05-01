local Tools = require"Moonrise.Tools"
local type = Tools.Inspect.GetType

local Import = require"Moonrise.Import"

local Object = Import.Module.Relative"Object"
local Aliasable = Import.Module.Relative"Objects.Aliasable"

return Object(
	"Template.Definition", {
		Construct = function(self, Basetype, Definition)
			assert(Basetype)
			assert(type(Definition) == "Sisyphus.Compiler.Object" and Definition%"Aliasable.Type.Definition", "Expected Aliasable.Type.Definition")
			self.Basetype = Basetype
			self.Definition = Definition
		end;

		Decompose = function(self)
			return self.Definition
		end;
	}
)
