# Patient Summary
### Overview
Patient Summary provides an overview of patient health information to care coordinators as well as care givers. You can search for a patient by name, gender or identifier or choose from a list of all patients. You can retrieve encounters, immunizations, procedures, conditions, allergies or intolerances, medication orders, reports, and observations. The application provides secure access to patient data by providing authentication using OpenID.




### Initial Launch
On initial launch you are provided with an option to search or choose from a list of all patients.


![Initial Launch Screen](/images/InitialScreen.png)




### List of Patients
The list of patients is refreshed as you scroll along the list, this improves the app’s performance and enables the app to scale as more patients are added to the system.


![List of Patients](/images/AllPatientsList.png)




### Home Screen
The home screen gives an overview of the summary items available.


![Home Screen](/images/HomeScreen.png)




### Details
Selecting a summary item such as Conditions shows a list of all conditions for the current patient.




![Details Screen](/images/ConditionsScreen.png)


### Changing The Selected Patient
A new patient can be selected from the app’s menu using the Search or Show All Patients menu items. 




![Menu Screen](/images/MenuScreen.png)








### Settings
The app currently does not support use of passcode or touch ID, however this feature will be added in a future release.




![Settings Screen](/images/SettingsScreen.png)




### Demo
![Settings Screen](/images/demo.gif)


### Security
The app provides login and authentication using a safe and secure Open ID Authorization server. You will need to register for an openID account to login and use the app. The registration can be done on the app or using the registration page at https://service.smarthealthit.org/private/Login




### Patient Data
The app does not store any patient data on the user’s phone. 




### Requirements




To run this app you will need a device running iOS version 7.0 or newer. 




### Feedback.
Please contact me at akshay.bhandary@gmail.com


### Acknowledgements
This app is powered by the open source Swift SMART FHIR framework provided by https://github.com/smart-on-fhir/Swift-FHIR. 



