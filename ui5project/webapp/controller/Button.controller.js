sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel"
], (Controller, JSONModel) => {
    "use strict";

    return Controller.extend("ui5project.controller.App", {

        // 1. Runs first when controller + view initialize
        onInit() {
            console.log("1. onInit executed");

            var oData = {
                name: "Vishnu"
            };

            var oModel = new JSONModel(oData);

            this.getView().setModel(oModel);
        },

        // 2. Runs before UI renders on browser
        onBeforeRendering() {
            console.log("2. onBeforeRendering executed controller");
        },

        // 3. Runs after UI is visible on browser
        onAfterRendering() {
            console.log("3. onAfterRendering executed controller");
        },

        // Runs when user clicks button
        onPress() {

            console.log("4. onPress executed");

            let b1=this.byId("b1");               // access the controls
            b1.setText("Hello");             

            let input1=this.byId("input1");
            input1.setValue("Ramila")


            var data = this.getView()
                .getModel()
                .setProperty("/name", "Siva");                //changing the json 

            let button = this.byId("b1");

            button.addEventDelegate({
                onInit() {
                    console.log("Ima OnInit");

                },
                onBeforeRendering() {
                    console.log("Im a onBeforeRendering button");
                },
                onAfterRendering() {
                    console.log("Im a onAfterRendering button");
                }
            })

            let input = this.byId("input1")
            //    input.setValue("SivaControl");
            console.log(input);

            input.addEventDelegate({
                onInit() {
                    console.log("Ima OnInit");

                },
                onBeforeRendering() {
                    console.log("Im a onBeforeRendering input");
                },
                onAfterRendering() {
                    console.log("Im a onAfterRendering input");
                }
            })

            input.invalidate();
            this.getView().invalidate();
        },
        onPress2() {
            console.log("im a onPress2");

            this.getOwnerComponent().getRouter().navTo("JsonModelDataBinding");

        },

        onPress3() {
              this.getOwnerComponent().getRouter().navTo("OdataModelDataBinding")
        },

        // Runs when view/controller destroyed
        onExit() {
            console.log("5. onExit executed");
        }

    });
});

//"sap/ui/core/mvc/Controller"    
// 1.Its a Base controller class , which contain a Inbuild method like getOwnerComponent() ,getRouter() , getModel() getView() .byId()
//




/*
LifeCycle Methods:
1.onInit  -> which will run automatically when the controller is loading.
2.onBeforeRendering -> which will run before the view is rendering.
3.onAfterRendering  -> which will run after the view is rendering.
4.onExit            -> which will run when the controller is destoryed.

*/



/*
Flow:
INITAILLY LOADING:

whwnever the application is loading , it will follow the below flow:
1.App start
2.view load
3.Contaroller Load 
4.oninit() run 
5.Ui5 convert the view to html and render it to the browser                        !!! the Browser cant undertsand the xml
   onBeforeRendering()          -> which will run before the view is rendering.
6.Rendering happens
    onAfterRendering()
7.Waiting for User Interaction 
    Event() function execute if user interacts  ->                        and return a Object to the UI5 framework       !!!
8.Finally the Event is next page or close the tab 
    that time the new page is created . so , that time it loads again . before that onExit is run
    onExit()
*/



