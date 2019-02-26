local Tools = require"Toolbox.Tools"
local DebugOutput = require"Toolbox.Debug.Registry".GetDefaultPipe()

local Format = function(String)
	return function(...)
		return String:format(...)
	end
end

local rawtype = type
local type = Tools.Type.GetType

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
			
			local MakeObject
			local function NewInstance(...)
				--DebugOutput:Add("Constructing a ".. Typename)
				--DebugOutput:Push()

					local Data = {}
						(Definition.Construct or function() end)(Data, ...)
					local New = MakeObject(Data)
			
				--DebugOutput:Pop()
			
				return New
			end
			
			MakeObject = function(Data)
				return setmetatable(
					Data,
					{
						__type = Typename;
						
						__call = function(self, ...) --Decompose
							--DebugOutput:Format"Decomposing a %s"(type(self))
							--DebugOutput:Push()

							local Decomposed = Definition.Decompose(self, ...)
							
							if getmetatable(Decomposed) then
								getmetatable(Decomposed).__source = self; --TODO preserve during copy
							end
							
							--DebugOutput:Pop()
							--DebugOutput:Format"Decomposed a %s into a %s"(type(self), type(Decomposed))
							
							return Decomposed
						end;
						
						__unm = function(self) --Copy
							Tools.Error.CallerAssert(Definition.Copy, Typename .." Not copyable")
							--DebugOutput:Add(Format"Copying a %s"(type(self)))
							--DebugOutput:Push()
								--DebugOutput:Add(TotalCopies[type(self)] .." Total ".. type(self) .." copies created")
							
							--DebugOutput:Pop()
								Class.TotalCopies[type(self)] = (Class.TotalCopies[type(self)] or 0) + 1
								Class.TotalCopies._All_ = (Class.TotalCopies._All_ or 0) + 1
							return NewInstance(Definition.Copy(self))
							--[[local Copied = false
							local Current = self
							local function ResolveCopy()
								Current = NewInstance(Definition.Copy(self))
								Copied = true
							end
							return setmetatable(
								{}, {
									__type = function(_)
										--if not Copied then ResolveCopy() end
										return type(Current)
									end;
									__index = function(_, Key)
										if not Copied then ResolveCopy() end
										return Current[Key]
									end;
									__newindex = function(_, Key, Value)
										if not Copied then ResolveCopy() end
										Current[Key] = Value
									end;
									__call = function(_,...)
										if not Copied then ResolveCopy() end
										return Current(...)
									end;
									__unm = function(_)
										if Copied then
											return -Current
										else
											return _
										end
									end;
									__add = function(_, Additions)
										return Current + Additions
									end;
									__mod = function(_, TypeQuery)
										--if not Copied then ResolveCopy() end
										return Current%TypeQuery
									end;
									__div = function(_, Type)
										--if not Copied then ResolveCopy() end
										return Current/Type
									end;
								}
							)]]
						end;
						
						__add = function(self, Additions) --Merge
							Tools.Error.CallerAssert(Definition.Merge, Typename .." Not mergeable")
							
							if type(Additions) ~= "table" then
								Additions = {Additions}
							end

							local Into = -self
							for _, Addition in pairs(Additions) do
								--DebugOutput:Add(
								--	("Merging %s(%s) <- %s(%s)"):format(type(Into), Into, type(From), From)
								--)
								Tools.Error.CallerAssert(type(self) == type(Addition), Tools.String.Format"Cant merge %s with %s"(type(self), type(Addition)))
								Definition.Merge(Into, Addition)
							end

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
	}
)
