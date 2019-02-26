local Import = require"Toolbox.Import"

local Vlpeg = require"Sisyphus.Vlpeg"

local Static = Import.Module.Sister"Static"

local Package = {}

Package = {
	Concatenate = function(Seperator, First, Next, ...)
		return (Next
			and Package.Concatenate(
				Seperator, 
				Vlpeg.Sequence(First, Seperator, Next), ...
			)
			or First
		)
	end;

	Tokens = function(...)
		return Package.Concatenate(Static.Whitespace^0, ...)
	end;

	Delimited = function(Open, Pattern, Close, Joiner)
		Joiner = Joiner or Package.Tokens
		return Joiner(Open, Pattern, Close)
	end;

	Quoted = function(Delimiter, Pattern)
		return Package.Delimited(Delimiter, Pattern, Delimiter)
	end;

	Centered = function(Pattern)
		return Package.Quoted(Static.Whitespace^0, Pattern)
	end;

	Continuation = function(Pattern)
		return Package.Tokens(Static.Nothing, Pattern)
	end;

	Array = function(Pattern, Seperator, Joiner)
		Joiner = Joiner or Package.Tokens
		return Joiner(Pattern,Joiner(Seperator, Pattern)^0)
	end;

	List = function(Patterns, Seperator)
		return Package.Concatenate(Seperator, table.unpack(Patterns))
	end;

	Optional = function(Pattern)
		return Vlpeg.Pattern(Pattern)^-1
	end;
}

return Package
