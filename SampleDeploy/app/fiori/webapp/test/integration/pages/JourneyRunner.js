sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"fiori/test/integration/pages/BooksList",
	"fiori/test/integration/pages/BooksObjectPage",
	"fiori/test/integration/pages/PersonObjectPage"
], function (JourneyRunner, BooksList, BooksObjectPage, PersonObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('fiori') + '/test/flp.html#app-preview',
        pages: {
			onTheBooksList: BooksList,
			onTheBooksObjectPage: BooksObjectPage,
			onThePersonObjectPage: PersonObjectPage
        },
        async: true
    });

    return runner;
});

