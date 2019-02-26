local Module = require"Toolbox.Import.Module"

local Compiler = require"Sisyphus.Compiler"
local Basic = Compiler.Objects.Basic
local PEG = Compiler.Objects.Nested.PEG
local Variable = PEG.Variable

local Syntax = Module.Relative"Objects.Syntax"
local Construct = Module.Relative"Objects.Construct"

return Basic.Namespace{
	Name = Module.Child"Name";
	Template = Module.Child"Template";
	Grammar = Module.Child"Grammar";

	Modified = Basic.Type.Definition(
		Construct.DynamicParse(
			Construct.Invocation( --TODO:Implement this function
				"@",
				Construct.ArgumentList{Variable.Canonical"Types.Basic.Grammar.Modifier"},
				function(Grammar)
					return Grammar/"userdata", {
						Grammar = Grammar;
						Variables = {};
					}
				end
			)
		)
	);
	
	Root = Basic.Type.Definition(
		Construct.Centered(
			PEG.Select{
				Variable.Canonical"Types.Basic.Modified",
				Variable.Canonical"Types.Aliasable.Data.String"
			}
		)
	);
}
