local Tools = require"Moonrise.Tools"

local Format = function(String)
	return function(...)
		return String:format(...)
	end
end

local rawtype = type
local type = Tools.Inspect.GetType
local __call = function(self, ...) --Decompose
	local Definition = getmetatable(self).__definition
	--DebugOutput:Format"Decomposing a %s"(type(self))
	--DebugOutput:Push()

	local Decomposed = Tools.Error.NotMine(Definition.Decompose,self, ...)
	
	if getmetatable(Decomposed) then
		getmetatable(Decomposed).__source = self; --TODO preserve during copy
	end
	
	--DebugOutput:Pop()
	--DebugOutput:Format"Decomposed a %s into a %s"(type(self), type(Decomposed))
	
	return Decomposed
end;

local __unm = function(self) --Copy
	local Definition = getmetatable(self).__definition
	local Typename = getmetatable(self).__typename
	local Class = getmetatable(self).__class
	local NewInstance = getmetatable(self).__new
	--Tools.Error.CallerAssert(Definition.Copy, Typename .." Not copyable")
	--DebugOutput:Add(Format"Copying a %s"(type(self)))
	--DebugOutput:Push()
		--DebugOutput:Add(TotalCopies[type(self)] .." Total ".. type(self) .." copies created")
	
	--DebugOutput:Pop()
		--Class.TotalCopies[type(self)] = (Class.TotalCopies[type(self)] or 0) + 1
		--Class.TotalCopies._All_ = (Class.TotalCopies._All_ or 0) + 1
	return NewInstance(getmetatable(self), Definition.Copy(self))
end;

local __add = function(self, Additions) --Merge
	local Definition, Typename = getmetatable(self).__definition, getmetatable(self).__typename
	--Tools.Error.CallerAssert(Definition.Merge, Typename .." Not mergeable")
	
	if type(Additions) ~= "table" then
		Additions = {Additions}
	end

	local Into = -self
	--for _, Addition in pairs(Additions) do
	for Index = 1, #Additions do
		local Addition = Additions[Index]	
		--DebugOutput:Add(
		--	("Merging %s(%s) <- %s(%s)"):format(type(Into), Into, type(From), From)
		--)
		--Tools.Error.CallerAssert(type(self) == type(Addition), Tools.String.Format"Cant merge %s with %s"(type(self), type(Addition)))
		Definition.Merge(Into, Addition)
	end

	return Into
end;

local __mod = function(_, TypeQuery) --Typename lookup
	local TypeParts = getmetatable(_).__typeparts
	local QueryParts = Tools.String.Explode(TypeQuery, ".")
	local RootType = QueryParts[1]
	local SubTypes = Tools.Array.Slice(QueryParts,2)
	local RootIndex = TypeParts[RootType]

	if not RootIndex then
		return false
	end
	
	--for SubIndex, SubType in pairs(SubTypes) do
	for SubIndex = 1, #SubTypes do local SubType = SubTypes[SubIndex]
		if TypeParts[RootIndex + SubIndex] ~= SubType then
			return false
		end
	end
	
	return true
end;

local __div = function(self, Type) -- /"Type" Iteratively decomposes until it's of Type
	local Decomposed = self
	local function GetType()
		if type(Decomposed) == "Sisyphus.Compiler.Object" then
			local Meta = getmetatable(Decomposed)
			return Meta.__typename
		else
			return type(Decomposed)
		end
	end
	while(GetType() ~= Type) do
		Decomposed = Tools.Error.NotMine(Decomposed)
	end
	return Decomposed
end;

local __tostring = function(self)
	local Definition = getmetatable(self).__definition
	if Definition.ToString then
		return Definition.ToString(self)
	else
		return type(self)
	end
end;

local function NewInstance(self, ...)
	local Data = {}
	self.__definition.Construct(Data, ...)
	local Instance = setmetatable(Data, self)
	return Instance
end
return setmetatable(
	{
		TotalCopies = {}
	},{
		__call = function(Class, Typename, Definition)
			local TypeParts = {}

			for Index, SubType in pairs(Tools.String.Explode(Typename, ".")) do
				TypeParts[SubType] = Index
				TypeParts[Index] = SubType
			end
			
			local MT = {
				__type = "Sisyphus.Compiler.Object";
				__typename = Typename;
				__typeparts = TypeParts;
				__definition = Definition;
				__class = Class;
				__new = NewInstance;
				__call = __call;
				__unm = __unm;
				__add = __add;
				__mod = __mod;
				__div = __div;
				__tostring = __tostring;
				__index = function(t,k) if (Definition.DumpIndex) then Definition.DumpIndex(t,k) end return Definition[k] end;
			}
			return function(...)
				return MT:__new(...)
			end
		end
	}
)
