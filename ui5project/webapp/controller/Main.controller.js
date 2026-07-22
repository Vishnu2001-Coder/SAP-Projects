sap.ui.define([                                                                                                                                      //module loader , before running the code, it will load the required modules
    "sap/ui/core/mvc/Controller"                                                                                                                     //This module is parent class for SapUI5 controllers, 
],


    (BaseController) => {                                                                                                                           //dependency injection, the loaded module will be passed as a parameter to the function
        "use strict";                                                                                                                               //normally js is loosly typed , so thats why strict mode, it will throw an error if a variable is used without declaring it

        return BaseController.extend("ui5project.controller.Main", {                                                                                //we are creating our controller by extending UI5 Controller.
            onInit() {
                console.log("Im onInit");                                                                                                           // which always run Automattically , when its load 
            },
            onPress: function () {
                alert("Clicked");
                this.getOwnerComponent().getRouter().navTo("RouteButton");                                                                          //this-> Current controller Object . Root file Of UI5(Component.js Object).its return a router Object . navTo -> which will navigate one page to another page. Inside define a name that should be in manifest json . target name should give a right view name
            },
        });
    });


    

















//Multiple Module Example:

// sap.ui.define([
//   "sap/ui/core/mvc/Controller",
//   "sap/ui/model/json/JSONModel",                                         //
//   "sap/m/MessageToast"                                                          //It is just a utility class to show popup messages.
// ], (BaseController, JSONModel, MessageToast) => {                          //parameter order is should be same.

//   "use strict";

//   return BaseController.extend("ui5project.controller.App", {

//       onInit: function () {
//           var oModel = new JSONModel();
//       },

//       onPress: function () {
//           MessageToast.show("Clicked");
//       }

//   });
// });