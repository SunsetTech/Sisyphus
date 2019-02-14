local Module = require"Toolbox.Import.Module"

return {
	Immediate = Module.Child"Immediate";
	Sequence = Module.Child"Sequence";
	Variable = Module.Child"Variable";
	Position = Module.Child"Position";
	Pattern = Module.Child"Pattern";
	Dematch = Module.Child"Dematch";
	Capture = Module.Child"Capture";
	Select = Module.Child"Select";
	Range = Module.Child"Range";
	Apply = Module.Child"Apply";
	Group = Module.Child"Group";
	Debug = Module.Child"Debug";
	Table = Module.Child"Table";
	All = Module.Child"All";
}
