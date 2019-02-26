local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"

local Compiler = require"Sisyphus.Compiler"
local CanonicalName = Compiler.Objects.CanonicalName
local Basic = Compiler.Objects.Basic
local Nested = Compiler.Objects.Nested
local Template = Compiler.Objects.Template

local PEG = Nested.PEG
local Variable = PEG.Variable

local Objects = Import.Module.Relative"Objects"
local Syntax = Objects.Syntax
local Static = Objects.Static
local Construct = Objects.Construct

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

local function InvertName(Canonical)
	local Inverted = Compiler.Objects.CanonicalName(Canonical.Name)
	while(Canonical.Namespace) do
		Canonical = Canonical.Namespace
		Inverted = Compiler.Objects.CanonicalName(Canonical.Name, Inverted)
	end
	return Inverted
end

local function CreateArgumentsPattern(Parameters)
	local ArgumentPatterns = {}

	for Index, Parameter in pairs(Parameters) do
		ArgumentPatterns[Index] = Variable.Canonical(
			Compiler.Objects.CanonicalName(
				InvertName(Parameter.Type)(), 
				Compiler.Objects.CanonicalName"Types.Aliasable"
			)()
		)
	end

	return Construct.ArgumentList(ArgumentPatterns)
end

function DefinitionGenerator(Name, Parameters, Basetype)
	return function(Finish)
		return 
			CreateNamespaceFor(
				Template.Definition(
					Basetype,
					PEG.Sequence{
						Static.GetEnvironment,
						Syntax.Tokens{
							PEG.Optional(PEG.Pattern(Name.Name)),
							CreateArgumentsPattern(Parameters),
						}
					},
					function(Environment, ...)
						local Arguments = {...}
						local OldValues = {}
						for Index, Parameter in pairs(Parameters) do
							Environment.Variables[Parameter.Name] = Arguments[Index]
							OldValues[Parameter.Name] = Environment.Variables[Parameter.Name]
						end
						local Returns = {Finish(Environment)}
						for Name, Value in pairs(OldValues) do
							Environment.Variables[Name] = Value
						end
						return table.unpack(Returns)
					end
				),
				Name
			)
	end
end

local function BoxReturns(...)
	return Compiler.Transform.Incomplete(
		{...},
		function(...)
			return ...
		end
	)
end

local function CreateParameterNamespace(Parameters)
	local ParameterNamespace = Template.Namespace()

	for Index, Parameter in pairs(Parameters) do
		ParameterNamespace.Children.Entries[Parameter.Name] = Template.Definition(
			Parameter.Type,
			PEG.Pattern(Parameter.Name),
			function()
				return Compiler.Transform.Resolvable(
					function(Environment)
						return Environment.Variables[Parameter.Name]
					end
				)
			end
		);
	end

	return ParameterNamespace
end

local function GenerateDefinitionGrammar(Name, Parameters, Basetype, Environment)
	local CurrentAliasableGrammar = Environment.Grammar --Copy the current grammar
	
	local BasetypeRule = CanonicalName(InvertName(Basetype)(), CanonicalName"Types.Aliasable")()

	local ResumePattern = CurrentAliasableGrammar.InitialPattern
	CurrentAliasableGrammar.InitialPattern = PEG.Apply( --Edit the initial pattern to match Basetype
		PEG.Apply(
			Variable.Canonical(BasetypeRule), --The returns matching the type, either values or a resolvable representing the unfinished transform
			function(...)
				CurrentAliasableGrammar.InitialPattern = ResumePattern
				return BoxReturns(...) --Box them to finish at template invocation
			end
		),
		DefinitionGenerator(Name, Parameters, Basetype)
	)


	local DefinitionTemplateGrammar = Template.Grammar(
		CurrentAliasableGrammar,
		CreateParameterNamespace(Parameters)
	)
	
	local DefinitionAliasableGrammar = DefinitionTemplateGrammar()
	return 
		DefinitionAliasableGrammar/"userdata", {
			Grammar = DefinitionAliasableGrammar;
			Variables = {};
		}
end

return Basic.Namespace{
	Parameter = Basic.Type.Definition(
		PEG.Table(
			Construct.ArgumentList{
				PEG.Group("Type", Variable.Canonical"Types.Basic.Name.Target"),
				PEG.Group("Name", Variable.Canonical"Types.Basic.Name.Part")
			}
		)
	);

	Parameters = Basic.Type.Definition(
		PEG.Table(
			Construct.ArgumentArray(
				Variable.Canonical"Types.Basic.Template.Parameter"
			)
		)
	);

	Declaration = Basic.Type.Definition(
		Construct.DynamicParse(
			Construct.Invocation(
				"Template",
				Construct.ArgumentList{
					Variable.Canonical"Types.Basic.Name.Canonical",
					Variable.Canonical"Types.Basic.Template.Parameters",
					Variable.Canonical"Types.Basic.Name.Target"
				},
				GenerateDefinitionGrammar
			)
		)
	);
}
