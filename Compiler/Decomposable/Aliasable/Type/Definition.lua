local Tools = require"Toolbox.Tools"
local Table = Tools.Table
local Import = require"Toolbox.Import"

local DecomposableObject = Import.Module.Relative"DecomposableObject"

local AliasList = Import.Module.Sister"AliasList"
local Basic = Import.Module.Relative"Decomposable.Basic"
local Nested = Import.Module.Relative"Decomposable.Nested"
local PEG = Nested.PEG

local Completable = Import.Module.Relative"PEG.Completable"
local Namespace = Import.Module.Relative"Namespace"

return DecomposableObject(
	"Aliasable.Type.Definition", {
		Construct = function(self, Pattern, Function, Syntax, AliasableTypes, BasicTypes, Aliases)
			self.Pattern = Pattern
			self.Function = Function
			self.Syntax = Syntax or Nested.Grammar()
			--assert(Tools.Type.GetType(AliasableTypes) ~= "table")
			self.AliasableTypes = AliasableTypes or Namespace()
			self.BasicTypes = BasicTypes or Basic.Namespace()
			self.Aliases = AliasList(Aliases)
		end;

		Decompose = function(self)
			return Basic.Type.Definition(
				Nested.PEG.Select{ 
					Completable(
						self.Pattern,
						self.Function
					),
					Nested.PEG.Variable.Child"Syntax.Aliases"
				}, (
					Nested.Grammar{
						Aliases = self.Aliases();
					}
					+ self.Syntax
				),
				Basic.Namespace{
					Aliasable = self.AliasableTypes();
					Basic = self.BasicTypes;
				}
			)
		end;

		Copy = function(self)
			return -self.Pattern, self.Function, -self.Syntax, -self.AliasableTypes, -self.BasicTypes, (-self.Aliases).Names
		end;
	}
)
