##############################################################################
#region debug
import {createLogFunctions} from "thingy-debug"
{log, olog} = createLogFunctions("startupmodule")

#endregion

##############################################################################
#region imports
import c from 'chalk'

##############################################################################
import * as main from "./mainprocessmodule.js"
import * as argsModule from "./cliargumentsmodule.js"

#endregion

##############################################################################
#region internal variables
errLog = (arg) -> console.log(c.red(arg))
successLog = (arg) -> console.log(c.green(arg))

#endregion

##############################################################################
export cliStartup = ->
    log "cliStartup"
    try
        e = argsModule.extractArguments()
        await main.execute(e)
        successLog('All done!');
    catch err
        errLog("Error!")
        errLog(err)
        if err.stack then errLog(err.stack)
        process.exit(-1)