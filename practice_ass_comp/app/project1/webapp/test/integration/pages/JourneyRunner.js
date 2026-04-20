sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"project1/test/integration/pages/EmpList",
	"project1/test/integration/pages/EmpObjectPage"
], function (JourneyRunner, EmpList, EmpObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('project1') + '/test/flp.html#app-preview',
        pages: {
			onTheEmpList: EmpList,
			onTheEmpObjectPage: EmpObjectPage
        },
        async: true
    });

    return runner;
});

