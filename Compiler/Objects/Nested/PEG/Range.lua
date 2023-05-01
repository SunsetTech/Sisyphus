local Import = require"Moonrise.Import"
local Tools = require"Moonrise.Tools"

local Vlpeg = Import.Module.Relative"Vlpeg"

local Object = Import.Module.Relative"Object"

return Object(
	"Nested.PEG.Range", {
		Construct = function(self, ...)
			self.Sets = {...}
		end;

		Decompose = function(self)
			return Vlpeg.Range(table.unpack(self.Sets))
		end;

		Copy = function(self)
			return table.unpack(Tools.Table.Copy(self.Sets))
		end;

		ToString = function(self)
			local Strings = {}
			for _, Set in pairs(self.Sets) do
				table.insert(Strings, "\27[32m".. Set .."\27[0m")
			end
			return '"'.. table.concat(Strings,",") ..'"'
		end;
	}
)
