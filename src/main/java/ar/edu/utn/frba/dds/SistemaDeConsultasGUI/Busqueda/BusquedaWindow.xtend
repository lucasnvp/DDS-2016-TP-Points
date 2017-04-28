package ar.edu.utn.frba.dds.SistemaDeConsultasGUI.Busqueda

import ar.edu.utn.frba.dds.SistemaDeConsultas.Poi
import ar.edu.utn.frba.dds.SistemaDeConsultasGUI.Poi.PoiWindow
import java.awt.Color
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class BusquedaWindow extends SimpleWindow<BusquedaModelo>{

	new(WindowOwner owner, BusquedaModelo model) {
		super(owner, model)
		modelObject.todosLosPois
	}
	
	/**
	 * El default de la vista es un formulario que permite disparar la búsqueda (invocando con super) Además
	 * le agregamos una grilla con los resultados de esa búsqueda y acciones que pueden hacerse con elementos
	 * de esa búsqueda
	 */
	override def createMainTemplate(Panel mainPanel) {
		title = "Búsqueda"
		taskDescription = "Criterio de búsqueda"

		super.createMainTemplate(mainPanel)

		this.createResultsGrid(mainPanel)
	}
	
	// *************************************************************************
	// * FORMULARIO DE BUSQUEDA
	// *************************************************************************
	/**
	 * El panel principal de búsuqeda permite filtrar por nombre o direccion
	 */
	override def void createFormPanel(Panel mainPanel) {
		val searchFormPanel = new Panel(mainPanel) => [
			layout = new ColumnLayout(2)
		]

		new Label(searchFormPanel) => [
			text = "Nombre"
			foreground = Color.BLUE
		]

		new TextBox(searchFormPanel) => [
			value <=> "nombreABuscar"
			width = 200
		]

		new Label(searchFormPanel) => [
			text = "Direccion"
			foreground = Color.BLUE
		]

		new TextBox(searchFormPanel) => [
			value <=> "direccion"
			width = 200
		]
	}
	
	/**
	 * Acciones asociadas de la pantalla principal. 
	 */
	override protected addActions(Panel actionsPanel) {
	
		//Boton de nuevo poi
		new Button(actionsPanel) => [
			caption = "Buscar"
			onClick([|this.openDialog(new PoiWindow(this, modelObject.poiSeleccionado))])
		]
		
		//Boton de busqueda
		new Button(actionsPanel) => [
			caption = "Agregar"
			onClick([|modelObject.buscarPorNombreSinUsuario()])
			setAsDefault
			disableOnError
		]

	}
	
	// *************************************************************************
	// ** RESULTADOS DE LA BUSQUEDA
	// *************************************************************************
	/**
	 * Se crea la grilla en el panel de abajo El binding es: el contenido de la grilla en base a los
	 * resultados de la búsqueda Cuando el usuario presiona Buscar, se actualiza el model, y éste a su vez
	 * dispara la notificación a la grilla que funciona como Observer
	 */
	def protected createResultsGrid(Panel mainPanel) {
		val table = new Table<Poi>(mainPanel, typeof(Poi)) => [
			items <=> "resultados"
			value <=> "poiSeleccionado"
		]
		this.describeResultsGrid(table)
	}
	
	/**
	 * Define las columnas de la grilla Cada columna se puede bindear 1) contra una propiedad del model, como
	 * en el caso del número o el nombre 2) contra un transformer que recibe el model y devuelve un tipo
	 * (generalmente String), como en el caso de Recibe Resumen de Cuenta
	 *
	 * @param table
	 */
	def void describeResultsGrid(Table<Poi> table) {
		new Column<Poi>(table) => [
			title = "Nombre"
			fixedSize = 200
			bindContentsToProperty("nombre")
		]

		new Column<Poi>(table) => [
			title = "Direccion"
			bindContentsToProperty("direccion")
		]
		
	}
//	override createContents(Panel panelPrincpal) {
//		title = "Búsqueda"
//
//		val panel1 = new Panel(panelPrincpal)
//		panel1 => [
//			layout = new HorizontalLayout
//		]
//		new Label(panel1) => [
//			text = "Criterio de búsqueda"
//			height = 60
//			foreground = Color.BLACK.darker
//		]
//		
////-----------------------------------------------------------
//
//		val panel2 = new Panel(panelPrincpal)
//
//
//		val panel21 = new Panel(panel2)
//
//		panel21 => [
//			layout = new ColumnLayout(3)
//		]
//		
//		new Label(panel21) => [
//			text = "Nombre"
//		]
//		
//		val panel21C = new Panel (panel21)
//		
//		panel21C => [
//			layout = new HorizontalLayout
//		]
//		
//		new Label(panel21C).text = '                      '
//		
//		
//		new Button(panel21C) => [
//			caption = "Agregar"
//			background = Color.GRAY.brighter
//			foreground = Color.BLACK.darker
////			onClick[| close ]
//		]
//		
//		new Button(panel21) => [
//			caption = "Buscar"
//			background = Color.GRAY.brighter
//			foreground = Color.BLACK.darker
//			onClick[| buscarPoi ]
//		]
//		
//
//		val panel22 = new Panel(panel2)
//
//		panel22 => [
//			layout = new ColumnLayout(3)
//		]
//		
//		val textBoxNombre1 = new TextBox(panel22)  
//		
//		textBoxNombre1 => [
//			width = 500
//			value <=> "nombre1"
//			
//		]	
//		
//		val panel23 = new Panel(panel2)
//
//		panel23 => [
//			layout = new ColumnLayout(3)
//		]
//
//		val textBoxNombre2 = new TextBox(panel23)  
//		
//		textBoxNombre2 => [
//			width = 500
//			value <=> "nombre2"
//		]
//
//
////-----------------------------------------------------------
//		
//		val panel3 = new Panel(panelPrincpal)
//		
//		new Label(panel3) =>[
//			text = "Resultado"
//			foreground = Color.BLACK.darker
//		]
//		
//		// *************************************************************************
//		// ** RESULTADOS DE LA BUSQUEDA
//		// *************************************************************************
//		val tablaDeResultados = new Table<Poi>(panelPrincpal, typeof(Poi)) 
//		tablaDeResultados => [
//			height = 10
//			width = 1500
//			items <=> "listaResultados"
//			value <=> "poiSeleccionado"
//		]
//		
//		new Column<Poi>(tablaDeResultados) => [
//			title = "Nombre"
//			foreground = Color.BLACK.darker
//			fixedSize = 200
//			bindContentsToProperty("nombre")
//		]
//		
//		new Column<Poi>(tablaDeResultados) => [
//			title = "Dirección"
//			fixedSize = 500
//			bindContentsToProperty("direccion")
//		]
//	}
	
	def void buscarPoi() {
		this.modelObject.buscarPoi()
	}
	
	def openDialog(Dialog<?> dialog) {
		dialog.onAccept[|modelObject.buscarPoi]
		dialog.open
	}
	
}