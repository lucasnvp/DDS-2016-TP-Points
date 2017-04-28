function InfoPoiCtrl($stateParams, poisService, favoritoService, $rootScope) {
    var self = this;

    self.usuario = $rootScope.usuarioLogueado;

    self.getPoi = function() {
        poisService.findById($stateParams.id, function(response) {
            self.poi = response.data;
        });
    };

    self.getPoi();

    self.esFavorito = function () {
        favoritoService.findFavorito(self.usuario, $stateParams.id, function(response) {
            self.favoritiar = response.data;
        });
    };

    self.esFavorito();

    self.enviarFavorito = function () {
        favoritoService.enviarFavorito(self.usuario, $stateParams.id, !self.favoritiar, function() {
            self.esFavorito()
        });
    }

}

poiApp.controller("InfoPoiCtrl", InfoPoiCtrl);

InfoPoiCtrl.$inject = [$stateParams, $rootScope];