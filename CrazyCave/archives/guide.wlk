import wollok.game.*
import menu.*

class GuideBkg {
    var property position
    var property image
}

object gameGuide {
    var property page = 1
    var property visual = null
    var property isActive = false

    const page1 = "Info1.png"
    const page2 = "Info2.png"

    method show() {
        if (isActive) {
            return self
        }

        isActive = true
        self.actualPage()
        self.enableControls()

        return self
    }

    method hide() {
        if (not isActive) {
            return self
        }

        game.removeVisual(visual)
        isActive = false

        return self
    }

    method actualPage() {
        if (visual != null) {
            game.removeVisual(visual)
        }

        const imageToUse = if (page == 1) page1 else page2

        visual = new GuideBkg(
            position = game.at(0, 0),
            image = imageToUse
        )

        game.addVisual(visual)
    }

    method nextPage() {
        if (page == 1) {
            page = 2
        } else {
            page == 1
        }

        self.actualPage()
    }

    method prevPage() {
        if (page == 2) {
            page = 1
        } else {
            page = 2
        }

        self.actualPage()
    }

    method enableControls() {
        keyboard.num2().onPressDo({
            if (self.isActive()) {
                self.nextPage()
            }
        })

        keyboard.num1().onPressDo({
            if (self.isActive()) {
                self.prevPage()
            }
        })

        keyboard.g().onPressDo({
            if (self.isActive()) {
                isActive = false
                gameMenu.controlsRegistered(false) 
                gameMenu.show()
            }
        })

    }
}