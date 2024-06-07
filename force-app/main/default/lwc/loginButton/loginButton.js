import { LightningElement } from 'lwc';
import isGuest from '@salesforce/user/isGuest';
import { NavigationMixin } from 'lightning/navigation';

export default class LoginButton extends NavigationMixin(LightningElement) {

    get isGuest() {
        return isGuest;
    }

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