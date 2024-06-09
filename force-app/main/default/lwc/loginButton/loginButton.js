import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class LoginButton extends NavigationMixin(LightningElement) {
    handleLogin() {

        // Redirect the user to the login page
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/login'
            }
        });
    }
}