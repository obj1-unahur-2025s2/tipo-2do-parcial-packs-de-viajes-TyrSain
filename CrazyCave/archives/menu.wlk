import wollok.game.*
import core.*
import guide.*

class MenuBkg {
    var property position
    var property image
}

object gameMenu {
    var property visual = null
    var property isActive = false
    var property controlsRegistered = false

    method show() {
        if (isActive) {
            return self
        }

        visual = new MenuBkg(
            position = game.at(0, 0),
            image = "Title.png"
        )

        game.addVisual(visual)
        isActive = true

        if (not self.controlsRegistered()) {
            self.registerControls()
        }

        return self
    }

    method hide() {
        if (not isActive) {
            return false
        }

        game.removeVisual(visual)
        isActive = false

        return true
    }

    method registerControls() {
        keyboard.enter().onPressDo({
            if (self.isActive()) {
                self.startGame()
            } 
        })

        keyboard.g().onPressDo({
            if (self.isActive()) {
                self.showGuide()
            }
        })

        controlsRegistered = true
    }

    method startGame() {
        gameGuide.isActive(true)
        gameGuide.hide()
        self.hide()
        core.run()
    }

    method showGuide() {
        self.hide()
        gameGuide.show()
    }
}