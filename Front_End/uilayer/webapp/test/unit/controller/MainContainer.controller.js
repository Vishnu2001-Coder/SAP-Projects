/*global QUnit*/

sap.ui.define([
	"uilayer/controller/MainContainer.controller"
], function (Controller) {
	"use strict";

	QUnit.module("MainContainer Controller");

	QUnit.test("I should test the MainContainer controller", function (assert) {
		var oAppController = new Controller();
		oAppController.onInit();
		assert.ok(oAppController);
	});

});
