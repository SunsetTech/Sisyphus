local Import = require"Toolbox.Import"

local Vlpeg = require"Sisyphus.Vlpeg"

local Patterns = Import.Module.Sister"Patterns"

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
		return Package.Concatenate(Patterns.Whitespace^0, ...)
	end;

	Delimited = function(Open, Pattern, Close, Joiner)
		Joiner = Joiner or Package.Tokens
		return Joiner(Open, Pattern, Close)
	end;

	Quoted = function(Delimiter, Pattern)
		return Package.Delimited(Delimiter, Pattern, Delimiter)
	end;

	Centered = function(Pattern)
		return Package.Quoted(Patterns.Whitespace^0, Pattern)
	end;

	Continuation = function(Pattern)
		return Package.Tokens(Patterns.Nothing, Pattern)
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
