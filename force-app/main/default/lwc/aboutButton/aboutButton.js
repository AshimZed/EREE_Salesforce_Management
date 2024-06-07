import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class AboutButton extends NavigationMixin(LightningElement) {
    redirectToAbout() {

        // Redirect the user to the About page
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://www.energy.gov/eere/about-office-energy-efficiency-and-renewable-energy'
            }
        },
        true
        );
    }
}