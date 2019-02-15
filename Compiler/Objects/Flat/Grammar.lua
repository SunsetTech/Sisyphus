--Thin map over an lpeg grammar table, returns a compiled lpeg grammar
local lpeg = require"lpeg"

local Module = require"Toolbox.Import.Module"
local Tools = require"Toolbox.Tools"

local Object = Module.Relative"Object"

return Object(
	"Flat.Grammar", {
		Construct = function(self, Rules)
			self.Rules = Rules or {}
		end;

		Decompose = function(self)
			return lpeg.P(self.Rules)
		end;

		Copy = function(self)
			return Tools.Table.Copy(self.Rules)
		end,
		
		Merge = function(Into, From)
			for Name, Rule in pairs(From.Rules) do
				Tools.Error.CallerAssert(Into.Rules[Name] == nil, "Cant overwrite existing rule ".. Name,1)
				Into.Rules[Name] = Rule
			end
		end
	}
);
