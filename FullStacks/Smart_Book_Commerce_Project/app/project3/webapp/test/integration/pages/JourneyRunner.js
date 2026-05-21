sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"ns/project3/test/integration/pages/CustomersList",
	"ns/project3/test/integration/pages/CustomersObjectPage",
	"ns/project3/test/integration/pages/ReviewsObjectPage"
], function (JourneyRunner, CustomersList, CustomersObjectPage, ReviewsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('ns/project3') + '/test/flp.html#app-preview',
        pages: {
			onTheCustomersList: CustomersList,
			onTheCustomersObjectPage: CustomersObjectPage,
			onTheReviewsObjectPage: ReviewsObjectPage
        },
        async: true
    });

    return runner;
});

