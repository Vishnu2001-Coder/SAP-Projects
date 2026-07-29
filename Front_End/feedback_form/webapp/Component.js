sap.ui.define([
    "sap/ui/core/UIComponent",
    "sap/ui/model/json/JSONModel"                                                                     //Note
], function (UIComponent, JSONModel) {
    "use strict";

    return UIComponent.extend("formns.feedbackform.Component", {

        metadata: {
            manifest: "json"
        },

        init: function () {

            // Call the base component's init function
            UIComponent.prototype.init.apply(this, arguments);

            // JSON Data
            var oData = {
                form: {
                    name: "",
                    email: "",
                    subject: "",
                    message: ""
                },
                feedbackList: [],
                total: 0
            };

            // Create JSON Model
            var oModel = new JSONModel(oData);

            // Set as default model
            this.setModel(oModel,"models");

              // IMPORTANT
            this.getRouter().initialize();

        }

    });

});