import wollok.game.*
import consola.*
import mundialito.*

class Juego {
	var property position = null
	var property color 
	
	method iniciar(){
        game.addVisual(object{method position()= game.center() method text() = "Juego "+color + " - <q> para salir"})		
	}
	
	method terminar(){

	}
	method image() = "juego" + color + ".png"
	

}

object mundialito {
	var property position
	method image() = "mundial.png"
	
	
	method iniciar() {
		game.clear()
		game.addVisual(fondo)
		game.schedule(5000, {=> juego.configurar()}) 
		
	}
}

object fondo {
	var property position = game.at(0,0)
	method image() = "fondo1.png"
}


