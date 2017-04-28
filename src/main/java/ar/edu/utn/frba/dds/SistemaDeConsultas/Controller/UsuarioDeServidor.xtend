package ar.edu.utn.frba.dds.SistemaDeConsultas.Controller

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.RepoPerfilesUsuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.Exception.BusinessException
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Usuario

@Accessors
class UsuarioDeServidor {
	String nombre
	String password
	
	new() {
		nombre = ""
		password = ""
	}
	
	new(String unN, String unP) {
		nombre = unN
		password = unP
	}
	
	def coincidoConUsuario() {
		val usuarioEnRepo = RepoPerfilesUsuario.instance.searchByExample(new Usuario(this.nombre)).head
		
		if (usuarioEnRepo.equals(null)) { throw new BusinessException("Usuario o contraseña invalido.") }
		
		if (usuarioEnRepo.password.equals(this.password)) {
			true
		} else {
			throw new BusinessException("Usuario o contraseña invalido.")
		}
	}
}