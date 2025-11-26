
import entitys.*
import wollok.game.*


// Desde donde se instancian los enemigos posibles del juego, de momento solo hay 1
object enemy {
	var property addedEnemies = []
	
	method deleteEnemies(){
		addedEnemies = []
	} 
	
	method addEnemy(){
		const enemy = new Golem()
		enemy.position(game.at(7, 5))
		addedEnemies.add(enemy)
	}
	
	method showEnemies(){
		addedEnemies.forEach({e => e.show()})
	}
}
