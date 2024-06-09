import { LightningElement } from 'lwc';
import isGuest from '@salesforce/user/isGuest';
import { NavigationMixin } from 'lightning/navigation';

export default class RegisterButton extends NavigationMixin(LightningElement) {
    handleRegister() {

        // Redirect the user to the Self Register page
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/SelfRegister'
            }
        });
    }
}