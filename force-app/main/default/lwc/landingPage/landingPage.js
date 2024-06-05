import { LightningElement } from 'lwc';
import HERO_IMAGE from '@salesforce/resourceUrl/windmills';

export default class LandingPage extends LightningElement {
    get heroSectionStyle() {
        return `background-image: url(${HERO_IMAGE}); background-size: cover; height: 500px; position: relative;`;
    }
}
