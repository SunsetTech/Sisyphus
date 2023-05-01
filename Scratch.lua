local function RegisterTemplates(Templates, AliasableTypes, Canonical)
	for Name, Entry in pairs(Templates.Children.Entries) do
		if Entry%"Template.Namespace" then
			Error.NotMine(
				RegisterTemplates, 
				Entry, AliasableTypes, CanonicalName(Name, Canonical)
			)
		elseif Entry%"Template.Definition" then
			assert(Entry.Basetype)
			
			local AliasableType = Error.NotMine(
				LookupAliasableType,
				AliasableTypes, Entry.Basetype
			)
			assert(AliasableType%"Aliasable.Type.Definition")
			
			table.insert(AliasableType.Aliases.Names, CanonicalName(Name, Canonical)())
		end
	end
	return 
end



