{CompositeDisposable} = require 'atom'
FocusModeBase = require './focus-mode-base'

class FocusMode extends FocusModeBase

    constructor: ->
        super("FocusMode")
        @isActivated = false
        @focusModeMarkersCache = {}
        # The @focusModeLineOpacityCssClass currently applied to the body tag
        @appliedFocusModeLineOpacityCssClass = ""
        @focusModeLineOpacityCssClass = @getFocusLineCssClass(
            @getConfig('atom-focus-mode.focusModeLineOpacity')
        )
        @configSubscriptions = @registerConfigSubscriptions()


    getFocusLineCssClass: (opacity) =>
        if opacity is "55%" then return "line-55" else "line-100"


    registerConfigSubscriptions: =>
        configSubscriptions = new CompositeDisposable()
        configSubscriptions.add(atom.config.observe(
            'atom-focus-mode.focusModeLineOpacity',
            (opacityConfigValue) =>
                @focusModeLineOpacityCssClass = @getFocusLineCssClass(opacityConfigValue)
        ))

        return configSubscriptions

    on: =>
        @isActivated = true
        bodyTag = @getBodyTagElement()
        @addCssClass(bodyTag, @focusModeBodyCssClass)
        @addCssClass(bodyTag, @focusModeLineOpacityCssClass)
        @appliedFocusModeLineOpacityCssClass = @focusModeLineOpacityCssClass
        @applyFocusModeToSelectedBufferRanges()


    off: =>
        @isActivated = false
        bodyTag = @getBodyTagElement()
        @removeCssClass(bodyTag, @focusModeBodyCssClass)
        @removeCssClass(bodyTag, @appliedFocusModeLineOpacityCssClass)
        @removeFocusLineClass()
        @focusModeMarkersCache = {}


    focusLine: (cursor) =>
        bufferRow = cursor.getBufferRow()
        textEditor = @getActiveTextEditor()

        return if @bufferRowIsAlreadyFocussed(textEditor.id, bufferRow)

        @addFocusLineMarker(textEditor, bufferRow)


    bufferRowIsAlreadyFocussed: (editorId, bufferRowNumber) =>
        focusMarkers = @focusModeMarkersCache[editorId] or []
        for marker in focusMarkers
            range = marker.getBufferRange()
            rowNumber = range.getRows()

            if rowNumber[0] is bufferRowNumber
                return true

        return false


    addFocusLineMarker: (textEditor, bufferRow) =>
        range = [[bufferRow, 0], [bufferRow, 0]]
        marker = textEditor.markBufferRange(range)
        textEditor.decorateMarker(marker, type: 'line', class: @focusLineCssClass)
        @cacheFocusModeMarker(textEditor.id, marker)


    cacheFocusModeMarker: (editorId, marker) =>
        if @focusModeMarkersCache[editorId]
            @focusModeMarkersCache[editorId].push(marker)
        else
            @focusModeMarkersCache[editorId] = [marker]


    applyFocusModeToSelectedBufferRanges: =>
        for textEditor in @getAtomWorkspaceTextEditors()
            if textEditor
                selectedRanges = textEditor.getSelectedBufferRanges()
                if selectedRanges and selectedRanges.length > 0
                    for range in selectedRanges
                        marker = textEditor.markBufferRange(range)
                        textEditor.decorateMarker(marker, type: 'line', class: @focusLineCssClass)
                        @cacheFocusModeMarker(textEditor.id, marker)


    dispose: =>
        @configSubscriptions.dispose() if @configSubscriptions


module.exports = FocusMode
