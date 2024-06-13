import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id';
import getApplication from '@salesforce/apex/CompanyPortalController.getApplication';
import getFiles from '@salesforce/apex/CompanyPortalController.getFiles';
import deleteFile from '@salesforce/apex/CompanyPortalController.deleteFile';

export default class FileListComponent extends LightningElement {
    userId = Id;
    @api recordId;
    @track files;
    @track isLoading = true;
    @track error;

    @track showToast = false;
    @track toastMessage = '';
    @track toastVariant = '';

    @wire(getApplication, { userId: '$userId' })
    wiredApplication({ error, data }) {
        if (data) {
            this.recordId = data.Id;
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getFiles, { recordId: '$recordId' })
    wiredFiles({ error, data }) {
        console.log('Get Files function ' + data);
        this.isLoading = false;
        if (data) {
            this.files = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.files = undefined;
        }
    }

    handleViewFile(event) {
        const fileId = event.target.dataset.id;
        window.open(`/sfc/servlet.shepherd/document/download/${fileId}`);
    }

handleDeleteFile(event) {
    const contentDocumentId = event.target.dataset.id;
    console.log('Deleting file with ContentDocumentId:', contentDocumentId);
    this.isLoading = true;
    deleteFile({ contentDocumentId })
        .then(() => {
            this.showCustomToast('Success', 'File deleted successfully', 'success');
            return refreshApex(this.wiredFiles);
        })
        .catch(error => {
            console.error('Error deleting file:', error); // Debugging line
            this.showCustomToast('Error deleting file', error.body.message, 'error');
            this.isLoading = false;
        });
}

    showCustomToast(title, message, variant) {
        this.toastMessage = `${title}: ${message}`;
        this.toastVariant = variant;
        this.showToast = true;

        // Automatically close toast after 3 seconds
        setTimeout(() => {
            this.showToast = false;
        }, 3000);
    }

    closeToast() {
        this.showToast = false;
    }
}
