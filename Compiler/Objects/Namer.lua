local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"
local Format = Tools.String.Format

local Object = Import.Module.Relative"Object"
local CanonicalName = Import.Module.Sister"CanonicalName"

return Object(
	"Namer", {
		Construct = function(self, Types, Entries)
			self.Types =
				type(Types) == "string"
				and {Types}
				or Types
			
			self.Entries = Entries
		end;

		Decompose = function(self, Canonical)
			local NamedEntries = {}

			for Name, Entry in pairs(self.Entries) do
				local TypeCheck = false
				
				for _, Type in pairs(self.Types) do
					if Entry%Type then
						TypeCheck = true
						break
					end
				end
				
				Tools.Error.CallerAssert(
					TypeCheck, 
					Format"Expected (%s), got %s for %s"(table.concat(self.Types,", "), type(Entry), Name),
					1
				)
				
				local Fullname
				if Name == 1 then
					Fullname = Canonical
				else
					Fullname = CanonicalName(Name, Canonical)
				end
				
				table.insert(
					NamedEntries,
					Entry(Fullname)
				)
			end
			
			return NamedEntries
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
				assert(Into.Entries[Name] == nil)
				Into.Entries[Name] = Entry
			end
		end;
	}
)

