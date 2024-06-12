import { LightningElement, wire } from 'lwc';
import getApplication from '@salesforce/apex/CompanyPortalController.getApplication';
import Id from '@salesforce/user/Id';

export default class StatusPathComponent extends LightningElement {
    userId = Id;
    stages = [
        { label: 'Concept Paper', value: 'Concept Paper', selected: false, class: 'slds-path__item', tabindex: -1 },
        { label: 'Full Application', value: 'Full Application', selected: false, class: 'slds-path__item', tabindex: -1 },
        { label: 'Selection Stage', value: 'Selection', selected: false, class: 'slds-path__item', tabindex: -1 },
        { label: 'Negotiation', value: 'Negotiation', selected: false, class: 'slds-path__item', tabindex: -1 },
        { label: 'Project Performance', value: 'Project Performance', selected: false, class: 'slds-path__item', tabindex: -1 }
    ];
    currentStage;
    currentStageLabel;

    @wire(getApplication, { userId: '$userId' })
    wiredApplications({ error, data }) {
        if (data) {
            this.currentStage = data.Stage__c;
            this.updateStages();
        } else if (error) {
            console.error(error);
        }
    }

    updateStages() {
        let foundCurrentStage = false;
        this.stages = this.stages.map(stage => {
            let stageClass = 'slds-path__item';
            if (stage.value === this.currentStage) {
                stageClass += ' slds-is-current slds-is-active';
                stage.selected = true;
                stage.tabindex = 0;
                foundCurrentStage = true;
            } else {
                stage.selected = false;
                stage.tabindex = -1;
                if (foundCurrentStage) {
                    stageClass += ' slds-is-incomplete';
                } else {
                    stageClass += ' slds-is-complete';
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
