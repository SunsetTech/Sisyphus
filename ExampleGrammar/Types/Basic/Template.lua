local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"

local Compiler = require"Sisyphus.Compiler"
local Basic = Compiler.Objects.Basic
local Nested = Compiler.Objects.Nested
local Template = Compiler.Objects.Template

local PEG = Nested.PEG
local Variable = PEG.Variable

local Syntax = Import.Module.Relative"Objects.Syntax"
local Patterns = Import.Module.Relative"Objects.Patterns"

local Vlpeg = require"Sisyphus.Vlpeg"

local function CreateNamespaceFor(Entry, Canonical)
	local Namespace = Template.Namespace{
		[Canonical.Name] = Entry;
	}
	if Canonical.Namespace then
		return CreateNamespaceFor(
			Namespace,
			Canonical.Namespace
		)
	else
		return Namespace
	end
end

--{Basic{String}} -> {String{Basic}}

local function InvertName(Canonical)
	local Inverted = Compiler.Objects.CanonicalName(Canonical.Name)
	while(Canonical.Namespace) do
		Canonical = Canonical.Namespace
		Inverted = Compiler.Objects.CanonicalName(Canonical.Name, Inverted)
	end
	return Inverted
end

local function ParseDefinition(Subject, Position, Name, Parameters, Basetype, Environment)
	local CurrentAliasableGrammar = -Environment.Grammar --Copy the current grammar
	
	local TargetRule = Compiler.Objects.CanonicalName(
		InvertName(Basetype)(), 
		Compiler.Objects.CanonicalName"Types.Aliasable"
	)()

	local ArgumentPatterns = {}

	for Index, Parameter in pairs(Parameters) do
		ArgumentPatterns[Index] = Variable.Canonical(
			Compiler.Objects.CanonicalName(
				InvertName(Parameter.Type)(), 
				Compiler.Objects.CanonicalName"Types.Aliasable"
			)()
		)
	end

	CurrentAliasableGrammar.InitialPattern = PEG.Apply( --Edit the initial pattern to match Basetype
		PEG.Sequence{
			PEG.Apply(
				Variable.Canonical(TargetRule), --The returns matching the type, either values or a resolvable, shove them into some kind of object to resolve later
				function(...)
					return Compiler.Transform.Incomplete(
						{...},
						function(...)
							return ... --............
						end
					)
				end
			),
			PEG.Position()
		},
		function(Finish, Position)
			return 
				Position, 
				CreateNamespaceFor(
					Template.Definition(
						Basetype,
						PEG.Sequence{
							Patterns.GetEnvironment,
							Syntax.Tokens{
								PEG.Pattern(Name.Name),
								Syntax.ArgumentList(ArgumentPatterns),
							}
						},
						function(Environment, ...)
							local Arguments = {...}
							for Index, Parameter in pairs(Parameters) do
								Environment.Variables[Parameter.Name] = Arguments[Index]
							end
							return Finish(Environment)
						end
					),
					Name
				)
		end
	)

	local ParameterNamespace = Template.Namespace()

	for Index, Parameter in pairs(Parameters) do
		ParameterNamespace.Children.Entries[Parameter.Name] = Template.Definition(
			Parameter.Type,
			PEG.Pattern("^".. Parameter.Name),
			function()
				--print(Environment)
				--assert(Environment.Variables)
				return Compiler.Transform.Resolvable(
					function(Environment)
						return Environment.Variables[Parameter.Name]
						--[[assert(Environment.Variables[Parameter.Name])
						return Environment.Variables[Parameter.Name]]
					end
				)
			end
		);
	end

	local DefinitionTemplateGrammar = Template.Grammar(
		CurrentAliasableGrammar,
		ParameterNamespace
	)
	
	local DefinitionAliasableGrammar = DefinitionTemplateGrammar()
	local Resume, Def = Vlpeg.Match(
		DefinitionAliasableGrammar/"userdata",
		Subject, Position, {
			Grammar = DefinitionAliasableGrammar;
		}
	)
	return Resume, Def
end

return Basic.Namespace{
	Parameter = Basic.Type.Definition(
		PEG.Table(
			Syntax.ArgumentList{
				PEG.Group("Type", Variable.Canonical"Types.Basic.Name.Target"),
				PEG.Group("Name", Variable.Canonical"Types.Basic.Name.Part")
			}
		)
	);
	Parameters = Basic.Type.Definition(
		PEG.Table(
			Syntax.ArgumentArray(
				Variable.Canonical"Types.Basic.Template.Parameter"
			)
		)
	);
	Declaration = Basic.Type.Definition(
		PEG.Immediate(
			PEG.Sequence{
				Syntax.Tokens{
					Syntax.Optional(PEG.Pattern"Declaration"),
					Syntax.ArgumentList{
						Variable.Canonical"Types.Basic.Name.Canonical", 
						Variable.Canonical"Types.Basic.Template.Parameters",
						Variable.Canonical"Types.Basic.Name.Target"
					}
				},
				Patterns.GetEnvironment
			},
			ParseDefinition
		)
	);
}
