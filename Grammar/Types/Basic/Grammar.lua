local posix = require"posix"

local Tools = require"Toolbox.Tools"
local Import = require"Toolbox.Import"

local Vlpeg = require"Sisyphus.Vlpeg"
local Compiler = require"Sisyphus.Compiler"
local Template = Compiler.Objects.Template
local Basic = Compiler.Objects.Basic
local PEG = Compiler.Objects.Nested.PEG
local Variable = PEG.Variable

local Syntax = Import.Module.Relative"Objects.Syntax"
local Construct = Import.Module.Relative"Objects.Construct"

return Basic.Type.Set{
	Modifier = Basic.Type.Set{
		--Templated parse that takes a Grammar.Modifier and uses the new grammar to match and return a.. Grammar.Modifier.
		With = Basic.Type.Definition(
			Construct.DynamicParse(
				Construct.Invocation(
					"With",
					Construct.ArgumentList{Variable.Canonical"Types.Basic.Grammar.Modifier"},
					function(Grammar, Environment)
						Grammar.InitialPattern =
							PEG.Apply(
								Construct.Centered(Variable.Canonical"Types.Basic.Grammar.Modifier"),
								function(ModifiedGrammar)
									ModifiedGrammar.InitialPattern = Grammar.InitialPattern
									return ModifiedGrammar
								end
							)
						
						return
							Grammar/"userdata", {
								Grammar = Grammar;
								Variables = {};
							}
					end
				)
			)
		);

		File = Basic.Type.Definition(
			Construct.Invocation(
				"File",
				Construct.ArgumentList{Variable.Canonical"Types.Aliasable.Data.String"},
				function(Filename, Environment)
					local CurrentGrammar = Environment.Grammar

					local Path = posix.realpath(Filename)

					if not CurrentGrammar.Information.Files[Path] then
						local File = io.open(Path,"r")
						local Contents = File:read"a"
						File:close()
						
						local ResumePattern = CurrentGrammar.InitialPattern
						CurrentGrammar.InitialPattern = Variable.Canonical"Types.Basic.Grammar.Modifier"
						
						local ModifiedGrammar = Tools.Filesystem.ChangePath(
							Tools.Path.Join(Tools.Path.DirName(Path)),
							Vlpeg.Match,
							CurrentGrammar/"userdata",
							Contents, 1, {
								Grammar = CurrentGrammar;
								Variables = {};
							}
						)
						
						ModifiedGrammar.InitialPattern = ResumePattern
						ModifiedGrammar.Information.Files[Path] = true
						
						return ModifiedGrammar
					else
						return CurrentGrammar
					end
				end
			)
		);

		Templates = Basic.Type.Definition(
			Construct.Invocation(
				"Templates",
				PEG.Table(Construct.ArgumentArray(Variable.Canonical"Types.Basic.Template.Declaration")),
				function(Declarations, Environment)
					return Template.Grammar(
						Environment.Grammar,
						Compiler.Objects.Merger("Template.Namespace", Declarations)()
					)()
				end
			)
		);
	}
}
