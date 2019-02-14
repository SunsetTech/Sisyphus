local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"
local Format = Tools.String.Format
local DecomposableObject = Import.Module.Relative"DecomposableObject"

return DecomposableObject(
	"Merger", {
		Construct = function(self, Type, Items)
			self.Type = Type
			self.Items = Items
		end;

		Decompose = function(self)
			local Merged
			
			for Index, Item in pairs(self.Items) do
				Tools.Error.CallerAssert(type(Index) == "number", "Expected a numeric index", 1)
				Tools.Error.CallerAssert(Item%(self.Type), Format"Expected a %s, got a %s"(self.Type, type(Item)), 1)

				Merged = 
					Merged
					and Merged + Item
					or Item
			end

			return Merged
		end;
	}
)
