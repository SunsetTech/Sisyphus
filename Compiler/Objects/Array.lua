local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"
local Object = Import.Module.Relative"Object"

return Object(
	"Array", {
		Construct = function(self, Type, Items)
			assert(Items)
			self.Type = Type
			self.Items = Items
			for Index, Item in pairs(self.Items) do
				Tools.Error.CallerAssert(type(Index) == "number", "Expected a numeric index, got ".. Index)
				Tools.Error.CallerAssert(Item%(self.Type), "Expected a ".. self.Type)
			end
		end;

		Decompose = function(self, ...)
			local Decomposed = {}
			
			for Index, Item in pairs(self.Items) do
				Tools.Error.CallerAssert(type(Index) == "number", "Expected a numeric index, got ".. Index)
				Tools.Error.CallerAssert(Item%(self.Type), "Expected a ".. self.Type)
			
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




