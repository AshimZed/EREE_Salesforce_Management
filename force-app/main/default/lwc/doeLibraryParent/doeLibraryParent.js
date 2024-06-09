import { LightningElement, track } from 'lwc';

export default class DoeLibraryParent extends LightningElement {
    @track searchTerm = '';  // To store the search term
    @track selectedColumns = {
        title: true,
        description: true,
        bureau: true,
        programCode: true,
        keyword: true
    };  // To store the selected columns

    // Handle the search event and update the search term and selected columns
    handleSearch(event) {
        this.searchTerm = event.detail.searchTerm;  // Update the search term
        this.selectedColumns = event.detail.selectedColumns;  // Update the selected columns
    }

    // Handle the toggle event and update the selected columns
    handleToggle(event) {
        this.selectedColumns = event.detail.selectedColumns;  // Update the selected columns
    }
}
