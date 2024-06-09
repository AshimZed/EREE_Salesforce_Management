import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class LogOutButton extends NavigationMixin(LightningElement) {
    handleLogOut() {
        // Log out the user 
        window.location.href = 'https://skillstorm-8d-dev-ed.develop.my.site.com/secur/logout.jsp';
    }
}