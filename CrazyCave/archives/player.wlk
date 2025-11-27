import entitys.*

// Es la entidad del personaje (player)
// Se invoca como player.entity()
object player {
    var property entity = null

    method position(position){
        entity.position(position)
    }

    method show(){
        entity.show()
    }
}