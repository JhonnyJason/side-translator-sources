##############################################################################
#region debug
import {createLogFunctions} from "thingy-debug"
{log, olog} = createLogFunctions("pathhandlermodule")

#endregion

############################################################
import * as pathModule from "path"
import fs from "fs" 

############################################################
sources = null
outputs = null

############################################################
sourceFileEnding = ".spec.js"

############################################################
export digestInputArgument = (input) ->
    log "digestInputArgument"
    if pathModule.isAbsolute(input) then inputAbsolute = input
    else inputAbsolute = pathModule.resolve(process.cwd(), input)

    if !fs.existsSync(inputAbsolute) then throw new Error("Specified input path does not exist! (#{inputAbsolute})")

    if isDirectory(inputAbsolute) then sources = findRelevantFiles(inputAbsolute)
    else sources = [inputAbsolute]

    olog { sources }
    return
    
############################################################
export digestOutputArgument = (output) ->
    log "digestOutputArgument"
    if pathModule.isAbsolute(output) then outputAbsolute = output
    else outputAbsolute = pathModule.resolve(process.cwd(), output)
    
    if isDirectory(outputAbsolute)
        outputs = mapSourcesToOutputDirectory(outputAbsolute)
    else if sources.length != 1
        throw new Error("Single output file specified - but source is not 1 file!")
    else 
        outputs = [ sourceToOutputPath(sources[0], outputAbsolute) ]
    
    olog { outputs }
    return

export getInputOutputPairs = ->
    log "getInputOutputPairs"
    result = []
    for source,i in sources
        input = source
        output = outputs[i]
        pair = { input, output }
        result.push(pair)
    return result

############################################################
#region internal functions

mapSourcesToOutputDirectory = (outputDirectoryAbsolute) ->
    result = []
    for sourceAbsolute in sources
        result.push(sourceToOutputPath(sourceAbsolute, outputDirectoryAbsolute))
    return result

sourceToOutputPath = (sourceAbsolute, outputDirectoryAbsolute) ->
    log "defaultOutputForSource"
    name = pathModule.basename(sourceAbsolute)
    if name.endsWith(sourceFileEnding) 
        name = name.replace(sourceFileEnding, ".js")
    return pathModule.resolve(outputDirectoryAbsolute, name)

############################################################
findRelevantFiles = (path) ->
    log "findRelevantFiles"
    allEntries = fs.readdirSync(path)
    allRelevant = []
    for entry in allEntries 
        entryAbsolute = pathModule.resolve(path, entry)
        if isRelevantFile(entryAbsolute) then allRelevant.push(entryAbsolute)
    return allRelevant

isRelevantFile = (path) ->
    log "isRelevantFile"
    return false unless isFile(path)
    return false unless path.endsWith(sourceFileEnding)
    return true

############################################################
isDirectory = (path) ->
    try
        stat = fs.statSync(path)
        return stat.isDirectory()
    catch err
        ## probably does not exist
        return false

isFile = (path) ->
    try
        stat = fs.statSync(path)
        return stat.isFile()
    catch err
        ## probably does not exist
        return false

#endregion