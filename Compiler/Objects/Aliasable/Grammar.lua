local Import = require"Moonrise.Import"
local Tools = require"Moonrise.Tools"

local Object = Import.Module.Relative"Object"
local Nested = Import.Module.Relative"Objects.Nested"
local Basic = Import.Module.Relative"Objects.Basic"

local Aliasable = {
	Namespace = Import.Module.Sister"Namespace";
}

return Object(
	"Aliasable.Grammar", {
		Construct = function(self, InitialPattern, AliasableTypes, BasicTypes, Syntax, Information)
			self.InitialPattern = InitialPattern
			self.BasicTypes = BasicTypes or Basic.Namespace()
			self.AliasableTypes = AliasableTypes or Aliasable.Namespace()
			self.Syntax = Syntax or Nested.Grammar()
			self.Information = Information or {}
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
			return -self.InitialPattern, -self.AliasableTypes, -self.BasicTypes, -self.Syntax, Tools.Table.Copy(self.Information)
		end;
	}
)
