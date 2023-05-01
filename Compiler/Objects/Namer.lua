local Import = require"Moonrise.Import"
local OrderedMap = require"Moonrise.Object.OrderedMap"
local Object = Import.Module.Relative"Object"
local CanonicalName = Import.Module.Sister"CanonicalName"
local function print_caller_info()
	local info = debug.getinfo(3, "Sl") -- Get the caller's caller info (2 levels up)
    if info then
        print(string.format("Called from file %s at line %d", info.short_src, info.currentline))
		assert(info.short_src:match"Namer.lua$")
    else
        print("Could not get caller information.")
    end
end
---@class SisyphusO.Compiler.Objects.Namer
---@field Entries Moonrise.Object.OrderedMap
return Object(
	"Namer", {
		---@param self SisyphusO.Compiler.Objects.Namer
		---@param _Entries Moonrise.Object.OrderedMap
		Construct = function(self, Types, Entries, _Entries)
			self.Types =
				type(Types) == "string"
				and {Types}
				or Types
			
			if _Entries then
				self.Entries = _Entries
			else
				self.Entries = OrderedMap(Entries)
			end
			--self.Entries = setmetatable(Entries, {__newindex = function(_,k,v) print_caller_info() print("newindex",k,v) rawset(Entries, k, v) end;})
		end;
		
		---@param self SisyphusO.Compiler.Objects.Namer
		Add = function(self, Key, Value)
			--self.Entries[Key] = Value
			self.Entries:Add(Key, Value)
		end;
		
		---@param self SisyphusO.Compiler.Objects.Namer
		Decompose = function(self, Canonical)
			local NamedEntries = {}

			--for Name, Entry in pairs(self.Entries) do
			for NameIndex = 1, self.Entries:NumKeys() do 
				local Name, Entry = self.Entries:GetPair(NameIndex)
				local TypeCheck = false
				
				for TypeIndex = 1,#self.Types do
					local Type = self.Types[TypeIndex]
					if Entry%Type then
						TypeCheck = true
						break
					end
				end
				
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

		---@param self SisyphusO.Compiler.Objects.Namer
		Copy = function(self)
			local EntriesCopy = OrderedMap{}
			--for Name, Entry in pairs(self.Entries) do
			for NameIndex = 1, self.Entries:NumKeys() do
				local Name, Entry = self.Entries:GetPair(NameIndex)
				EntriesCopy:Add(Name, -Entry)
				--EntriesCopy[Name] = -Entry
			end
			return self.Types, nil, EntriesCopy
		end;

		---@param Into SisyphusO.Compiler.Objects.Namer
		---@param From SisyphusO.Compiler.Objects.Namer
		Merge = function(Into, From)
			--for Name, Entry in pairs(From.Entries) do
			for NameIndex = 1, From.Entries:NumKeys() do
				local Name, Entry = From.Entries:GetPair(NameIndex)
				assert(Into.Entries:Get(Name) == nil)
				--Into.Entries[Name] = Entry
				Into.Entries:Add(Name, Entry)
			end
		end;
	}
)

