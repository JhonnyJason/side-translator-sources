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
    
    return



############################################################
findRelevantFiles = (path) ->
    log "findRelevantFiles"
    allEntries = fs.readdirSync(path)
    allRelevant = []
    for entry in allEntries 
        entryAbsolute = path.resolve(path, entry)
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
        stat = fs.statSync(filepath)
        return stat.isFile()
    catch err
        ## probably does not exist
        return false

isFile = (path) ->
    try
        stat = fs.statSync(filepath)
        return stat.isDirectory()
    catch err
        ## probably does not exist
        return false
