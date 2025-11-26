import wollok.game.*
import entitys.*
import player.*
import enemy.*
import obstacles.*
import hud.*

// Cuando el mapa es creado, genera las entidades (con sus dunciones) y sus respectivas visuales
object map {
	
	method start(){
		player.position(game.at(3, 1))
		enemy.addEnemy()
		enemy.showEnemies()
		player.show()
		
		// Agrega el HUD con la vida y los puntos
		hudDraw.start()
		
		// Genera los obtaculos del mapa de forma aleatoria
		obstacles.createRocks(25, 50)
		obstacles.createGeodes(3, 5)
		obstacles.createChests(3, 3)
		obstacles.showObstacles()
		
		
		
    	// La "IA" que hace que el Golem se mueva por tiempos
		game.onTick(1000, "golem_ai", {enemy.addedEnemies().forEach({entity => entity.moveTowardsPlayer()})})
		
		// Efectua el daño al personaje si colisioina con el golem
		game.onCollideDo(player.entity(), {entity => entity.damageToPlayer()})
	}
}
