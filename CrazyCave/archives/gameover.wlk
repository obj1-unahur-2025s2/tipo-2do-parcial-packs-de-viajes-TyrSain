import wollok.game.*
import menu.*
import core.*
import map.*

class GameOverVisual {
    var property position
    var property image
}

object gameOver {
    var property visual = null
    var property isActive = false
    
    const gameOverImage = "GameOver.png"

    method show() {
        if (isActive) return self

        gameMenu.hide()

        visual = new GameOverVisual(
        position = game.at(0, 0),
        image = gameOverImage
        )

        game.addVisual(visual)
        isActive = true
        self.enableControls()

        return self
    }

    method hide() {
        if (not isActive) return self

        game.removeVisual(visual)
        isActive = false

        return self
    }

    method enableControls() {
        keyboard.r().onPressDo({
            if (self.isActive()) {
                self.restartGame()
            }
        })
    

        keyboard.q().onPressDo({
            if (self.isActive()) {
                self.backToMenu()
            }
        })
    }

    method restartGame() {
        self.hide()
        map.resetLevel()
    }

    method backToMenu() {
        self.hide()
        map.resetLevel()
        gameMenu.show()
    }
}