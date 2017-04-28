function LoginCrtl($state, usuariosService, $rootScope,$scope, $timeout) {
    var self = this;

    self.user = "";
    self.password = "";

    $scope.required = true;

    function Usuario(unNombre, unaPassword) {
        this.nombre = unNombre;
        this.password = unaPassword;
    }

    self.loguear = function () {

        self.getUsuario();

    };

    self.getUsuario = function () {
        //usuariosService.findUsuario(self.user, function(response) {
        //    self.usuarioABuscar = response.data;

        self.unUsuario = new Usuario(self.user, self.password);

            if (self.user == "") {
                window.alert("Debe ingresar un usuario");
            } else if (self.password == "") {
                window.alert("Debe ingresar una contraseña");
            }

        usuariosService.checkUser(self.unUsuario,
            function(response) {
                if (response.data == 'true') {
                    $rootScope.usuarioLogueado = self.unUsuario.nombre;
                    $state.go('listadoPois');
                }
            }, self.notificarError);
    };

    self.errors = [];

    function notificarError(mensaje) {
        self.errors.push(mensaje);
        self.getUsuario();
        $timeout(function () {
            while (self.errors.length > 0)
                self.errors.pop();
        }, 3000);
    };

}

poiApp.controller("LoginCrtl", LoginCrtl);

LoginCrtl.$inject = [$state];