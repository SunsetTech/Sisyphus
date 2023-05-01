--Thin map over an lpeg grammar table, returns a compiled lpeg grammar
local lpeg = require"lpeg"

local Module = require"Moonrise.Import.Module"
local Tools = require"Moonrise.Tools"

local Object = Module.Relative"Object"
local function print_callstack()
    local level = 2 -- Start from the level above the current function
    while true do
        local info = debug.getinfo(level, "Sln")
        if not info then break end -- Stop when there's no more information

        local src = info.short_src or "[unknown]"
        local line = info.currentline or -1
        local func_name = info.name or "[unknown]"
        print(string.format("Level %d: %s:%d (%s)", level - 1, src, line, func_name))

        level = level + 1
    end
end
return Object(
	"Flat.Grammar", {
		Construct = function(self, Rules, Names, InNames)
			--print_callstack()
			self.Rules = Rules or {}
			self.Names = Names or {}
			self.InNames = InNames or {}
			if not Names then
				for Name in pairs(Rules or {}) do
					self.InNames[Name] = true
					table.insert(self.Names, Name)
				end
			end
		end;

		Decompose = function(self)
			return lpeg.P(self.Rules)
		end;

		Copy = function(self)
			local Rules, Names, InNames = {},{},{}
			for NameIndex = 1, #self.Names do
				local Name = self.Names[NameIndex]
				local Rule = self.Rules[Name]
				Rules[Name] = Rule
				Names[NameIndex] = Name
				InNames[Name] = true
			end
			return Rules, Names, InNames
			--return Tools.Table.Copy(self.Rules)
		end,
		
		SetRule = function(self, Name, Rule)
			if not self.InNames[Name] then
				table.insert(self.Names, Name)
				self.InNames[Name] = true
			end
			self.Rules[Name] = Rule
		end;
		
		Merge = function(Into, From)
			for NameIndex = 1, #From.Names do
				local Name = From.Names[NameIndex]
				local Rule = From.Rules[Name]
				if not Into.InNames[Name] then
					table.insert(Into.Names, Name)
					Into.InNames[Name] = true
				end
				Into.Rules[Name] = Rule
			end
			--[[for Name, Rule in pairs(From.Rules) do
				Tools.Error.CallerAssert(Into.Rules[Name] == nil, "Cant overwrite existing rule ".. Name,1)
				Into.Rules[Name] = Rule
			end]]
		end
	}
);
