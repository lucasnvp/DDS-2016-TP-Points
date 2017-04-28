function ListaPoisCrtl(poisService, $state, $rootScope) {
    var self = this;

    self.usuario = $rootScope.usuarioLogueado;

    self.aBuscar;

    // self.getPois = function() {
    //     poisService.findAll(function(response) {
    //         self.pois = response.data;
    //     });
    // };

    self.getPois = function() {
        poisService.findAllConFavoritos('"' + self.usuario + '"',
            function(response) {
                self.pois = response.data;
        }, self.notificarError);
    };

    self.getPois();

    self.mostrarInfo = function (poi) {
        self.poiSeleccionado = poi;
        $state.go(self.poiSeleccionado.tipoDePoi, {"id": self.poiSeleccionado.id});
    };

    // self.favorito = function () {
    //     return true;
    // };

    function notificarError(mensaje) {
        self.errors.push(mensaje);
        self.getUsuario();
        $timeout(function () {
            while (self.errors.length > 0)
                self.errors.pop();
        }, 3000);
    }

}

poiApp.controller("ListaPoisCrtl", ListaPoisCrtl);

ListaPoisCrtl.$inject = [$state, $rootScope];