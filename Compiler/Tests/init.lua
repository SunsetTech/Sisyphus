local DebugOutput = require"Toolbox.Debug.Registry".GetDefaultPipe()

local Module = require"Toolbox.Import.Module"

local Tests = {
	"Flat";
	"Nested";
	"Basic";
	"Aliasable";
	"Template";
}

for Index, Name in pairs(Tests) do
	Tests[Index] = {Name, Module.Child(Name)}
end

return function()
	DebugOutput:Add"Running tests"
	DebugOutput:Push()
	for _, Test in pairs(Tests) do
		DebugOutput:Format"Running test %s"(Test[1])
		DebugOutput:Push()
			Test[2]()
		DebugOutput:Pop()
		DebugOutput:Format"Test %s finished"(Test[1])
	end
	DebugOutput:Pop()
	DebugOutput:Add"All tests finished"
end
