sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"project1/test/integration/pages/StudentsList",
	"project1/test/integration/pages/StudentsObjectPage"
], function (JourneyRunner, StudentsList, StudentsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('project1') + '/test/flp.html#app-preview',
        pages: {
			onTheStudentsList: StudentsList,
			onTheStudentsObjectPage: StudentsObjectPage
        },
        async: true
    });

    return runner;
});

