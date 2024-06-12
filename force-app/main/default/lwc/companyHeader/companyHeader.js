import { LightningElement, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getCompany from '@salesforce/apex/CompanyPortalController.getCompany';
import getUser from '@salesforce/apex/CompanyPortalController.getUser';

export default class CompanyHeader extends LightningElement {

    userId = Id;
    user;
    userName;
    company;
    companyName;

    @wire(getUser, { userId: '$userId' })
    wiredUser({ error, data }) {
        if (data) {
            this.user = data;
            this.userName = this.user.Name;
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getCompany, { userId: '$userId' })
    wiredCompany({ error, data }) {
        if (data) {
            this.company = data;
            this.companyName = this.company.Name;
        } else if (error) {
            console.error(error);
        }
    }
}