import wollok.game.*
import entitys.*
import utilities.*

// Son los las funciones para crear obstaculos en el mapa
object obstacles {
	var property obstacles = []
	
	method createRocks(minRocks, maxRocks){
		var numberOfRocks = 0

		if (minRocks > maxRocks){
			numberOfRocks = maxRocks.randomUpTo(minRocks+1).truncate(0)
		}
		else{
			numberOfRocks = minRocks.randomUpTo(maxRocks+1).truncate(0)
		}
		
		new Range(start = 0, end = numberOfRocks).forEach({i => obstacles.add(new Rock(life = 20))})
	}
	
	method createGeodes(minGeodes, maxGeodes){
		var numberOfGeodes = 0

        if (minGeodes > maxGeodes) {
            numberOfGeodes = maxGeodes.randomUpTo(minGeodes+1).truncate(0)
        }
        else{
            numberOfGeodes = minGeodes.randomUpTo(maxGeodes+1).truncate(0)
        }

		//probabilidad de aparicion de geodas segun rareza
        new Range(start = 0, end = numberOfGeodes).forEach({i => 
            const geodeNumber = 0.randomUpTo(11).truncate(0)

            if (geodeNumber.between(0, 4)) {
                obstacles.add(new Gblue(life = 3))
                
            } else if (geodeNumber.between(5, 7)) {
                obstacles.add(new Ggreen(life = 6))
                
            } else if (geodeNumber.between(8, 9)) {
                obstacles.add(new Gpurple(life = 12))
                
            } else {
                obstacles.add(new Gorange(life = 20))
            }
        })

    }
	
	method createChests(minChests, maxChests){
		var numberOfChests = 0

		if (minChests > maxChests){
			numberOfChests = maxChests.randomUpTo(minChests+1).truncate(0)
		}
		else{
			numberOfChests = minChests.randomUpTo(maxChests+1).truncate(0)
		}
			
		new Range(start = 0, end = numberOfChests).forEach({i => obstacles.add(new Chest(life = 1))})
	}
	
	method showObstacles(){
		obstacles.forEach({ obstacle => self.placeRecursively(obstacle, 0) })
		
	}
	
	method placeRecursively(obstacle, intent) {
		//para limitar la cantidad de intentos de colocacion y evitar loops infinitos
		if (intent > 2){}
		const limitX = game.width() - 1
		const limitY = game.height() - 2
		
		const position = game.at(
		    1.randomUpTo(limitX).truncate(0),
		    1.randomUpTo(limitY).truncate(0)
		)	
		
		//se utiliza la posicion estricta, para contabilizar no solamente los obstaculos, sino tambien el minero y el golem
		if (utilities.isFreePositionStrict(position)) {
			obstacle.position(position)
			obstacle.show()
			obstacles.remove(obstacle)
		} else {
			self.placeRecursively(obstacle, intent + 1)
		}
	}
	
	
}