local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"

local DecomposableObject = Import.Module.Relative"DecomposableObject"
local Nested = Import.Module.Relative"Decomposable.Nested"
local Basic = Import.Module.Relative"Decomposable.Basic"

local Aliasable = {
	Namespace = Import.Module.Sister"Namespace";
}

return DecomposableObject(
	"Aliasable.Grammar", {
		Construct = function(self, InitialPattern, AliasableTypes, BasicTypes, Syntax)
			self.InitialPattern = InitialPattern
			self.BasicTypes = BasicTypes or Basic.Namespace()
			Tools.Error.CallerAssert(Tools.Type.GetType(AliasableTypes) ~= "table", "why",1)
			self.AliasableTypes = AliasableTypes or Aliasable.Namespace()
			self.Syntax = Syntax or Nested.Grammar()
		end;

		Decompose = function(self)
			return Basic.Grammar(
				self.InitialPattern,
				Basic.Namespace{
					Aliasable = self.AliasableTypes();
					Basic = self.BasicTypes;
				},
				self.Syntax
			)
		end;

		Copy = function(self)
			return -self.InitialPattern, -self.AliasableTypes, -self.BasicTypes, -self.Syntax
		end;
	}
)
