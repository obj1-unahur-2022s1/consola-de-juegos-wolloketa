import wollok.game.*
import jugadores.*



object juego{
	const jugadorArg1= self.crearJugador("Arg1", game.at(10,2), argentino)
	const jugadorArg2= self.crearJugador("Arg2", game.at(10,9), argentino)
	const jugadorArg3= self.crearJugador("Arg3", game.at(12,6), argentino)
	const jugadorBra1= self.crearJugador("Bra1", game.at(6,2), brasilero)
	const jugadorBra2= self.crearJugador("Bra2", game.at(6,9), brasilero)
	const jugadorBra3= self.crearJugador("Bra3", game.at(4,6), brasilero)
	const seleccionArgentina= [jugadorArg1, jugadorArg2,jugadorArg3]
	const seleccionBrasil= [ jugadorBra1,  jugadorBra2,  jugadorBra3]
	
	const arquero1= new Arquero(position= game.at(15,6), nacionalidad= argentino)
	const arquero2= new Arquero(position= game.at(1,6), nacionalidad= brasilero)
	
	const property arcoBra = new Arco(position=game.at(0,5), nacionalidad= brasilero)
	const arcoBra2 = new Arco(position=game.at(0,6), nacionalidad= brasilero)
	
	const property arcoArg = new Arco(position=game.at(16,5), nacionalidad= argentino)
	const arcoArg2 = new Arco(position=game.at(16,6), nacionalidad= argentino)
	
	const arcos = [arcoBra, arcoBra2, arcoArg, arcoArg2]
	
	const property messi = new JugadorPrincipal (posicionInicial=game.at(9,6), image="messi_colo.png", nacionalidad = argentino)
	const property neymar = new JugadorPrincipal (posicionInicial=game.at(7,6), image="neymar.png", nacionalidad = brasilero)
	const property marcadorArg= new MarcadorDeGoles(position=game.at(1,11), nacionalidad= argentino)
	const property marcadorBra= new MarcadorDeGoles(position=game.at(12,11), nacionalidad=brasilero)
	
	
	const property visuales= [pelota, arcoBra, arcoBra2, arcoArg, arcoArg2, jugadorArg1, jugadorArg2,jugadorArg3, jugadorBra1,  jugadorBra2, jugadorBra3, messi, neymar, arquero1, arquero2, marcadorArg, marcadorBra,banderaArg,banderaBra]
	const visualesADesaparecer= [pelota, messi, neymar]
	method crearJugador(nombre, position, nacionalidad){
		return new JugadorGenerico(position= position, nacionalidad= nacionalidad)
	}
	
 	method configurar(){
		//Tablero
		game.height(12)
		game.width(17)
		game.title("Mundialito 2022")
		game.addVisual(campoDeJuego)
		
		//Sonido
		const hinchada = game.sound("AudioFondo.mp3")
	    hinchada.shouldLoop(true)
	    keyboard.plusKey().onPressDo({hinchada.volume(1)})
		keyboard.minusKey().onPressDo({hinchada.volume(0.5)})
		keyboard.slash().onPressDo({hinchada.volume(0)})
	    game.schedule(500, { hinchada.play()} )
	    
	    //Agregar visuales y demás
		self.iniciarJuego()
	}
	
	method iniciarVisuales(){
		self.visuales().forEach({x=>game.addVisual(x)})
	}
	
	

	
	method iniciarJuego(){
		//Visuales
		self.iniciarVisuales()
		
		//Movimiento arqueros
		game.onTick(1000, "el meneaito", { => 
			arquero1.moverseOpuesto()
			arquero2.moverseOpuesto()
		})
		
		//Movimiento jugadores activo
		keyboard.w().onPressDo { messi.moverUnoArriba() }
		keyboard.s().onPressDo { messi.moverUnoAbajo() }
		keyboard.a().onPressDo { messi.moverUnoIzquierda() }
		keyboard.d().onPressDo { messi.moverUnoDerecha() }
		keyboard.space().onPressDo { messi.patearPelota() }
		keyboard.up().onPressDo { neymar.moverUnoArriba() }
		keyboard.down().onPressDo { neymar.moverUnoAbajo() }
		keyboard.left().onPressDo { neymar.moverUnoIzquierda() }
		keyboard.right().onPressDo { neymar.moverUnoDerecha() }
		keyboard.enter().onPressDo { neymar.patearPelota() }
		
		
		game.whenCollideDo(pelota, { cosita => cosita.realizarAccionCon(pelota)
		})
		
		//self.salirCampeon()
		}
}

object campoDeJuego{
	const property image = "ground.png"
	const property position = game.at(0,0)
	
}
object banderaArg {
	const property image = "banderaArg.png"
	const property position = game.at(16,11)
	method realizarAccionCon(pelota){}
	
}
object banderaBra {
	const property image = "banderaBra.png"
	const property position = game.at(0,11)
	method realizarAccionCon(pelota){}
}
