import { LightningElement, track, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getApplication from '@salesforce/apex/CompanyPortalController.getApplication';
import updateApplication from '@salesforce/apex/CompanyPortalController.updateApplication';

export default class ApplicationStatus extends LightningElement {
    userId = Id;
    @track isEditMode = false;

    @track recordId;
    @track stage;
    @track foa;
    @track budget;
    @track subDate;
    @track projTitle;
    @track publicRelease;
    @track statementObj;
    @track TechDescription;
    @track budgetJustification;
    @track confidentialityStatements;
    @track additionalInfo;

    @wire(getApplication, { userId: '$userId' })
    wiredApplication({ error, data }) {
        if (data) {
            console.log('Fetched application data: ', data);
            this.recordId = data.Id;
            this.stage = data.Stage__c;
            this.foa = data.FOA__r.Name;
            this.budget = data.Budget__c;
            this.subDate = data.Submission_Date__c;
            this.projTitle = data.Project_Title__c;
            this.publicRelease = data.Public_Release_Abstract__c;
            this.statementObj = data.Statement_of_Project_Objective__c;
            this.TechDescription = data.Technical_Description__c;
            this.budgetJustification = data.Budget_Justification__c;
            this.confidentialityStatements = data.Confidentiality_Statements__c;
            this.additionalInfo = data.Additional_Information__c;
        } else if (error) {
            console.error(error);
        }
    }

    handleChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.value;
        console.log(this[field]);
    }

    toggleEditMode() {
        this.isEditMode = !this.isEditMode;
    }

    handleSave() {
        console.log('Record ID before save: ', this.recordId); 
        const fields = {
            Id: this.recordId,
            Project_Title__c: this.projTitle,
            Public_Release_Abstract__c: this.publicRelease,
            Statement_of_Project_Objective__c: this.statementObj,
            Technical_Description__c: this.TechDescription,
            Budget_Justification__c: this.budgetJustification,
            Confidentiality_Statements__c: this.confidentialityStatements,
            Additional_Information__c: this.additionalInfo
        };

        updateApplication({ fields })
            .then(() => {
                console.log('Record updated successfully');
                this.toggleEditMode();
            })
            .catch(error => {
                console.error('Error updating record', error);
            });
    }
}
