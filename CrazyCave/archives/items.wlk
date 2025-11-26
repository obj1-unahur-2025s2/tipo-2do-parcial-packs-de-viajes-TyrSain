import wollok.game.*
import player.*
import utilities.*
import entitys.*
import inventory.*

// Es la clase madre pero de los items
class Item {
	var property position = game.at(0, 0)
	var property used = false
	
	method use(){
		
	}
	
	method onHitByExplosion(hp){}	
	
	method onHitByPickaxe(hp){}
	
	method isObstacle() = true

	method show() {
		game.addVisual(self)
	}
}

// La clase para las boombas con sus funciones
class Bomb inherits Item{
	const myTickName = "bomb_" + 0.randomUpTo(10000).toString()
	var state = 1
	
	method image(){
		return "Bomb" + state.truncate(0).toString() + ".png"
	}
	
	method damageToPlayer() {
		
	}
	
	method explode() {
	    const center = self.position()
	    game.removeVisual(self)
	    self.spawnFire(center)
	
	    game.schedule(100, {
	        self.expandLine(center.up(1), center.up(2))
	        self.expandLine(center.down(1), center.down(2))
	        self.expandLine(center.left(1), center.left(2))
	        self.expandLine(center.right(1), center.right(2))
	    })
	}

	method expandLine(pos1, pos2) {
	    const pathClear = utilities.isMoveValid(pos1)
	
	    if (utilities.notOutOfBorders(pos1)) {
	        self.spawnFire(pos1)
	        
	        if (pathClear) {
	            game.schedule(100, {
	                if (utilities.notOutOfBorders(pos2)) {
	                    self.spawnFire(pos2)
	                }
	            })
	        }
	    }
	}
	
	method spawnFire(targetPosition) {
		return new Fire(position = targetPosition)
	}
	
	method animate() = if (state == 1) {state = 2} else if (state == 2) { state = 3} else if (state == 3) {state = 2.5} else {state = 1}  
	
	method timer(){
			game.onTick(250, myTickName, {
			self.animate()
		})
		game.schedule(3000, {
			game.removeTickEvent(myTickName)
			self.explode()
		})
	}
	
	
	override method use(){
		const newPosition = player.entity().position()
		
		position = newPosition
		self.show()
		self.used(true)
			
		if (used){
			self.removeFromInventory()
			self.timer()
		}
	}
	
	method removeFromInventory(){
		if (self.used()){
			inventory.bombs().remove(self)
		}
	}
	
}
