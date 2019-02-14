local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"
local DecomposableObject = Import.Module.Relative"DecomposableObject"

return DecomposableObject(
	"Array", {
		Construct = function(self, Type, Items)
			assert(Items)
			self.Type = Type
			self.Items = Items
		end;

		Decompose = function(self, ...)
			local Decomposed = {}
			
			for Index, Item in pairs(self.Items) do
				Tools.Error.CallerAssert(type(Index) == "number", "Expected a numeric index", 1)
				Tools.Error.CallerAssert(Item%(self.Type), "Expected a ".. self.Type, 1)
			
				Decomposed[Index] = Item(...)
			end

			return Decomposed
		end;

		Copy = function(self)
			local ItemsCopy = {}
			
			for Index, Item in pairs(self.Items) do
				ItemsCopy[Index] = -Item
			end
			
			return self.Type, ItemsCopy
		end;
	}
)




