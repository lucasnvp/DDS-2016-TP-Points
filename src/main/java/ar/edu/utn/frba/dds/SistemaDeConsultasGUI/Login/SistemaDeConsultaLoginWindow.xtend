package ar.edu.utn.frba.dds.SistemaDeConsultasGUI.Login

import ar.edu.utn.frba.dds.SistemaDeConsultasGUI.Busqueda.BusquedaModelo
import ar.edu.utn.frba.dds.SistemaDeConsultasGUI.Busqueda.BusquedaWindow
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.PasswordField
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.Window
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class SistemaDeConsultaLoginWindow extends Window<SistemaDeConsultaLoginModelo>{
	
	new(WindowOwner owner, SistemaDeConsultaLoginModelo model) {
		super(owner, model)
	}
	
	override createContents(Panel mainPanel) {
		title = "Ingreso al sistema"		
		
		val panelSuperior = new Panel(mainPanel)
		//Usuario		
		new Label(panelSuperior)=> [
			text = "Usuario"
			width = 200	
		]
		new TextBox(panelSuperior) => [
			value <=> "nombreDeUsuario"
			width = 200	
		]
				
		val panelInferior = new Panel(mainPanel)
		//TODO: ocultar la contraseña con asteriscos.
		//Password		
		new Label(panelInferior)=> [
			text = "Password"
			width = 200	
		]
		new PasswordField(panelInferior) => [
			value <=> "contrasenaUasuario"
			width = 200	
		]

		//Boton de ingreso		
		new Button(panelInferior) =>[
			caption = "Login"
			onClick [ |
				this.close
				new BusquedaWindow(this, new BusquedaModelo).open
			]
				
		]		

	}
	
	
	
}
