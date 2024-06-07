import { LightningElement } from 'lwc';
import isGuest from '@salesforce/user/isGuest';

export default class LogOutButton extends LightningElement {

    get isGuest() {
        return isGuest;
    }

    handleLogOutClick() {
        // Redirect the user to the login page
        window.location.href = '/secur/logout.jsp';
    }
}