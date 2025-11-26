import wollok.game.*
import keys.*
import map.*

// Es el que reune todos los metodos que moldean el juego
object core {
	method run(){
		game.title("Crazy Cave")
        self.setScreenSize(23, 16)
        map.start()
        keys.setKeys()
	}
	
	method setScreenSize(width, height){
		game.width(width)
		game.height(height)
		game.cellSize(48)
		game.boardGround("BackGround.png")
	}
}
