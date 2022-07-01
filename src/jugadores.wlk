import wollok.game.*
import mundialito.*
import juego.*

class JugadorGenerico{
	const property image= if(nacionalidad== argentino) {"generico_arg.png"} else {"generico_bra.png"}
	var property position
	const property nacionalidad
	
	method pasar(pelota){
		if(nacionalidad == argentino)
		pelota.position(juego.messi().position())
		if(nacionalidad == brasilero)
		pelota.position(juego.neymar().position())
	}
	
	method realizarAccionCon(pelota){
		self.pasar(pelota)
	}
}

class Arquero inherits JugadorGenerico{
	const posicionActual= position
	override method image()= if(nacionalidad== argentino) {"arqueroArg.png"} else {"arqueroBra.png"}
	
	method 	moverseOpuesto(){
		if(position.y()==posicionActual.y())
			self.position(self.position().down(1))
		else{
			self.position(self.position().up(1))
		}
	}
	
	method atajar(pelota){
		pelota.position(game.at(9.randomUpTo(15).truncate(0), 4.randomUpTo(8).truncate(0)))
	}
	
	override method realizarAccionCon(pelota){
		self.atajar(pelota)
	}
}

class JugadorPrincipal {
	const property image
	const property posicionInicial
	var property position = posicionInicial
	var property nacionalidad
	var property ultimoMovimiento = 1
	var property estaLlevandoLaPelota = false
	var property arcoRival = if(nacionalidad == argentino) {juego.arcoBra()} else if(nacionalidad == brasilero) {juego.arcoArg()}
	
	method realizarAccionCon(pelota){
		pelota.serLlevadaPor(self)
	}
	
	method patearPelota(){
		if (self.tieneLaPelota()){
			pelota.serPateadaPor(self)
		}
	}
	
	method tieneLaPelota(){
		return estaLlevandoLaPelota && self.hayPelotaAlrededor()
	}
	
	method hayPelotaAlrededor(){
		return (position.x() - pelota.position().x()).abs() == 1 or (position.y() - pelota.position().y()).abs() == 1
	}
	
	method moverUnoArriba(){
		self.position(self.position().up(1))
		ultimoMovimiento = 1
	}
	method moverUnoAbajo(){
		self.position(self.position().down(1))
		ultimoMovimiento = 2
	}
	method moverUnoDerecha(){
		self.position(self.position().right(1))
		ultimoMovimiento = 3
	}
	method moverUnoIzquierda(){
		self.position(self.position().left(1))
		ultimoMovimiento = 4
	}
	
	method gritarGol() {
		game.say(self, "GOOOOL!")
	}
	
	method volverAPosicionInicial(){
		position = posicionInicial
	}
}

object pelota{
	const property image= "pelota.png"
	const posicionInicial= game.at(8,6)
	var property position = posicionInicial
	
	method serPateadaPor(jugador){
		if (jugador.ultimoMovimiento() == 1){
			position = game.at(jugador.position().x(),jugador.position().up(1.randomUpTo(5)).y().min(11)  )
		}else if (jugador.ultimoMovimiento() == 2){
			position = game.at(jugador.position().x(),jugador.position().down(1.randomUpTo(5)).y().max(1)  )
		}else if (jugador.ultimoMovimiento() == 3){
			position = game.at(jugador.position().right(1.randomUpTo(5)).x().min(16),jugador.position().y()  )
		}else if (jugador.ultimoMovimiento() == 4 ){
			position = game.at(jugador.position().left(1.randomUpTo(5)).x().max(0),jugador.position().y()  )
		}
	}
	
	method serLlevadaPor(jugador){
		jugador.estaLlevandoLaPelota(true)
		if (jugador.ultimoMovimiento() == 1 && jugador.position().up(1).y() < game.height()){
			position = jugador.position().up(1)
		}else if (jugador.ultimoMovimiento() == 2 && jugador.position().down(1).y() > 0){
			position = jugador.position().down(1)
		}else if (jugador.ultimoMovimiento() == 3 && jugador.position().right(1).x() < game.width()){
			position = jugador.position().right(1)
		}else if (jugador.ultimoMovimiento() == 4 && jugador.position().left(1).x() >=0 ){
			position = jugador.position().left(1)
		}
	}
	
	method entrarAlArco(arco) {
		if(arco.nacionalidad() == brasilero) {
		juego.messi().gritarGol()
		juego.marcadorBra().agregarGol()
		self.reubicarse()
		}
		else if(arco.nacionalidad() == argentino) {
		juego.neymar().gritarGol()
		juego.marcadorArg().agregarGol()
		self.reubicarse()
		}
	}
	
	method volverAPosicionInicial(){
		position= posicionInicial
	}
	
	method reubicarse() {
		self.volverAPosicionInicial()
		juego.neymar().volverAPosicionInicial()
		juego.messi().volverAPosicionInicial()
	}
}

object argentino{}
object brasilero{}

class Arco{
	const property position
	const property nacionalidad
	
	method realizarAccionCon(pelota){
		pelota.entrarAlArco(self)
	}
}

class MarcadorDeGoles{
	var property cantidadDeGoles=0
	const property position
	const property nacionalidad
	
	method image(){ 
		var img
		if(cantidadDeGoles== 0){
			img= "goles0.png"
		} else if(cantidadDeGoles== 1){
			img= "goles1.png"
		} else if(cantidadDeGoles== 2){
			img= "goles2.png"
		} else if(cantidadDeGoles== 3){
			img= "goles3.png"
		} else if(cantidadDeGoles== 4){
			img= "goles4.png"
		} else if(cantidadDeGoles== 5){
			img= "goles5.png"
		} return img	
	}
	
	method agregarGol(){
		cantidadDeGoles++
		if(nacionalidad == argentino && cantidadDeGoles == dificultad.cantidadDeGoles()){
			self.ganador(campeonNeymar)
		}else if(nacionalidad == brasilero && cantidadDeGoles == dificultad.cantidadDeGoles()){
			self.ganador(campeonMessi)
		}
	}
	
	method ganador (ganador){
		game.clear()
		game.addVisual(ganador)
		game.addVisual(reiniciar)
		game.schedule(12000, {=> game.stop() })
		keyboard.enter().onPressDo { reiniciar.accion() }
		cantidadDeGoles = 0
		pelota.reubicarse()
	}
	
	method realizarAccionCon(pelota){}
}


object campeonMessi {
	const property position= game.at(0,0)
	const property image = "messiCampeon.png"
}
object campeonNeymar {
	const property position= game.at(0,0)
	const property image = "neymarCampeon.png"
}

object reiniciar {
	method image() = "reiniciar.png"
	method position() = game.center().up(3).left(6)
	
	method accion(){
		mundialito.iniciar()
	}
}

object dificultad{
	var property cantidadDeGoles
}
