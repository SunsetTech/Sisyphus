local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"
local type = Tools.Type.GetType
local Format = Tools.String.Format

local Object = Import.Module.Relative"Object"

return Object(
	"Map", {
		Construct = function(self, Types, Entries)
			self.Types =
				type(Types) == "string"
				and {Types}
				or Types
			self.Entries = Entries
		end;

		Decompose = function(self)
			local Decomposed = {}

			for Key, Entry in pairs(self.Entries) do
				local TypeCheck = false
				for _, Type in pairs(self.Types) do
					if Entry%Type then
						TypeCheck = true
						break
					end
				end
				Tools.Error.CallerAssert(
					TypeCheck, 
					Format"Expected (%s), got %s"(table.concat(self.Types,", "), type(Entry))
				)
				Decomposed[Key] = Entry()
			end

			return Decomposed
		end;

		Copy = function(self)
			local EntriesCopy = {}
			for Name, Entry in pairs(self.Entries) do
				EntriesCopy[Name] = -Entry
			end
			return self.Types, EntriesCopy
		end;

		Merge = function(Into, From)
			for Name, Entry in pairs(From.Entries) do
				if Into.Entries[Name] then
					Into.Entries[Name] = Into.Entries[Name] + From.Entries[Name]
				else
					Into.Entries[Name] = -From.Entries[Name]
				end
			end
		end;
	}
)

