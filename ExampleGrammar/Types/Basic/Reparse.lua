local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"
local Vlpeg = require"Sisyphus.Vlpeg"
local Compiler = require"Sisyphus.Compiler"
local Template = Compiler.Objects.Template
local Basic = Compiler.Objects.Basic
local Nested = Compiler.Objects.Nested
local PEG = Nested.PEG
local Variable = PEG.Variable
local Syntax = Import.Module.Relative"Objects.Syntax"
local Patterns = Import.Module.Relative"Objects.Patterns"
return Basic.Namespace{
	WithTemplates = Basic.Type.Definition(
		PEG.Immediate(
			PEG.Sequence{
				Syntax.Tokens{
					PEG.Pattern"WithTemplates",
					PEG.Table(Syntax.ArgumentArray(Variable.Canonical"Types.Basic.Template.Declaration"))
				},
				Patterns.GetEnvironment
			},
			function(Subject, Position, Declarations, Environment)
				local DeclarationsNamespace = Compiler.Objects.Merger("Template.Namespace", Declarations)()
				local NewTemplateGrammar = Template.Grammar(
					Environment.Grammar,
					DeclarationsNamespace
				)
				local NewAliasableGrammar = NewTemplateGrammar()
				NewAliasableGrammar.InitialPattern = PEG.Apply(
					PEG.Sequence{
						PEG.Table(
							Variable.Canonical"Types.Basic.Root"
						),
						PEG.Position()
					},
					function(Returns, Position)
						return Position, table.unpack(Returns)
					end
				)
				local Returns = {Vlpeg.Match(
					NewAliasableGrammar/"userdata",
					Subject, Position, {
						Grammar = NewAliasableGrammar;
						Variables = Environment.Variables;
					}
				)}
				return table.unpack(Returns)
			end
		)
	);
}
