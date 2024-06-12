import { LightningElement, track, wire } from 'lwc';
import getApplication from '@salesforce/apex/CompanyPortalController.getApplication';

export default class StatusPathComponent extends LightningElement {
    @track applications;
    @track stages = [
        { label: 'Concept Paper', value: 'Concept Paper' },
        { label: 'Full Application', value: 'Full Application' },
        { label: 'Unqualified', value: 'Unqualified' },
        { label: 'Nurturing', value: 'Nurturing' },
        { label: 'Closed', value: 'Closed' }
    ];
    @track currentStage;
    @track currentStageLabel;

    @wire(getApplication)
    wiredApplications({ error, data }) {
        if (data) {
            this.applications = data;
            if (this.applications.length > 0) {
                this.currentStage = this.applications[0].Stage__c; // Assume using the first application's stage for this example
                this.updateStages();
            }
        } else if (error) {
            console.error(error);
        }
    }

    handleStageClick(event) {
        this.currentStage = event.currentTarget.dataset.id;
        this.updateStages();
        console.log('Stage clicked: ', this.currentStage);
    }

    updateStages() {
        this.stages = this.stages.map(stage => {
            let stageClass = 'slds-path__item';
            if (stage.value === this.currentStage) {
                stageClass += ' slds-is-current slds-is-active';
                stage.selected = true;
                stage.tabindex = 0;
            } else {
                stage.selected = false;
                stage.tabindex = -1;
                if (this.stages.findIndex(s => s.value === this.currentStage) > this.stages.findIndex(s => s.value === stage.value)) {
                    stageClass += ' slds-is-complete';
                } else {
                    stageClass += ' slds-is-incomplete';
                }
            }
            return {
                ...stage,
                class: stageClass
            };
        });
        this.currentStageLabel = this.stages.find(stage => stage.value === this.currentStage)?.label;
    }

    get stagesWithClass() {
        return this.stages.map(stage => {
            return {
                ...stage,
                class: this.getPathClass(stage.value)
            };
        });
    }

    markComplete() {
        console.log('Marking current stage as complete');
        // Here you can add your logic to mark the stage as complete, e.g., update the backend
    }

    getPathClass(stageValue) {
        let pathClass = 'slds-path__item';
        if (stageValue === this.currentStage) {
            pathClass += ' slds-is-current slds-is-active';
        } else if (this.stages.findIndex(stage => stage.value === this.currentStage) > this.stages.findIndex(stage => stage.value === stageValue)) {
            pathClass += ' slds-is-complete';
        } else {
            pathClass += ' slds-is-incomplete';
        }
        return pathClass;
    }
}
