import registerUser from '@salesforce/apex/RegisterCustomerController.registerUser';
import { LightningElement, wire } from 'lwc';

export default class RegisterCustomerPortalUser extends LightningElement {

    disableButton = true; // Controls if the button can be pressed

    // Set up properties for registration fields
    accessCode;
    userName;
    password;

    // Listen for changes and apply them to the properties
    accessCodeChanged(event) {
        this.accessCode = event.detail.value;
        this.checkFields();
    }

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
        if (this.accessCode && this.userName && this.password) {
            this.disableButton = false;
        } else {
            this.disableButton = true;
        }
    }

    // Handle Register Button
    async handleRegisterClick(event) {
        
        // Prevent default click event action from running
        event.preventDefault();

        try {
            // Await the promise returned by the registerUser call
            const result = await registerUser({
                accessCode: this.accessCode, 
                userName: this.userName, 
                password: this.password
            });

            // Redirect the user to the login page
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: '/login'
                }
            });
            
            console.log('Registration successful:', result);
        } catch (error) {
            // Handle any errors that occur during the registerUser call
            console.error('Registration failed:', error);
        }

        console.log(`Access Code: ${this.accessCode}\nUsername: ${this.userName}\nPassword: ${this.password}`);

    }

    // Handle Existing User Button
    handleExisterUserClick(event) {

        // Prevent default click event action from running
        event.preventDefault();

        console.log('Existing User Button Pushed! Redirect User!');
    }

}