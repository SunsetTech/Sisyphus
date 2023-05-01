local Import = require"Moonrise.Import"
local Tools = require"Moonrise.Tools"
local OrderedMap=require"Moonrise.Object.OrderedMap"
local type = Tools.Inspect.GetType
local Format = Tools.String.Format

local Object = Import.Module.Relative"Object"

local function print_caller_info()
    local info = debug.getinfo(4, "Sl") -- Get the caller's caller info (2 levels up)
    if info then
        print(string.format("Called from file %s at line %d", info.short_src, info.currentline))
    else
        print("Could not get caller information.")
    end
end
return Object(
	"Map", {
		Construct = function(self, Types, Entries, _Entries)
			--print_caller_info()
			self.Types =
				type(Types) == "string"
				and {Types}
				or Types
			--self.Entries = setmetatable(Entries, {__newindex=function(_,k,v) print(k,v) print_caller_info() rawset(Entries, k, v) end;})
			self.Entries = Entries or {}
		end;
		Add = function(self, Key, Value)
			self.Entries[Key] = Value
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
				--[[Tools.Error.CallerAssert(
					TypeCheck, 
					Format"Expected (%s), got %s"(table.concat(self.Types,", "), getmetatable(Entry).__typename)
				)]]
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
					Into.Entries[Name] = From.Entries[Name]
				end
			end
		end;
	}
)

