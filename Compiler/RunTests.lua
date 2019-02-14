local Import = require"Toolbox.Import"
Import.Install.All()

require"Toolbox.Debug.Registry".GetDefaultPipe().IncludeSource=false

require"Tests"()
