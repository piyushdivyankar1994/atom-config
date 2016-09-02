
focusModePackage = require '../lib/main'
FocusModeManager = require '../lib/focus-mode-manager'

describe "Main", ->

    describe "activate", ->

        it "should create and instance of the FocusModeManager class", ->
            focusModePackage.activate()

            expect(focusModePackage.focusModeManager).not.toBeNull()
            expect(focusModePackage.focusModeManager.constructor).toEqual(FocusModeManager)

        it "should add two focus mode keyboard commands to subscriptions", ->
            focusModePackage.activate()

            expect(focusModePackage.subscriptions).not.toBeNull()
            expect(focusModePackage.subscriptions.disposables.size).toEqual(3)


    describe "when the 'atom-focus-mode:toggle' event is triggered", ->

        it "should call focus mode method toggleFocusMode()", ->
            workspaceElement = atom.views.getView(atom.workspace)
            focusModePackage.activate()

            spyOn(focusModePackage.focusModeManager, "toggleFocusMode")

            atom.commands.dispatch workspaceElement, 'atom-focus-mode:toggle'

            expect(focusModePackage.focusModeManager.toggleFocusMode).toHaveBeenCalled()


    describe "when the 'atom-focus-mode:toggle-single-line' event is triggered", ->

        it "should call focus mode method toggleFocusModeSingleLine()", ->
            workspaceElement = atom.views.getView(atom.workspace)
            focusModePackage.activate()

            spyOn(focusModePackage.focusModeManager, "toggleFocusModeSingleLine")

            atom.commands.dispatch workspaceElement, 'atom-focus-mode:toggle-single-line'

            expect(focusModePackage.focusModeManager.toggleFocusModeSingleLine).toHaveBeenCalled()


    describe "when the 'atom-focus-mode:toggle-shadow-mode' event is triggered", ->

        it "should call focus mode method toggleFocusShadowMode()", ->
            workspaceElement = atom.views.getView(atom.workspace)
            focusModePackage.activate()

            spyOn(focusModePackage.focusModeManager, "toggleFocusShadowMode")

            atom.commands.dispatch workspaceElement, 'atom-focus-mode:toggle-shadow-mode'

            expect(focusModePackage.focusModeManager.toggleFocusShadowMode).toHaveBeenCalled()


    describe "deactivate", ->

        it "should dispose subscribers", ->
            focusModePackage.activate()

            spyOn(focusModePackage.subscriptions, "dispose")
            spyOn(focusModePackage.focusModeManager, "subscribersDispose")

            focusModePackage.deactivate()

            expect(focusModePackage.subscriptions.dispose).toHaveBeenCalled()
            expect(focusModePackage.focusModeManager.subscribersDispose).toHaveBeenCalled()
