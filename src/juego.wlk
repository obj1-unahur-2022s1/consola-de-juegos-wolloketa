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
		keyboard.enter().onPressDo({game.clear();game.addVisual(seleccionNiveles) seleccionNiveles.configurar()})
		//game.schedule(5000, {=> juego.configurar()}) 
		keyboard.q().onPressDo{consola.iniciar()}
	}
	
}

object seleccionNiveles{
	var property niveles= [facil, medio, dificil]
	
	var property position= game.at(0,0)
	
	method image()="nivelFondo.png"
	
	method configurar(){
		niveles.forEach({x=>game.addVisual(x)})
		keyboard.up(nivel.get(1))
	}
	
}

object facil{
	var property position
	var property estaSeleccionado= true
	
	method image()= if(estaSeleccionado) {"facil.png"} else {"facilSinSeleccionar.png"}
}

object medio{
	var property position
	var property estaSeleccionado= false
	
	method image()="medio.png"
}

object dificil{
	var property position
	
	method image()="dificil.png"
}

object fondo {
	var property position = game.at(0,0)
	method image() = "fondo1.png"
	
}

object consola {

	const juegos = [
		mundialito,
		new Juego(color = "Verde"),
		new Juego(color = "Rojo"),
		new Juego(color = "Azul"),
		new Juego(color = "Naranja"),
		new Juego(color = "Violeta")
	]
	var menu 
	
	method initialize(){
		game.height(12)
		game.width(17)
		game.title("Consola de juegos")
		game.boardGround("fondomadera.jpg")
	}
	
	method iniciar(){
		menu = new MenuIconos(posicionInicial = game.center().left(2))	
		game.addVisual(menu)
		juegos.forEach{juego=>menu.agregarItem(juego)}
		menu.dibujar()
		keyboard.enter().onPressDo{self.hacerIniciar(menu.itemSeleccionado())}
		
	}
	
	method hacerIniciar(juego){
		game.clear()
		keyboard.q().onPressDo{self.hacerTerminar(juego)}
		juego.iniciar()
	}
	method hacerTerminar(juego){
		juego.terminar()
		game.clear()
		self.iniciar()
	}
}
//BOTONES EMPEZAR Y SALIR

object iniciar{
	method image() = "empezar.png"
	method position() = game.at(1,16)
	
	method accion(){
		mundialito.iniciar()
	}
}

object salir{
	method image() = "salir.png"
	method position() = game.at(11,16)
}