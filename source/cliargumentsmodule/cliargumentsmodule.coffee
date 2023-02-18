##############################################################################
#region debug
import {createLogFunctions} from "thingy-debug"
{log, olog} = createLogFunctions("cliargumentsmodule")

#endregion

##############################################################
import meow from 'meow'

##############################################################
#region internal functions
getHelpText = ->
    log "getHelpText"
    return """
        Usage
            $ side-translator <arg1> <arg2>
    
        Options
            optional:
                arg1, --input <input-file-path>, -i <input-file-path>
                    path to file to be translated by default we take .
                arg2, --output <output-file-path>, -o <output-file-path>
                    path of where the translation is file to be written
                    default is .
        Examples
            $ side-translator 
            $ side-translator side-export.spec.js
            $ side-translator test-specs/ test-scripts/
            $ side-translator side-export.spec.js test-script.js 
            ...
    """

getOptions = ->
    log "getOptions"
    return {
        importMeta: import.meta,
        flags:
            input: 
                type: "string"
                alias: "i"
            output: 
                type: "string"
                alias: "o"
    }

##############################################################
extractMeowed = (meowed) ->
    log "extractMeowed"

    input = "."
    output = "."

    if meowed.input[0] then input = meowed.input[0]
    if meowed.input[1] then output = meowed.input[1]

    if meowed.flags.input then input = meowed.flags.input
    if meowed.flags.output then output = meowed.flags.output

    return {input, output}

#endregion

##############################################################
export extractArguments = ->
    log "extractArguments"
    meowed = meow(getHelpText(), getOptions())
    extract = extractMeowed(meowed)
    return extract
