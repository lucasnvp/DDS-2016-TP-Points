'use strict';

poiApp.directive('opinionesPois', function () {
    return {
        restrict: 'E',
        templateUrl: 'views/partial-opinionesPois.html',
        controllerAs: 'opinionesCtrol',
        bindToController: true,
        scope: false,
        controller: function (reviewService, $stateParams, $rootScope) {
            var self = this;

            self.getPoi = function() {
                reviewService.findById($stateParams.id, function(response) {
                    self.comentarios = response.data;
                    self.calificacionGral = promedio();
                });
            };

            self.opinion = "";
            self.calificacion = '';
            self.usuario = $rootScope.usuarioLogueado;

            //Hacer funcion de promedio
            function promedio() {
                //Seteo la variable sumatoria en 0
                self.sumatoria = 0;
                //Calculo la cantidad
                self.cant = _.size(self.comentarios);
                //Hago la sumatoria
                _.forEach(self.comentarios, function (value) {
                    self.sumatoria = value.calificacion + self.sumatoria;
                });
                //Hago el promedio
                return _.round(_.divide(self.sumatoria, self.cant),1);
            }

            //Comentario Nuevo
            function Comentario(usuario, comentario, calificacion) {
                return {calificacion: calificacion, comentario: comentario, calificador: usuario};
            }

            //Ingresar comentario
            self.enviar = function () {
                reviewService.enviarComentario($stateParams.id, new Comentario(self.usuario,  self.opinion, self.calificacion), function() {
                    self.getPoi();
                });
            };

            self.getPoi();

        }
    };
});