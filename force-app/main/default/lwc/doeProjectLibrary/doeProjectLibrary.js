import { LightningElement, track, api, wire } from 'lwc';
import getEnergyProjects from '@salesforce/apex/EnergyGovDataService.getEnergyProjects';

export default class DoeProjectLibrary extends LightningElement {
    @track energyProjects = [];  // To store the fetched energy projects
    @track filteredProjects = [];  // To store the filtered projects based on search term
    @track error;  // To store any error messages

    @api searchTerm = '';  // To store the search term
    @api selectedColumns = {
        title: true,
        description: true,
        bureau: true,
        programCode: true,
        keyword: true
    };  // To store the selected columns

    // Define all available columns with initial pixel widths
    allColumns = [
        { label: 'Title', fieldName: 'title' },
        { label: 'Description', fieldName: 'description'},
        { label: 'Bureau', fieldName: 'bureau', initialWidth: 100 },  // Adjusted initial width for Bureau
        { label: 'Program Code', fieldName: 'programCode', initialWidth: 140 },  // Adjusted initial width for Program Code
        { label: 'Keyword(s)', fieldName: 'keyword'}
    ];

    // Fetch energy projects from Apex
    @wire(getEnergyProjects)
    wiredEnergyProjects({ error, data }) {
        if (data) {
            this.energyProjects = data;  // Store the fetched data
            this.filterProjects();  // Filter the projects based on the search term
            this.error = undefined;
        } else if (error) {
            this.error = error;  // Store the error message
            this.energyProjects = undefined;
        }
    }

    // Filter projects based on the search term
    filterProjects() {
        if (this.searchTerm) {
            // Filter projects that contain the search term in any of their fields
            this.filteredProjects = this.energyProjects.filter(project => {
                return Object.values(project).some(value =>
                    value.toString().toLowerCase().includes(this.searchTerm.toLowerCase())
                );
            });
        } else {
            this.filteredProjects = this.energyProjects;  // If no search term, display all projects
        }
    }

    // Getter to determine if there are no projects to display
    get noProjects() {
        return this.filteredProjects.length === 0;
    }

    // Compute dynamic columns based on selected columns
    get dynamicColumns() {
        return this.allColumns.filter(column => this.selectedColumns[column.fieldName]);
    }

    // React to changes in selected columns
    @api
    setSelectedColumns(columns) {
        this.selectedColumns = columns;
        this.updateColumns();
    }

    // React to changes in search term
    @api
    setSearchTerm(term) {
        this.searchTerm = term;
        this.filterProjects();
    }

    // Update the columns to display based on selected columns
    updateColumns() {
        this.filteredProjects = [...this.filteredProjects];  // Force re-render
    }

    // React to changes in search term and selected columns
    connectedCallback() {
        this.filterProjects();
    }
}
