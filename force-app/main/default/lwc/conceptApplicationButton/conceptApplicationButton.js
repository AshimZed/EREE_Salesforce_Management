import { LightningElement } from 'lwc';
import webToLead from "@salesforce/resourceUrl/web_to_lead_styled";

export default class ConceptApplicationButton extends LightningElement {

    handleClick(){
        window.open(webToLead, '_blank');
    }
}