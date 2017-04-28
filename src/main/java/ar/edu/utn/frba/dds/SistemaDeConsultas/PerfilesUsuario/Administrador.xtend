package ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario

import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Usuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.BusquedaRealizada
import ar.edu.utn.frba.dds.SistemaDeConsultas.ServiceLocator
import ar.edu.utn.frba.dds.SistemaDeConsultas.Servicios.ServidorDeCorreosPosta
import javax.persistence.Entity
import javax.persistence.DiscriminatorValue
import javax.persistence.Column
import javax.persistence.Transient

@Entity
@DiscriminatorValue("1")
class Administrador extends Usuario {
	
	@Column(length=100)
	String email
	
	@Transient
	ServidorDeCorreosPosta servidorMail = ServiceLocator.getInstance().servicioEmail
	
	new() {
		
	}
	
	new(String unNombre, String unEmail) {
		nombre = unNombre
		email = unEmail
		debeRegistrar = false
		debeNotificar = false
	}
	
	new(String unNombre, String unPassword, String unEmail) {
		nombre = unNombre
		password = unPassword
		email = unEmail
		debeRegistrar = false
		debeNotificar = false
	}	
	
	override notificarTardanza(BusquedaRealizada unaBusqueda) {
		//mailSender.sendMail
		servidorMail.enviarMail("Busqueda excedio tiempo", "system@compania.com", this.email, "La busqueda de la frase \"" + unaBusqueda.fraseBuscada + "\" tardo " + unaBusqueda.tiempoDeConsulta + " segundos.")
		void
	}
	
	override sosTerminal() {
		false
	}
	
	def getEmail() {
		email
	}
}