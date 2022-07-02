import wollok.game.*
import consola.*
import mundialito.*
import jugadores.*

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
	method image() = "pelotaDeConsola.png"
	
	
	method iniciar() {
		game.clear()
		game.addVisual(pantallaInicial) // Pantalla de Neymar y Messi
		keyboard.enter().onPressDo{pantallaInicial.irASeleccionNivel()}
		keyboard.q().onPressDo{pantallaInicial.volver()}
	}	
}

//Pantalla inicial con teclas
object pantallaInicial {
	var property position = game.at(0,0)
	method image() = "fondo1.png"
	
	method irASeleccionNivel() {
			game.clear()
			game.addVisual(seleccionNiveles)
			seleccionNiveles.configurar()
	}
	method volver() {
		game.clear()
		consola.iniciar()
	}
}

//Pantalla seleccionar nivel
object seleccionNiveles{
	var property visuales= [facil, medio, dificil, pelotaSeleccionadora]
	var property position= game.at(0,0)
	method image()="nivelFondo.png"
	
	method configurar(){
		//Agregar visuales de niveles
		visuales.forEach({x=>game.addVisual(x)})
		//Seleccionar con flechas
		keyboard.up().onPressDo{
			if(pelotaSeleccionadora.position().y() == facil.position().y()){
				pelotaSeleccionadora.moverAbajo(4)
				self.seleccionar(dificil, facil, medio)
			}
			else {
				pelotaSeleccionadora.moverArriba(2)
				if(pelotaSeleccionadora.position().y() == medio.position().y())
				self.seleccionar(medio, facil, dificil)
				if(pelotaSeleccionadora.position().y() == facil.position().y())
				self.seleccionar(facil, medio, dificil)
			}
		}
		keyboard.down().onPressDo{
			if(pelotaSeleccionadora.position().y() == dificil.position().y()){
				pelotaSeleccionadora.moverArriba(4)
				self.seleccionar(facil, dificil, medio)
			}
			else {
				pelotaSeleccionadora.moverAbajo(2)
				if(pelotaSeleccionadora.position().y() == medio.position().y())
				self.seleccionar(medio, facil, dificil)
				if(pelotaSeleccionadora.position().y() == dificil.position().y())
				self.seleccionar(dificil, medio, facil)
			}
		}
		//Entrar
		keyboard.i().onPressDo{
			self.nivelSeleccionado().entrar()
		}
	}
	
	method nivelSeleccionado() = visuales.find{v=>v.estaSeleccionado()}
	
	method seleccionar(nivelSeleccionado, nivelb, nivelc) {
		nivelSeleccionado.image(""+nivelSeleccionado+"Seleccionado.png")
		nivelSeleccionado.estaSeleccionado(true)
		nivelb.image(""+nivelb+".png")
		nivelb.estaSeleccionado(false)
		nivelc.image(""+nivelc+".png")
		nivelb.estaSeleccionado(false)
	}
}

//Objetos niveles
object facil{
	var property position = game.at(12,8)
	var property estaSeleccionado = true
	var property image = "facilSeleccionado.png"
	
	method entrar() {
		game.clear()
		dificultad.cantidadDeGoles(1)
		juego.configurar()
	}
}

object medio{
	var property position = game.at(12,6)
	var property estaSeleccionado = false
	var property image = "medio.png"
	
	method entrar() {
		game.clear()
		dificultad.cantidadDeGoles(3)
		juego.configurar()
	}
}

object dificil{
	var property position = game.at(12,4)
	var property estaSeleccionado = false
	var property image = "dificil.png"
	
	method entrar() {
		game.clear()
		dificultad.cantidadDeGoles(5)
		juego.configurar()
	}
}

//Pelota seleccionadora
object pelotaSeleccionadora {
	var property position = facil.position().left(1)
	var property estaSeleccionado = false
	
	method image() = "pelotaDeConsola.png"
	
	method moverArriba(cant) {
		self.position(self.position().up(cant))
	}
	
	method moverAbajo(cant) {
		self.position(self.position().down(cant))
	}
}