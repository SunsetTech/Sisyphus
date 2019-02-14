local Import = require"Toolbox.Import"

local Vlpeg = require"Sisyphus.Vlpeg"

return {
	Whitespace = Vlpeg.Pattern"\r\n" + Vlpeg.Pattern"\n" + Vlpeg.Set" \t";

};
