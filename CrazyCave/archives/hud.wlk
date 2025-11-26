import wollok.game.*
import player.*
import entitys.*

// La clase para los corazones
class HeartVisual {
	var property position
	var property image

	method isObstacle() = false
}

// La clase para los digitos del score
class DigitVisual {
    var property position
    var property image

	method isObstacle() = false
}

// Seria la raiz del hud, el que se debe ejecutar para que aparezca en el juego
object hudDraw {
	
	method updateHearts() {
		hearts.drawHearts()
	}
	
	method updateScore() {
		score.drawScore()
	}
	
	method start() {
		hearts.drawHearts()
		score.drawScore()
	}
	
}

// Es el que al imcrementar los puntos, el marcador creado por assets aumenta
object score {
    var property score = 0
    const maxDigits = 4
    const space = 1

    const startY = 15
    const offset = 0

    const scoreVisuals = []

    method drawScore() {
        scoreVisuals.forEach({v => game.removeVisual(v)})
        scoreVisuals.clear()

        const scoreToDisplay = 9999.min(0.max(score)) 
        var scoreString = scoreToDisplay.toString()

        const digits = maxDigits - scoreString.size()

        if (digits == 3) {
            scoreString = "000" + scoreString
        } else if (digits == 2) {
            scoreString = "00" + scoreString
        } else if (digits == 1) {
            scoreString = "0" + scoreString
        } 

        const scoreList = scoreString.split("")

        new Range(start = 0, end = scoreList.size() - 1).forEach({ index => 
            const digit = scoreList.get(index)

            const startInX = 22 - maxDigits
            const digitX = startInX + (index * space) + offset

            const imagePath = digit.toString() + ".png"

            const digitVisual = new DigitVisual(
                position = game.at(digitX, startY),
                image = imagePath
            )

            game.addVisual(digitVisual)
            scoreVisuals.add(digitVisual)
        })
    }

    method increaseScore(points) {
        score +=  points
        self.drawScore()
    }

    method decreaseScore(points){
        score = 0.max(score - points)
        self.drawScore()
    }
}

// Es el que crea los corazones, y cuando recive daño, la vida baja y los corazones disminuyen segun el daño recivido
object hearts {
	const heartFull = "Heart.png"
	const heartHalf = "HalfHeart.png"
	const heartEmpty = "EmptyHeart.png"
	
	const heartVisual = []
	
	const startY = 15
	
	method drawSingleHeart(image, index) {
		const heartsVisual = new HeartVisual(
			position = game.at(index, startY),
			image = image
		)
		game.addVisual(heartsVisual)
		heartVisual.add(heartsVisual)
	}
	
	method drawHearts() {
		if (player.entity() == null) {}

		heartVisual.forEach({heart => game.removeVisual(heart)})
		heartVisual.clear()
		
		var lifePoints = player.entity().life()
		var imageToUse = null
		
		imageToUse = heartEmpty
		if (lifePoints >= 2) {
			imageToUse = heartFull
			lifePoints = lifePoints - 2
		} else if (lifePoints == 1) {
			imageToUse = heartHalf
			lifePoints = lifePoints - 1
		}
		self.drawSingleHeart(imageToUse, 1)
		
		imageToUse = heartEmpty
		if (lifePoints >= 2) {
			imageToUse = heartFull
			lifePoints = lifePoints - 2
		} else if (lifePoints == 1) {
			imageToUse = heartHalf
			lifePoints = lifePoints - 1
		}
		self.drawSingleHeart(imageToUse, 2)

		imageToUse = heartEmpty
		if (lifePoints >= 2) {
			imageToUse = heartFull
			lifePoints = lifePoints - 2
		} else if (lifePoints == 1) {
			imageToUse = heartHalf
			lifePoints = lifePoints - 1
		}
		self.drawSingleHeart(imageToUse, 3)
		
		}
}