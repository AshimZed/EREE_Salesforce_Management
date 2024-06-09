import { LightningElement } from 'lwc';
import isGuest from '@salesforce/user/isGuest';
import { NavigationMixin } from 'lightning/navigation';

export default class LogOutButton extends NavigationMixin(LightningElement) {

    get isGuest() {
        return isGuest;
    }

    handleLogOut() {
        // Log out the user 
        window.location.href = 'https://skillstorm-8d-dev-ed.develop.my.site.com/secur/logout.jsp';
    }
}