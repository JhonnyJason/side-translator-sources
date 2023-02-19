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
tit = "it('" ## test identifying token
tne = "', " ## test name end
ait = "await driver." ## action identifying token


############################################################
outputTemplate = '''
    export const testName = '{{{testName}}}';

    export async function run (browserUtils, resultUtils) {
        
        const { browser, By, Key } = browserUtils
        const { chai, transitionTime, takeScreenshot } = resultUtils

        await browser.get("{{{testURL}}}")
        await transitionTime()
        await takeScreenshot(0)

        //load assertions?

        {{#testSteps}}
        {{{stepAction}}}
        await transitionTime()
        await takeScreenshot({{stepNumber}})
        //step{{stepNumber}} assertions?
        {{/testSteps}}

    };
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
    ## We assume only one it("testName", async function(){...}) exists

    tests = original.split(tit)
    if tests.length <= 1 then throw new Error("No it(' found in script!") 
    if tests.length > 2 then throw new Error("Unexpectedly many it(' found in script!")

    testLinesReversed = tests[1].split("\n").reverse()
    olog testLinesReversed
    
    line = testLinesReversed.pop()
    olog testLinesReversed

    testName = extractTestName(line)
    ## TODO figure out how we get the testURL...
    testURL = "https://secrets-cockpit.extensivlyon.coffee"
    testSteps = []

    num = 1
    loop
        line = testLinesReversed.pop()
        if typeof line != "string" then break

        stepAction = extractStepAction(line)
        if !stepAction? then continue
        stepNumber = num++
        testSteps.push({stepNumber, stepAction})

    cObj = { testName, testURL, testSteps }
    olog cObj

    ## render the template
    translated = M.render(outputTemplate, cObj)
    return translated


############################################################
extractTestName = (line) ->
    log "extractTestName"
    # log line
    # offset = line.indexOf(tit) if offset < 0 then throw new Error("No #{tit} found in the assumed headline!")
    # line = line.slice(offset + tit.length)
    log line
    end = line.indexOf(tne)
    if end < 0 then throw new Error("No #{tne} found in the assumed headline!")
    return line.slice(0, end)

extractStepAction = (line) ->
    log "extractStepAction"
    log line
    if line.indexOf(ait) < 0 then return null
    return line.trim()
