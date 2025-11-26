import entitys.*

// Es la entidad del personaje (player)
// Se invoca como player.entity()
object player {
	var property entity = new Miner(life = 6)
	
	method position(position){
		entity.position(position)
	}
	
	method show(){
		entity.show()
	}
}
