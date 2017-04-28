package ar.edu.utn.frba.dds.SistemaDeConsultasGUI.Poi

import ar.edu.utn.frba.dds.SistemaDeConsultas.Poi
import org.uqbar.arena.aop.windows.TransactionalDialog
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.NumericField
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class PoiWindow extends TransactionalDialog<Poi>{
	
	new(WindowOwner owner, Poi model) {
		super(owner, model)
		title = defaultTitle
	}

	def defaultTitle() {
		"Informacion del Poi"
	}
	
	override protected createFormPanel(Panel mainPanel) {
		val form = new Panel(mainPanel).layout = new ColumnLayout(2)
		 
		new Label(form).text = "Número de linea"
		
		new NumericField(form) => [
			value <=> "nombre"
			width = 100
		]
			
	}
	
}