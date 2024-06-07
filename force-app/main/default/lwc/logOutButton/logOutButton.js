import { LightningElement } from 'lwc';
import isGuest from '@salesforce/user/isGuest';
import { NavigationMixin } from 'lightning/navigation';

export default class LogOutButton extends NavigationMixin(LightningElement) {

    get isGuest() {
        return isGuest;
    }

    handleLogOut() {

        // Redirect the user to the login page
        this[NavigationMixin.Navigate]({
            type: 'comm__logoutPage',
            attributes: {
                url: '/secur/logout.jsp'
            }
        });
    }
}