import wollok.game.*
import entitys.*
import map.*
import player.*
import inventory.*


// Son las funciones generales que vinculan las teclas al movimiento del jugador
object keys {

    method setKeys(){
        self.minerMovement()
    }


    method minerMovement(){
        keyboard.w().onPressDo({
            player.entity().moveUp()
        })

        keyboard.s().onPressDo({
            player.entity().moveDown()
        })

        keyboard.a().onPressDo({
            player.entity().moveLeft()
        })

        keyboard.d().onPressDo({
            player.entity().moveRight()
        })
        keyboard.space().onPressDo({
            player.entity().breakObstacleInTheDirection()
        })
        keyboard.e().onPressDo({
            if (inventory.bombs() == []){}
            else{
                inventory.bombs().get(0).use()
            }
        })
    }

}