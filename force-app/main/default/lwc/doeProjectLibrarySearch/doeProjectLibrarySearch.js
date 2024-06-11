import { LightningElement, track} from 'lwc';

export default class DoeProjectLibrarySearch extends LightningElement {
    @track searchTerm = '';  // To store the search term entered by the user
    @track selectedColumns = {
        title: true,
        description: true,
        bureau: true,
        programCode: true,
        keyword: true
    };  // To track which columns are selected for display

    // Available columns to display with icons
    allColumns = [
        { label: 'Title', value: 'title'},
        { label: 'Description', value: 'description'},
        { label: 'Bureau', value: 'bureau'},
        { label: 'Program Code', value: 'programCode'},
        { label: 'Keyword(s)', value: 'keyword'}
    ];

    // Handle input change and store the search term
    handleSearch(event) {
        this.searchTerm = event.target.value;  // Update the search term when the user types in the input
    }

    // Emit a custom event with the search term and selected columns when submit button is clicked
    handleSubmit() {
        const searchEvent = new CustomEvent('search', {
            detail: {
                searchTerm: this.searchTerm,
                selectedColumns: this.selectedColumns
            }
        });
       
        this.dispatchEvent(searchEvent);  // Dispatch the custom event
    }

    // Handle toggling a column in the selected columns
    handleToggleColumn(event) {
        const column = event.currentTarget.dataset.id;  // Get the column name from the button data-id
        this.selectedColumns[column] = !this.selectedColumns[column];  // Toggle the selected status of the column
        this.updateColumnVariants();  // Update the variants of the columns
        // Emit the toggle event
        const toggleEvent = new CustomEvent('toggle', {
            detail: {
                selectedColumns: this.selectedColumns
            }
        });
        this.dispatchEvent(toggleEvent);  // Dispatch the custom event
    }

    // Update the variant of each column based on the selected status
    updateColumnVariants() {
        this.allColumns = this.allColumns.map(column => {
            return { ...column, variant: this.selectedColumns[column.value] ? 'brand' : 'neutral' };
        });
    }

    // Initialize the variants of the columns
    connectedCallback() {
        this.updateColumnVariants();
    }
}
