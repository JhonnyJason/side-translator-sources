##############################################################################
#region debug
import {createLogFunctions} from "thingy-debug"
{log, olog} = createLogFunctions("mainprocessmodule")

#endregion

##############################################################################
import * as cfg from "./configmodule.js"
import * as pathHandler from "./pathhandlermodule.js"
import * as translator from "./translationmodule.js"

##############################################################################
export execute = (e) ->
    log "execute"
    pathHandler.digestInputArgument(e.input)
    pathHandler.digestOutputArgument(e.output)

    translator.translateAllFiles()

    return
