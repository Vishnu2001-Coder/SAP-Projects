sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"project1/test/integration/pages/VehiclesList",
	"project1/test/integration/pages/VehiclesObjectPage",
	"project1/test/integration/pages/VehicleOrdersObjectPage"
], function (JourneyRunner, VehiclesList, VehiclesObjectPage, VehicleOrdersObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('project1') + '/test/flp.html#app-preview',
        pages: {
			onTheVehiclesList: VehiclesList,
			onTheVehiclesObjectPage: VehiclesObjectPage,
			onTheVehicleOrdersObjectPage: VehicleOrdersObjectPage
        },
        async: true
    });

    return runner;
});

