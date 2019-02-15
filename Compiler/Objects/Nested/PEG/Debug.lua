local DebugOutput = require"Toolbox.Debug.Registry".GetDefaultPipe()

local Tools = require"Toolbox.Tools"

local Import = require"Toolbox.Import"

local Vlpeg = Import.Module.Relative"Vlpeg"

local Object = Import.Module.Relative"Object"

return Object(
	"Nested.PEG.Capture", {
		Construct = function(self, SubPattern)
			self.SubPattern = SubPattern
		end;
		
		Decompose = function(self, Canonical)
			return Vlpeg.Select(
				Vlpeg.Sequence(
					Vlpeg.Immediate(
						Vlpeg.Pattern(0),
						function(Subject, Pos)
							DebugOutput:Format"trying to match %s"(self.SubPattern)
							DebugOutput:Format"At [[%s]]"(Subject:sub(Pos))
							DebugOutput:Push()
							return Pos
						end
					),
					self.SubPattern(Canonical),
					Vlpeg.Immediate(
						Vlpeg.Pattern(0),
						function(_,Pos)
							DebugOutput:Pop()
							DebugOutput:Add"Success"
							return Pos
						end
					)
				),
				Vlpeg.Immediate(
					Vlpeg.Pattern(0),
					function()
						DebugOutput:Pop()
						DebugOutput:Add"Failed"
						return false
					end
				) * (Vlpeg.Pattern(1) - Vlpeg.Pattern(1))
			)
		end;
		
		Copy = function(self)
			return -self.SubPattern
		end;

		ToString = function(self)
			return "`".. self.SubPattern
		end;
	}
)
