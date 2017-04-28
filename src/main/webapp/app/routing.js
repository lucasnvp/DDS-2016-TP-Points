poiApp.config(function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise('/');

    return $stateProvider
        .state('login', {
            url: '/',
            templateUrl: 'views/partial-login.html',
            controller: "LoginCrtl",
            controllerAs: "loginCrtl"
        })

        .state('listadoPois', {
            url: '/listadoPois',
            templateUrl: 'views/partial-listadoPois.html',
            controller: "ListaPoisCrtl",
            controllerAs: "listadoCtrl"
        })

        .state('Banco', {
            url: '/bancoInfo/:id',
            templateUrl: 'views/pois/partial-bancoinfo.html',
            controller: "InfoPoiCtrl",
            controllerAs: "bancoCrtl",
            resolve: {}
        })

        .state('CGP', {
            url: '/cgpInfo/:id',
            templateUrl: 'views/pois/partial-cgpinfo.html',
            controller: "InfoPoiCtrl",
            controllerAs: "cgpCrtl",
            resolve: {}
        })

        .state('LocalComercial', {
            url: '/localInfo/:id',
            templateUrl: 'views/pois/partial-localinfo.html',
            controller: "InfoPoiCtrl",
            controllerAs: "localCrtl",
            resolve: {}
        })

        .state('ParadaDeColectivo', {
            url: '/paradaInfo/:id',
            templateUrl: 'views/pois/partial-paradainfo.html',
            controller: "InfoPoiCtrl",
            controllerAs: "paradaCrtl",
            resolve: {

            }
        });
});