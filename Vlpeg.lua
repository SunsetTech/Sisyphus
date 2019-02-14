local lpeg = require"lpeg"

local Package

Package = {
	Match = lpeg.match;

	Pattern = lpeg.P;
	Variable = lpeg.V;
	Range = lpeg.R;
	Set = lpeg.S;
	Group = lpeg.Cg;
	Table = lpeg.Ct;
	Args = lpeg.Carg;
	Position = lpeg.Cp;

	Apply = function(Pattern, Value)
		return Pattern / Value;
	end;

	Immediate = lpeg.Cmt;

	Select = function(First, Next, ...)
		return (Next 
			and Package.Select(First + Next, ...)
			or First
		)
	end;

	Sequence = function(First,Next,...)
		return (Next
			and Package.Sequence(First * Next, ...)
			or First
		)
	end;
}

return Package
