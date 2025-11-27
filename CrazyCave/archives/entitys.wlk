import wollok.game.*
import player.*
import obstacles.*
import core.*
import hud.*
import utilities.*
import items.*
import inventory.*
import gameover.*
import win.*
import map.*


// Es la clase "madre" de tolos las entidades del juego, de donde heredan las demas
class Entity {
	var property position = game.at(0, 0)

	method use(){}
	
	method show(){
		game.addVisual(self)
	}
	
	method isObstacle() = false
	
	method onHitByExplosion(hp){}
	
	method onHitByPickaxe(hp){}
	
	method modifyScoreWhen(situation){}
	
	method damageToPlayer(){}
}


// Son las entidades que no te permiten el movimiento, es decie, no son traspasables
class Obstacle inherits Entity{
	var property life
	
	override method isObstacle() = true
	
	method decreaseHP(hp){
		life -= hp
	}
	
	override method onHitByExplosion(hp){
		self.decreaseHP(20)
		if (self.life() < 1){
			game.removeVisual(self)
			self.modifyScoreWhen("brokenByExplosion")
		}
	}
	
	override method onHitByPickaxe(hp){
		self.decreaseHP(hp)
		if (self.life() < 1){
			game.removeVisual(self)
			self.modifyScoreWhen("brokenByPickaxe")
		}
	}	
}

// Estas son las entidades que efectuan estos estados
// Las rocas
class Rock inherits Obstacle{
	const imageNumber = 1.randomUpTo(4).truncate(0)
	
	method initialize(){
		self.life(20)
	}
	
	method image() = "Rock" + imageNumber.toString() + ".png"
	
	override method modifyScoreWhen(situation){
		if (situation == "brokenByPickaxe"){
			score.increaseScore(5)
		}
		else{}
	}
	
	override method onHitByPickaxe(hp){
		super(1)
	}
}

// Las geodas y sus distintos tipos (rarezas)
//	1- Naranja
//	2- Violeta
//	3- Verde
//	4- Azul
class Gblue inherits Obstacle{
	
	method initialize(){
		self.life(3)
	}
	
    method image() {
        return "GeodeBlue.png"
    }
    
    override method modifyScoreWhen(situation){
		if (situation == "brokenByPickaxe"){
			score.increaseScore(50)
		}
		else{}
	}
}

class Ggreen inherits Gblue{
	method initialize(){
		self.life(6)
	}
	
    override method image() {
        return "GeodeGreen.png"
    }
    
    override method modifyScoreWhen(situation){
		if (situation == "brokenByPickaxe"){
			score.increaseScore(150)
		}
		else{}
	}
}

class Gpurple inherits Gblue{
	method initialize(){
		self.life(12)
	}
	
    override method image() {
        return "GeodePurple.png"
    }
    
    override method modifyScoreWhen(situation){
		if (situation == "brokenByPickaxe"){
			score.increaseScore(400)
		}
		else{}
	}
}

class Gorange inherits Gblue{
	method initialize(){
		self.life(20)
	}
	
    override method image() {
        return "GeodeOrange.png"
    }
    
    override method modifyScoreWhen(situation){
		if (situation == "brokenByPickaxe"){
			score.increaseScore(1000)
		}
		else{}
	}
}

// Los cofres
class Chest inherits Obstacle{
	const item = new Bomb()
	var state = 1
	const myTickName = "chest_" + 0.randomUpTo(10000).toString()
	var opened = false
	
	method initialize(){
		self.life(1)
	}
	
	override method onHitByPickaxe(hp){
		if (not opened){
			self.openAnimation()
			inventory.bombs().add(item)
			opened = true
		}
	}
	
	override method modifyScoreWhen(situation){
		if (situation == "brokenByPickaxe"){
			score.increaseScore(25)
		}
		else{}
	}
	
	method animate(){
		if (state == 1) {state = 2} else if (state == 2) {state = 3} else {state = 4}
	}
	
	method openAnimation(){
		game.onTick(250, myTickName, {
			self.animate()
		})
		game.schedule(1250, {
			game.removeTickEvent(myTickName)
			game.removeVisual(self)
		})
	}
	
	method image() = "chest" + state.toString() + ".png"
}

// Es el ultimo estado de la bomba, el momento de la explosion
class Fire inherits Entity {
	const myTickName = "fire_" + 0.randomUpTo(10000).toString()
	var state = 1

	method initialize() {
		self.show()
		game.onTick(250, myTickName, { self.animate()})
		game.onCollideDo(self, { entity => entity.onHitByExplosion(1) })
		game.schedule(500, { 
			game.removeTickEvent(myTickName)
			game.removeVisual(self) })
	}

	method animate() {
		if (state == 1) state = 2 else state = 1
	}

	method image() = "Flame" + state + ".png"

}


// Son las entidades que tienen movimiento, como el Golem o el jugador
class MovableEntity inherits Entity{
	var property direction = "down"
	
	method moveUp() {
		const newPosition = position.up(1)
		if (utilities.isMoveValid(newPosition)){
			position = newPosition
		}
		direction = "up"
	}
	
	method moveDown() {
		const newPosition = position.down(1)
		if(utilities.isMoveValid(newPosition)){
			position = newPosition
		}		
		direction = "down"
	}	
	
	method moveLeft() {
		const newPosition = position.left(1)
		if (utilities.isMoveValid(newPosition)){
			position = newPosition
		}		
		direction = "left"
	}	
	
	method moveRight() {
		const newPosition = position.right(1)
		if (utilities.isMoveValid(newPosition)){
			position = newPosition
		}		
		direction = "right"
	}
}

// La clase del minero y el que le da la identidad
class Miner inherits MovableEntity{
	var property life = 6
	
