local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"
local type = Tools.Type.GetType

local Object = Import.Module.Relative"Object"
local CanonicalName = Import.Module.Relative"Objects.CanonicalName"
local Aliasable = Import.Module.Relative"Objects.Aliasable"
local Template = {
	Namespace = Import.Module.Sister"Namespace";
}

local function LookupAliasableType(In, Canonical)
	if Canonical then
		if In%"Aliasable.Namespace" then
			return LookupAliasableType(In.Children.Entries[Canonical.Name], Canonical.Namespace)
		else
			Tools.Error.CallerError(Tools.String.Format"Can't lookup %s in %s"(Canonical.Name, In))
		end
	else
		Tools.Error.CallerAssert(In and In%"Aliasable.Type.Definition", "Didnt find an aliasable type, got ".. tostring(In))
		return In
	end
end

local function RegisterTemplates(AliasableTypes, Templates, Canonical)
	for Name, Entry in pairs(Templates.Children.Entries) do
		if Entry%"Template.Namespace" then
			Tools.Error.NotMine(RegisterTemplates,AliasableTypes, Entry, CanonicalName(Name, Canonical))
		elseif Entry%"Template.Definition" then
			assert(Entry.Basetype)
			local AliasableType = Tools.Error.NotMine(LookupAliasableType,AliasableTypes, Entry.Basetype)
			assert(AliasableType%"Aliasable.Type.Definition")
			table.insert(AliasableType.Aliases.Names, CanonicalName(Name, Canonical)())
		end
	end
	return 
end

return Object(
	"Template.Grammar", {
		Construct = function(self, AliasableGrammar, Templates)
			self.AliasableGrammar = AliasableGrammar or Aliasable.Grammar()
			self.Templates = Templates or Template.Namespace()
		end;

		Decompose = function(self) --Decomposes into an Aliasable.Grammar
			local Copy = self.AliasableGrammar
			Copy = Aliasable.Grammar(
				Copy.InitialPattern,
				-Copy.AliasableTypes,
				Copy.BasicTypes,
				Copy.Syntax,
				Copy.Information
			)

			Tools.Error.NotMine(RegisterTemplates,
				Copy.AliasableTypes, 
				self.Templates,
				CanonicalName"Types.Aliasable.Templates"
			)

			Copy.AliasableTypes.Children.Entries.Templates =
				Aliasable.Namespace()
				+ {
					(Copy.AliasableTypes.Children.Entries.Templates or Aliasable.Namespace()),
					self.Templates()
				}
			
			return Copy
		end;
	}
)
