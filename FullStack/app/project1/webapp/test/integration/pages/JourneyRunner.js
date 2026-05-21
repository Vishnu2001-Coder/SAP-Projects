sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"ns/project1/test/integration/pages/BooksList",
	"ns/project1/test/integration/pages/BooksObjectPage",
	"ns/project1/test/integration/pages/PersonObjectPage"
], function (JourneyRunner, BooksList, BooksObjectPage, PersonObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('ns/project1') + '/test/flp.html#app-preview',
        pages: {
			onTheBooksList: BooksList,
			onTheBooksObjectPage: BooksObjectPage,
			onThePersonObjectPage: PersonObjectPage
        },
        async: true
    });

    return runner;
});

