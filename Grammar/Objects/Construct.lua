local Tools = require"Toolbox.Tools"
local Import = require"Toolbox.Import"

local Vlpeg = require"Sisyphus.Vlpeg"
local Compiler = require"Sisyphus.Compiler"
local PEG = Compiler.Objects.Nested.PEG

local Syntax = Import.Module.Sister"Syntax"
local Static = Import.Module.Sister"Static"

local Package

Package = {
	DynamicParse = function(Pattern)
		return PEG.Immediate(
			Pattern,
			function(Subject, Position, Grammar, ...)
				Tools.Error.CallerAssert(type(Grammar) == "userdata", "Expected a userdata(lpeg pattern)")
				return Vlpeg.Match(
					Vlpeg.Apply(
						Vlpeg.Sequence(
							Tools.Error.NotMine(Vlpeg.Table,Grammar), 
							Vlpeg.Position()
						),
						function(Returns, Position)
							return Position, table.unpack(Returns)
						end
					),
					Subject, Position, ...
				)
			end
		)
	end;

	Invocation = function(Disambiguator, Pattern, Function)
		return PEG.Apply(
			PEG.Sequence{
				Syntax.Tokens{
					PEG.Pattern(Disambiguator),
					Pattern
				},
				Static.GetEnvironment
			},
			Function
		)
	end;

	Delimited = function(Open, Pattern, Close, Joiner)
		Joiner = Joiner or Syntax.Tokens
		return Joiner{Open, Pattern, Close}
	end;

	Quoted = function(Delimiter, Pattern)
		return Package.Delimited(Delimiter, Pattern, Delimiter)
	end;

	Centered = function(Pattern)
		return Package.Quoted(Syntax.All(Static.Whitespace), Pattern)
	end;
	
	Array = function(Pattern, Seperator, Joiner)
		Joiner = Joiner or Syntax.Tokens
		return Joiner{Pattern, Syntax.All(Joiner{Seperator, Pattern})}
	end;
	
	ArgumentArray = function(ArgumentPattern)
		return Package.Delimited(
			PEG.Pattern"<",
			Package.Array(
				ArgumentPattern,
				Package.Centered(Syntax.Optional(PEG.Pattern","))
			),
			PEG.Pattern">"
		)
	end;

	ArgumentList = function(Patterns)
		local Undelimited = Syntax.List(Patterns, Package.Centered(Syntax.Optional(PEG.Pattern(","))))
		local Delimited = Package.Delimited(
			PEG.Pattern"<",
			Undelimited,
			PEG.Pattern">"
		)
		return PEG.Select{
			Undelimited,
			Delimited
		}
	end;
}

return Package