	method image(){
		if (direction == "up"){
			return "MBack.png"
		}
		
		else if (direction == "down"){
			return "MFront.png"
		}
		
		else if (direction == "left"){
			return "MLeft.png"
		}
		
		else{
			return "MRight.png"
		}
	}
	
	method getDamageNumber(){
		const probability = 0.randomUpTo(10)
		
		if (probability.between(0, 8.5)){
			return 1 //85%
		} else {
			return 3 //15%
		}
	}
	
	method breakObstacleInTheDirection(){
		const obstacle = self.obstacleInDirection()
		
		if (obstacle == null){
			return ""
		} else {
			obstacle.onHitByPickaxe(self.getDamageNumber()) 
			return ""
		}
	}
	
	method obstacleInDirection(){
		var obstacle = null
		
		if (direction == "up"){
			obstacle = game.getObjectsIn(position.up(1))
		}
		else if (direction == "down"){
			obstacle = game.getObjectsIn(position.down(1))
		}
		else if (direction == "left"){
			obstacle = game.getObjectsIn(position.left(1))
		}
		else{
			obstacle = game.getObjectsIn(position.right(1))
		}
		
		if (obstacle == []) {
			return null
		} else {
			return obstacle.get(0)
		}
	}
	
	method decreaseHP(hp){
		life -= hp
	}
	
	override method modifyScoreWhen(situation){
		if (situation == "hitByExplosion"){
			score.decreaseScore(500)
		}
		else if (situation == "hitByGolem"){
			score.decreaseScore(200)
		}
	}
	
	override method onHitByExplosion(hp){
		self.decreaseHP(5)
		hudDraw.updateHearts()
		if (self.life() < 1){
			self.die()
		}
		self.modifyScoreWhen("hitByExplosion")
	}

	method hitByGolem() {
		self.decreaseHP(1)
		hudDraw.updateHearts()
		self.modifyScoreWhen("hitByGolem")
		if (life < 1) {
			self.die()
		}
	}
	
	method die(){
		game.schedule(3000, {
			game.removeVisual(self)
			map.clearLevel()
			gameOver.show()
			})
	}

	
}

// El golem y sus funciones
class Golem inherits MovableEntity {
	var stunned = false
    var property life = 1
    var property lastPositions = []

	override method modifyScoreWhen(situation){
		if (situation == "hitByExplosion"){
			score.increaseScore(10)
		}
	}
	
	override method onHitByExplosion(hp){
		self.modifyScoreWhen("hitByExplosion")
		stunned = true
		game.schedule(3000, {
			stunned = false
		})
	}

    method image() {
        if (self.direction() == "up")    return "GBack.png"
        if (self.direction() == "down")  return "GFront.png"
        if (self.direction() == "left")  return "GLeft.png"
        return "GRight.png"
    }

    method moveTowardsPlayer() {
        const startPos = self.position()
        const targetPos = self.getPlayerPosition()
        
        if (stunned){
        	return ""
        }
        
        return self.following(startPos, targetPos)
    }

	override method damageToPlayer() {
		if (self.position() == player.entity().position()) {
			player.entity().hitByGolem()
		}
	}

    method getPlayerPosition() {
        return player.entity().position()
    }
	
	// Comando de movimiento de segumiento (ayuda con IA)
    method following(startPos, targetPos) {

        const possibleMoves = self.getPossibleMoves()

        // 1. Ordenar por cercanía al jugador
        const sortedMoves = possibleMoves.sortedBy({
            moveA, moveB => moveA.get(1).distance(targetPos) < moveB.get(1).distance(targetPos)
        })

        // 2. Filtrar movimientos válidos
        const validMoves = sortedMoves.filter({
            move => utilities.isMoveValid(move.get(1))
        })

        // 3. Filtrar movimientos que repiten "loops"
        const noLoopMoves = validMoves.filter({
            move => !lastPositions.contains(move.get(1))
        })

        var selectedMove = null

        if (!noLoopMoves.isEmpty()) {
            selectedMove = noLoopMoves.get(0)
        }
        else if (!validMoves.isEmpty()) {
            selectedMove = validMoves.get(0)
        }

        // 4. Si no hay movimiento válido → ejecutar wall-following
        if (selectedMove == null) {
            self.followWall()
            return ""
        }

        // 5. Guardar posición actual antes de moverse (memoria anti-loop)
        self.rememberPosition(self.position())

        // 6. Ejecutar movimiento
        self.executeMove(selectedMove.get(0), selectedMove.get(1))
        return ""
    }


    // Memoria anti-loop
    method rememberPosition(pos) {
        lastPositions.add(pos)
        if (lastPositions.size() > 4) {  // recuerda solo 4 posiciones
            lastPositions.remove(lastPositions.get(0))
        }
    }


    // Lista de movimientos posibles
    method getPossibleMoves() {
        return [
            ["up", position.up(1)],
            ["down", position.down(1)],
            ["left", position.left(1)],
            ["right", position.right(1)]
        ]
    }

    // Ejecutar movimiento
    method executeMove(aDirection, newPosition) {
        self.direction(aDirection)
        self.position(newPosition)
    }


    // 🧱 WALL FOLLOWING (bordeo de obstáculos)
    method followWall() {

        // orden fijo para rodear obstáculos (mano derecha)
        const prefs = ["left", "down", "right", "up"]

        const found = prefs.find({
            dir => utilities.isMoveValid(self.nextPos(dir))
        })

        if (found != null) {
            const pos = self.nextPos(found)
            self.rememberPosition(self.position())
            self.executeMove(found, pos)
        }
    }

    method nextPos(dir) {
        if (dir == "up")    return position.up(1)
        if (dir == "down")  return position.down(1)
        if (dir == "left")  return position.left(1)
        return position.right(1)
    }
}


