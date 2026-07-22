sap.ui.define(["sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/resource/ResourceModel",
    "sap/ui/model/odata/v4/ODataModel",
     "sap/m/MessageToast"], function (BaseController, JSONModel, ResourceModel, ODataModel,MessageToast) {
        "use strict";
        return BaseController.extend("ui5project.controller.ODataModelBinding", {
            onInit() {
                let odataModel=this.getOwnerComponent().getModel();                                     //T
                console.log(odataModel);
                let totalModel=this.getView().oModels;                                                  //{} whole Json
                console.log(totalModel);
                
            },
            buttonOne(){
               console.log("Hi");
               let oModel = this.getOwnerComponent().getModel();
               console.log(this.getView().getModel());
               
               console.log(oModel);                                                                                 // its Return a compress file based ODATA Model like T
               console.log(oModel.getMetadata().getName());                                                         // return model name -> sap.ui.model.odata.v4.ODataModel
               console.log(oModel.sServiceUrl);                                                                     // return URl ->Service URl
               
               
            }

        })
    })