import { LightningElement, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getUser from '@salesforce/apex/CompanyPortalController.getUser';
import getCompany from '@salesforce/apex/CompanyPortalController.getCompany';

export default class UserAndCompanyInfo extends LightningElement {

    userId = Id;
    name;
    userName;
    company;
    companyName;
    annualRevenue;
    numberOfEmployees;
    industry;
    region;

    @wire(getUser , {userId: '$userId'})
    wiredUser({error, data}) {
        if(data) {
            this.name = data.Name;
            this.userName = data.Username.substring(0, data.Username.indexOf('@'));
        } else if(error) {
            console.error(error);
        }
    }

    @wire(getCompany , {userId: '$userId'})
    wiredCompany({error, data}) {
        if(data) {
            this.company = data;
            this.companyName = this.company.Name;
            this.annualRevenue = this.company.AnnualRevenue;
            this.numberOfEmployees = this.company.NumberOfEmployees;
            this.industry = this.company.NAICS_Code__c;
            this.region = this.company.Region__c;
        } else if(error) {
            console.error(error);
        }
    }
            

}