local Import = require"Moonrise.Import"
local Tools = require"Moonrise.Tools"
local Format = Tools.String.Format
local Object = Import.Module.Relative"Object"

return Object(
	"Merger", {
		Construct = function(self, Type, Items)
			self.Type = Type
			self.Items = Items
		end;

		Decompose = function(self)
			local Merged
			if (#self.Items >= 2) then
				local First = self.Items[1]
				local Rest = {}
				for Index = 2, #self.Items do
					local Item = self.Items[Index]
					
					--Tools.Error.CallerAssert(Item%(self.Type), Format"Expected a %s, got a %s"(self.Type, type(Item)), 1)
					
					table.insert(Rest, Item)
				end
	
				return First + Rest
			elseif (#self.Items == 1) then
				return self.Items[1]
			end
		end;
	}
)
