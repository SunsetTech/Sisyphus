local Tools = require"Toolbox.Tools"
local DebugOutput = require"Toolbox.Debug.Registry".GetDefaultPipe()

local Format = function(String)
	return function(...)
		return String:format(...)
	end
end

local rawtype = type
local type = Tools.Type.GetType

local TotalCopyOperations = 0
return function(Typename, Definition)
	local TypeParts = {}

	for Index, SubType in pairs(Tools.String.Explode(Typename, ".")) do
		TypeParts[SubType] = Index
		TypeParts[Index] = SubType
	end
	
	local MakeObject
	local function NewInstance(...)
		DebugOutput:Add("Constructing a ".. Typename)
		DebugOutput:Push()

			local Data = {}
				(Definition.Construct or function() end)(Data, ...)
			local New = MakeObject(Data)
	
		DebugOutput:Pop()
	
		return New
	end
	
	MakeObject = function(Data)
		return setmetatable(
			Data,
			{
				__type = Typename;
				
				__call = function(self, ...) --Decompose
					DebugOutput:Format"Decomposing a %s"(type(self))
					DebugOutput:Push()

					local Decomposed = Definition.Decompose(self, ...)
					
					if getmetatable(Decomposed) then
						getmetatable(Decomposed).__source = self; --TODO preserve during copy
					end
					
					DebugOutput:Pop()
					DebugOutput:Format"Decomposed a %s into a %s"(type(self), type(Decomposed))
					
					return Decomposed
				end;
				
				__unm = function(self) --Copy
					Tools.Error.CallerAssert(Definition.Copy, Typename .." Not copyable")
					DebugOutput:Add(Format"Copying a %s"(type(self)))
					DebugOutput:Push()
						TotalCopyOperations = TotalCopyOperations + 1
						DebugOutput:Add(TotalCopyOperations .." Total Compiler.Object copies created")
					
						local New = NewInstance(
							Definition.Copy(self)
						)
					DebugOutput:Pop()

					return New
				end;
				
				__add = function(self, From) --Merge
					Tools.Error.CallerAssert(Definition.Merge, Typename .." Not mergeable")
					Tools.Error.CallerAssert(type(self) == type(From), Tools.String.Format"Cant merge %s with %s"(self, From))

					local Into = -self
						DebugOutput:Add(
							("Merging %s(%s) <- %s(%s)"):format(type(Into), Into, type(From), From)
						)
					
						Definition.Merge(Into, From)
					return Into
				end;
				
				__mod = function(_, TypeQuery) --Typename lookup
					local QueryParts = Tools.String.Explode(TypeQuery, ".")
					local RootType = QueryParts[1]
					local SubTypes = Tools.Array.Slice(QueryParts,2)
					local RootIndex = TypeParts[RootType]

					if not RootIndex then
						return false
					end
					
					for SubIndex, SubType in pairs(SubTypes) do
						if TypeParts[RootIndex + SubIndex] ~= SubType then
							return false
						end
					end
					
					return true
				end;
				
				__div = function(self, Type) -- /"Type" Iteratively decomposes until it's of Type
					local Decomposed = self
					while(type(Decomposed) ~= Type) do
						Decomposed = Decomposed()
					end
					return Decomposed
				end;

				__tostring = function(self)
					if Definition.ToString then
						return Definition.ToString(self)
					else
						return type(self)
					end
				end;
			}
		)
	end
	return NewInstance
end

