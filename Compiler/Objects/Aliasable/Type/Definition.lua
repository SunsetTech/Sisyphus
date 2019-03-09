local Tools = require"Toolbox.Tools"
local Table = Tools.Table
local Import = require"Toolbox.Import"

local Object = Import.Module.Relative"Object"

local AliasList = Import.Module.Sister"AliasList"
local Basic = Import.Module.Relative"Objects.Basic"
local Nested = Import.Module.Relative"Objects.Nested"
local PEG = Nested.PEG

local Completable = Import.Module.Relative"PEG.Completable"
local Namespace = Import.Module.Relative"Namespace"

return Object(
	"Aliasable.Type.Definition", {
		Construct = function(self, Pattern, Function, Syntax, AliasableTypes, BasicTypes, Aliases)
			self.Pattern = Pattern
			self.Function = Function
			self.Syntax = Syntax or Nested.Grammar()
			--assert(Tools.Type.GetType(AliasableTypes) ~= "table")
			self.AliasableTypes = AliasableTypes or Namespace()
			self.BasicTypes = BasicTypes or Basic.Namespace()
			self.Aliases = Tools.Error.NotMine(AliasList,Aliases)
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

		Merge = function(Into, From)
			print("Not merging ".. tostring(Into) .." with ".. tostring(From))
			print("TODO: fix this by dropping one of the duplicate types")
		end;
	}
)
