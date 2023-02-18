############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("translationmodule")
#endregion

############################################################
import fs from "fs"
import M from "mustache"

############################################################
import * as pathHandler from "./pathhandlermodule.js" 


############################################################
outputTemplate = '''

'''


############################################################
export translateAllFiles = ->
    log "translateAllFiles"
    allInputOutputPairs = pathHandler.getInputOutputPairs()
    for pair in allInputOutputPairs
        original = fs.readFileSync(pair.input, {encoding:'utf8'})
        outputFile = translate(original)
        fs.writeFileSync(pair.output, outputFile) 
    return

############################################################
translate = (original) ->
    log "translate"
    translated = "// Nothing translated!'"

    ## TODO get all lines from it("title")
    
    return translated
