import { LightningElement } from 'lwc';
import isGuest from '@salesforce/user/isGuest';
import DOE_LOGO from '@salesforce/resourceUrl/doe_logo';

export default class HeaderComponent extends LightningElement {
    logo = DOE_LOGO;

    get isGuest() {
        return isGuest;
    }
}