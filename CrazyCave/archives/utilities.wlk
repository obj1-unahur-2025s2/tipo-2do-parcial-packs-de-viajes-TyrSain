import wollok.game.*
import entitys.*

// Estas utilidades siven para adicionar validaciones a las funciones
object utilities {
	// Si es objeto que es obstaculo
	method isFreePosition(position) {
		const objectsInPosition = game.getObjectsIn(position)
		
		const isFree = objectsInPosition.any({ o => o.isObstacle() })

		return not isFree
	}
	
	// Si hay objeto en la posicion, obstaculo o no
	method isFreePositionStrict(position) {
		const objectsInPosition = self.objectInPosition(position)
		
		return objectsInPosition == null
	}
	
	method isMoveValid(newPosition) {
	    return self.notOutOfBorders(newPosition) and self.isFreePosition(newPosition)
	}
	
	method isMoveValidStrict(newPosition) {
	    return self.notOutOfBorders(newPosition) and self.isFreePositionStrict(newPosition)
	}
	
	// Obtener objeto individual
	method objectInPosition(position) {
		if (game.getObjectsIn(position) == []) {
			return null 
		}
		else {
			return game.getObjectsIn(position).get(0)
		
		}
	}
	
	// Verifica si la posición está dentro de los límites del tablero
	method notOutOfBorders(newPosition) {
	    return newPosition.x() >= 1 and newPosition.x() < game.width() - 1  and 
	           newPosition.y() >= 1 and newPosition.y() < game.height() - 2 
	}
}
