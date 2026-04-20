using { sample.db as db } from '../db/schema';


service MyService {
 
  
   entity Employee @(restrict : [
        { grant: ['READ'], to: 'Userss' },
        { grant: ['DELETE'], to: 'Adminss' },
        {}
    ]) as projection on db.Employee; 

// entity Employee as projection on db.Employee; 
   entity Person 
     @(restrict : [
        { grant: ['READ'], to: 'Userss' },
        { grant: ['DELETE'], to: 'Adminss' }

    ])as projection on db.Person;

//   entity Person as projection on db.Person;

}


//Application -> security (Authentication)
//apllication -> Authorization.                ->xsuaa















//shift+alt+p -> align , also assign a role  for service @requires , cockpit process role configure , flow of the url ,how to add ,role and role collection in xs-security.json,Vcap services

//step 1-> Add xsuaa before add the roles in service layer or After put this cmd -> cds compile srv/ -2 xsuaa > xs-seecurity.json. which is update and configure the users in xs-security.json(SCOPE(Authorization),role Elemnets(These become role collections in BTP))
//step 2-> npm i 
//step 3-> add redirect code in xs-security.json.
//step 4-> cds add approuter, which is create a router folder in app layer , and we have configure the authentication method .(THIS is for UI url Autheticated)
//step 5 -> IN ROUTER folders ->add node modules npm install @sap/approuter --prefix.  
//step 7-> deploy the project into cf , before all artifacts deploy to hana
//step 8->deploying error because -> twere is not xsuaa instance for cf-deploy needed.

//step 6->so, create a xsuaa instance , and create a service key and bind and then deploy
//         ->cf cs xsuaa application my_xsuaa -c xs-security.json
//        -> cf csk Xsuaa-auth1 Xsuaa-auth1_key




// step 1:@restrict:[
//    {
//       grant:['READ','CREATE'],
//       to:'user'

//    },
//    {grant:['*']}
// ]

// Xsuaa-auth1 → just the service instance name (container)
// zentra_xsuaa → the real security app ID inside XSUAA