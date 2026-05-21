sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"ns/fiori/test/integration/pages/BooksList",
	"ns/fiori/test/integration/pages/BooksObjectPage",
	"ns/fiori/test/integration/pages/PersonObjectPage"
], function (JourneyRunner, BooksList, BooksObjectPage, PersonObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('ns/fiori') + '/test/flp.html#app-preview',
        pages: {
			onTheBooksList: BooksList,
			onTheBooksObjectPage: BooksObjectPage,
			onThePersonObjectPage: PersonObjectPage
        },
        async: true
    });

    return runner;
});

