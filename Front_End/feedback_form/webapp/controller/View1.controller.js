sap.ui.define([
    "sap/ui/core/mvc/Controller",
     "sap/ui/model/json/JSONModel",
     "sap/m/MessageToast",
       "sap/m/MessageBox"
], (Controller, JSONModel,MessageToast,MessageBox) => {
    "use strict";

    return Controller.extend("formns.feedbackform.controller.View1", {
        onInit() {

        },


        onLanguageChange(event) 
        {
            let lang = event.getSource().getSelectedKey();                                                               //fetch the key 
            console.log(lang);

            sap.ui.getCore().getConfiguration().setLanguage(lang);                                                        //Set a default language
            const res = this.getOwnerComponent().getModel("i18n").getResourceBundle().getText("labelName");
            console.log(res);

        },

        onSubmit(){
            var models = this.getOwnerComponent().getModel("models").getData();                                          //it contain a lot of properties , access dot.
              console.log(models);

            var form =models.form;
              console.log(form);

              var missing=[]

             for(let prop in form)
                {
                    if(form[prop]===null || form[prop]===undefined|| form[prop]==="")
                    {
                        missing.push(prop)
                    }
                } 
                

                if(missing.length===0){                                                                                 //array is always return a truthy value.
                        let mail =form.email;
                        console.log(mail);
                        
                        if(mail.endsWith(".com"))
                        {
                          var feed = models.feedbackList;       //both are fetching
                          var total= models.total

                          feed.push(form);                 //push in array

                          total = feed.length;               // total array value in total
                          console.log(total);
                          

                          let reeForm={
                               name: "",
                               email: "",
                               subject: "",
                               message: ""
                          }

                          this.getOwnerComponent().getModel("models").setProperty("/form",reeForm);
                          this.getOwnerComponent().getModel("models").setProperty("/total",total);

                          MessageBox.show("Feedback Submitted Successfully");

                        }
                        else
                        {
                            MessageBox.error("Sorry! Mail Id is not Correct")
                        }
                }
                else{
                    MessageBox.error("Sorry! Please Fill these feilds :" + missing.join(", "))
                  
                }
               },

               onReset(){
                MessageBox.confirm("You Want Reset");
               }
    });
});


// not allow -> expression binding   //"{= 'Sorry Please fill These Feilds :' + ${missing}")

//Note
/* Use missing.join(", ") -> its like a iterate an array and join the with comma and space Eg : see above
  mail.endsWith("mail.com")
  if(arr)

*/