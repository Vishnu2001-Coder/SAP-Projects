sap.ui.define(["sap/ui/core/mvc/Controller", "sap/ui/model/json/JSONModel"],
  async function (Controller, JSONModel) {
    return Controller.extend("ui5project.controller.DataBinding", {
      onInit() {
        let oModel = new JSONModel();
        let data = {
          name: "Vishnud",
          age: "24"
        }

        oModel.setData(data);

        this.getView().setModel(oModel);
        // ------------------------------------------------------------- one way , two way , one time

        let studentModel = {
          Students: [
            {
              name: "Vishnus",
              age: "24"
            },
            {
              name: "Siva",
              age: "25"
            },
            {
              name: "Ram",
              age: "26"

            },
            {
              name: "Abdul",
              age: "27"
            },
            {
              name: "Lokesh",
              age: "28"
            },
            {
              name: "Murugan",
              age: "29"

            }
          ]
        }

        let oStudentModel = new JSONModel(studentModel);
        this.getView().setModel(oStudentModel,"StudentModel");
        this.getOwnerComponent().setModel()

        var studata = this.getView().getModel("StudentModel").getData();                                     //return a whole data 
        console.log(studata);
        //------------------------------------------------------------------------// Table Binding


        let table = {
          students: [
            {
              id: 101,
              name: "VishnuT",
              age: 24,
              city: "Chennai"
            },
            {
              id: 102,
              name: "Siva",
              age: 25,
              city: "Madurai"
            }
          ]
        }

        let oTableModel = new JSONModel(table);                       // converting
        this.getView().setModel(oTableModel,"TableDatas")             //attaching the model to the view 

        var tabData=this.getView().getModel("TableDatas");
        console.log(tabData);                                        //return a constuctor for that Object -> odata -> students we can see the data

        console.log(this.getView().oModels)                          // return the whole models

        console.log(Object.keys(this.getView().oModels))

        console.log( this.getOwnerComponent().getModel());
        
      }

    })
  })