local Import = require"Toolbox.Import"

local Compiler = require"Sisyphus.Compiler"

local CanonicalName = Compiler.Objects.CanonicalName
local Aliasable = Compiler.Objects.Aliasable
local Nested = Compiler.Objects.Nested
local PEG = Nested.PEG
local Variable = PEG.Variable

local Construct = Import.Module.Relative"Objects.Construct"
local Incomplete = Import.Module.Relative"Objects.Incomplete"

local function CreateNamespaceFor(Entry, Canonical)
	local Namespace = Aliasable.Namespace{
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

return Aliasable.Namespace {
	String = Aliasable.Type.Definition(
		Variable.Child"Syntax",
		function(...)
			return ...
		end,
		Nested.Grammar{
			Delimiter = PEG.Pattern'"';
			Open = Variable.Sibling"Delimiter";
			Close = Variable.Sibling"Delimiter";
			Contents = PEG.Capture(
				PEG.All(
					PEG.Dematch(
						PEG.Pattern(1),
						Variable.Sibling"Delimiter"
					)
				)
			);
			PEG.Sequence{Variable.Child"Open", Variable.Child"Contents", Variable.Child"Close"};
		}
	);

	Array = Incomplete(
		function(Canonical)--Array<TypeSpecifier>
			Canonical = InvertName(Canonical)
			return PEG.Debug(PEG.Apply(
				PEG.Debug(Construct.ArgumentList{PEG.Debug(Variable.Canonical"Types.Basic.Template.TypeSpecifier")}),
				function(Specifier) -- Generate the match Specifier and the Added Types
					local GeneratedTypes = Aliasable.Namespace()

					if Specifier.GeneratedTypes then
						GeneratedTypes = GeneratedTypes + Specifier.GeneratedTypes
					end
					
					
					local InstanceName = CanonicalName(Canonical.Name .."<".. InvertName(Specifier.Target)() ..">", Canonical.Namespace)
					
					local Namespace = CreateNamespaceFor(
						Aliasable.Type.Definition(
							PEG.Debug(Construct.ArgumentArray(
								PEG.Debug(Variable.Canonical(
									CanonicalName(
										InvertName(Specifier.Target)(),
										CanonicalName"Types.Aliasable"
									)()
								))
							)),
							function(...)
								return {...}
							end
						),
						InstanceName
					)
					return 
						InvertName(InstanceName),
						GeneratedTypes
						+ Namespace
				end
			))
		end
	);
}
