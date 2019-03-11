local Tools = require"Toolbox.Tools"
local type = Tools.Type.GetType

local Import = require"Toolbox.Import"

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
