poiApp.service('usuariosService',function ($http) {
    this.findUsuario = function (usuario, callback, errorHandler) {
        $http.get('/usuarios/' + usuario).then(callback, errorHandler);
    };

    this.findAll = function(callback, errorHandler) {
        $http.get('/usuarios').then(callback, errorHandler);
    };

    this.checkUser = function(usuario, callback, errorHandler) {
        $http.post('/usuario', usuario).then(callback, errorHandler)
    }
});

poiApp.service('poisService',function ($http) {
    this.findAll = function(callback) {
        $http.get('/pois').then(callback);
    };

    this.findById = function(id, callback) {
        $http.get('/pois/' + id).then(callback);
    };

    this.findAllConFavoritos = function(usuario, callback, errorHandler) {
        $http.post('/pois', usuario).then(callback, errorHandler);
    };
});

poiApp.service('favoritoService',function ($http) {
    this.findFavorito = function(usuario, id, callback) {
        $http.get('/favorito/' + usuario + '/' + id ).then(callback);
    };

    this.enviarFavorito = function(usuario, id, bool, callback) {
        $http.put('/favorito/' + usuario + '/' + id, bool ).then(callback);
    };
});

poiApp.service('reviewService',function ($http) {
    this.findAll = function(callback) {
        $http.get('/review').then(callback);
    };

    this.findById = function(id, callback) {
        $http.get('/review/' + id).then(callback);
    };

    this.enviarComentario = function (id, comentario, callback) {
        $http.put('/review/' + id, comentario).then(callback);
    };
});