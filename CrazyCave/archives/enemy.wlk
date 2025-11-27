import entitys.*
import wollok.game.*


// Desde donde se instancian los enemigos posibles del juego, de momento solo hay 1
object enemy {
    var property addedEnemy = null

    method addEnemy(){
        const x = 1.randomUpTo(game.width() -2).truncate(0)
        const y = 1.randomUpTo(game.height() -3).truncate(0)

        const aEnemy = new Golem()
        aEnemy.position(game.at(x, y))
        addedEnemy = aEnemy

        addedEnemy.show()
    }
}