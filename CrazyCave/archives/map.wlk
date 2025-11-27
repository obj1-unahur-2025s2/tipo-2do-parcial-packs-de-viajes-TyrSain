import archives.inventory.*
import wollok.game.*
import entitys.*
import player.*
import enemy.*
import obstacles.*
import hud.*
import keys.*

// Cuando el mapa es creado, genera las entidades (con sus dunciones) y sus respectivas visuales
object map {

    method start(){
        player.entity(new Miner(life = 6))
        player.position(game.at(15, 10))
        enemy.addEnemy()
        player.show()

        // Agrega el HUD con la vida y los puntos
        hudDraw.start()

        // Genera los obtaculos del mapa de forma aleatoria
        obstacles.createRocks(50, 70)
        obstacles.createGeodes(5, 7)
        obstacles.createChests(1, 2)
        obstacles.showObstacles()

        // La "IA" que hace que el Golem se mueva por tiempos
        game.onTick(1000, "golem_ai", {enemy.addedEnemy().moveTowardsPlayer()})

        // Efectua el daño al personaje si colisioina con el golem
        game.onCollideDo(player.entity(), {enemy => enemy.damageToPlayer()})


        // Cada 15 segundos, crea nuevos obstaculos en el mapa
        game.onTick(15000, "create_geodes", {
            obstacles.createGeodes(0, 3)
            obstacles.showObstacles()
        })

        // Cada 20 segundos, crea un nuevo cofre en el mapa
        game.onTick(40000, "create_chests", {
            obstacles.createChests(0, 0)
            obstacles.showObstacles()
        })
    }

    method clearLevel(){
		score.score(0)
        game.clear()
        inventory.clearInventory()
    }

    method resetLevel(){
        self.start()
        keys.setKeys()
    }

}