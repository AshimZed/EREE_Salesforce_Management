import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import loginUser from '@salesforce/apex/LoginCustomerController.loginUser';

export default class LoginCustomerPortalUser extends NavigationMixin(LightningElement) {

    disableButton = true; // Controls if the button can be pressed

    userName;
    password;

    // Listen for changes and apply them to the properties
    userNameChanged(event) {
        this.userName = event.detail.value;
        this.checkFields();
    }

    passwordChanged(event) {
        this.password = event.detail.value;
        this.checkFields();
    }

    // Check if the button should be allowed to be pressed
    checkFields() {
        // Ensure the fields are not empty
        if (this.userName && this.password) {
            this.disableButton = false;
        } else {
            this.disableButton = true;
        }
    }

    // Handle Login Button
    async handleLoginClick(event) {
        
        // Prevent default click event action from running
        event.preventDefault();

        
        // Await the promise returned by the loginUser call
        const result = await loginUser({
            userName: this.userName, 
            password: this.password
        }).then((result) => {
            // Handle the result of the loginUser call
            console.log('Login successful:', result);
            window.location.href = result;
        })
        .catch((error) => {
            // Handle any errors that occur during the loginUser call
            console.error('Login failed:', error.body.message);
        });
    }
}