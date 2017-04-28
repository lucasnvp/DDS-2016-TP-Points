package ar.edu.utn.frba.dds.SistemaDeConsultas.Controller

import org.uqbar.xtrest.api.XTRest
import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.api.Result
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.RepoPerfilesUsuario
import org.uqbar.xtrest.http.ContentType
import org.uqbar.xtrest.json.JSONUtils
import ar.edu.utn.frba.dds.SistemaDeConsultas.RepoPoi
import ar.edu.utn.frba.dds.SistemaDeConsultas.Exception.BusinessException
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Usuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Administrador
import ar.edu.utn.frba.dds.SistemaDeConsultas.Review
import org.uqbar.xtrest.api.annotation.Put
import org.uqbar.xtrest.api.annotation.Body
import org.uqbar.xtrest.api.annotation.Post
import org.json.simple.JSONArray
import ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos.BajaDePois
import org.json.simple.JSONValue
import org.json.simple.JSONObject
import org.json.simple.parser.JSONParser

@Controller
class PoisController {
	
	extension JSONUtils = new JSONUtils
	
	def static void main(String[] args) {
		try {
			RepoPerfilesUsuario.instance.addUsuario(new Usuario("terminalAbasto","123456"))
			RepoPerfilesUsuario.instance.addUsuario(new Usuario("terminalObelisco","123456"))
			RepoPerfilesUsuario.instance.addUsuario(new Administrador("Carlos", "admincarlos","carlos@sysadmin.com"))
			RepoPerfilesUsuario.instance.addUsuario(new Administrador("admin", "admin","admin@sysadmin.com"))
			RepoPerfilesUsuario.instance.findByName("terminalAbasto").addFavorito(RepoPoi.instance.searchById(5))
		} catch (BusinessException e) {
			
		}
		
		//RepoPoi.instance.searchById(1).addReview(new Review(3, "Me gusto bastante.", "Juan"))
		//RepoPoi.instance.searchById(1).addReview(new Review(3, "ESTE REVIEW NO SE DEBERIA AGREGAR", "Juan"))
		//RepoPoi.instance.searchById(1).addReview(new Review(4, "Me gusto mucho.", "Tobias"))
		
		XTRest.start(PoisController, 9000)	
	}
	
	@Get("/usuarios")
	def Result usuarios() {
		val usuarios = RepoPerfilesUsuario.instance.getUsuarios()
		response.contentType = ContentType.APPLICATION_JSON
		ok(usuarios.toJson)
	}
	
	@Get("/usuarios/:nombre")
	def Result usuario() {
		response.contentType = ContentType.APPLICATION_JSON
		val nameStr = String.valueOf(nombre)
		try {
			ok(RepoPerfilesUsuario.instance.findByName(nameStr).toJson)
		} catch (BusinessException e) {
			notFound("No existe un usuario con ese nombre.")
		}
	}
	
	@Get("/pois")
	def Result pois() {
		val pois = RepoPoi.instance.allInstances()
		response.contentType = ContentType.APPLICATION_JSON
		ok(pois.toJson)
	}
	
	@Get("/favorito/:usuario")
	def Result favoritosParaUsuario() {
		response.contentType = ContentType.APPLICATION_JSON
		val nameStr = String.valueOf(usuario)
		
		try {
			val listaFavs = RepoPerfilesUsuario.instance.findByName(nameStr).favoritos
			ok(listaFavs.toJson)
		} catch(Exception e) {
			notFound("Usuario no encontrado.")
		}
	}
	
	@Get("/favorito/:usuario/:poi")
	def Result favorito() {
		response.contentType = ContentType.APPLICATION_JSON
		val intId = Long.valueOf(poi)
		val nameStr = String.valueOf(usuario)
		
		try {
			val boolFav = RepoPerfilesUsuario.instance.findByName(nameStr).esFavorito(RepoPoi.instance.searchById(intId))
			ok(boolFav.toString)
		} catch (RuntimeException e) {
			notFound("Poi o usuario inválido.")
		}
	}
	
	@Post("/pois")
	def Result poisConFavorito(@Body String body) {
		try {
			response.contentType = ContentType.APPLICATION_JSON
			
			val strUsuario = body.fromJson(String)
			val usuario = RepoPerfilesUsuario.instance.findByName(strUsuario)
			
			RepoPoi.instance.usuarioActivo = usuario
			
			ok(RepoPoi.instance.allInstances.toJson)
		} catch (BusinessException e) {
			notFound("Usuario invalido.")
		}
	}
	
	@Get("/pois/:id")
	def Result poi() {
		response.contentType = ContentType.APPLICATION_JSON
		val intId = Long.valueOf(id)
		try {
			ok(RepoPoi.instance.searchById(intId).toJson)
		} catch (RuntimeException e) {
			notFound("No existe el poi con id " + intId + ".")
		}
	}
	
	@Get("/review/:poi")
	def Result reviews() {
		response.contentType = ContentType.APPLICATION_JSON
		val intId = Long.valueOf(poi)
		try {
			ok(RepoPoi.instance.searchById(intId).reviews.toJson)
		} catch (RuntimeException e) {
			notFound("No se encontro el poi con id " + intId + ".")
		}
	}
	
	@Post("/usuario")
	def Result usuarioCorrecto(@Body String body) {
		try {
			val usuarioAChequear = body.fromJson(UsuarioDeServidor)
			val bool = usuarioAChequear.coincidoConUsuario()
			ok(bool.toString)
		} catch (BusinessException e) {
			badRequest("Usuario o contraseña invalido.")
		}
	}
	
	@Put("/review/:poi")
	def Result nuevoReview(@Body String body) {
		
		try {
			val intId = Long.valueOf(poi)
			val review = body.fromJson(Review)
			val poiAReviewear = RepoPoi.instance.searchById(intId)
			
			try {
				poiAReviewear.addReview(review)
			} catch(BusinessException e) {
				badRequest("Ese usuario ya realizo un review.")
			}
			
			ok('{ "status" : "OK" }')
		} catch(RuntimeException e) {
			notFound("Poi inexistente.")
		}

	}
	
	@Put("/favorito/:usuario/:poi")
	def Result favoritearPoi() {
		val longId = Long.valueOf(poi)
		val nameStr = String.valueOf(usuario)
		
		try {
			val user = RepoPerfilesUsuario.instance.findByName(nameStr)
			val elPoi = RepoPoi.instance.searchById(longId)
			
			user.favoritear(elPoi)
			
			ok('{ "status" : "OK" }')
		} catch(Exception e) {
			notFound("Usuario o poi inexistente." + e.message)
		}
	}
	
	@Post("/bajadepois")
	def Result bajadepois(@Body String body) {
		try {
			val jsonObj = body.fromJson(JSONArray)
			
			//Servicio Externo de bajas de pois
			var servicioRest = new BajaDePois
			servicioRest.setearRepo(RepoPoi.instance)
			servicioRest.setearPois(jsonObj)
			servicioRest.procesar 
			
			ok('{ "status" : "OK" }')
		} catch (BusinessException e) {
			notFound("Error al dar de baja los pois")
		}
	}
}