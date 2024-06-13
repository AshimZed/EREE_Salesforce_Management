import { LightningElement, api, track, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import uploadFile from '@salesforce/apex/CompanyPortalController.uploadFile';
import getApplication from '@salesforce/apex/CompanyPortalController.getApplication';

export default class FileUploadComponentLWR extends LightningElement {
    userId = Id;
    @api recordId;
    @track filesToUpload = [];
    @track disableUpload = true;

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

    handleFilesChange(event) {
        if (event.target.files.length > 0) {
            this.filesToUpload = Array.from(event.target.files);
            this.disableUpload = false;
        } else {
            this.filesToUpload = [];
            this.disableUpload = true;
        }
    }

    handleFileUpload() {
        if (this.filesToUpload.length > 0) {
            this.filesToUpload.forEach(file => {
                const reader = new FileReader();
                reader.onload = () => {
                    const base64 = reader.result.split(',')[1];
                    this.uploadFileToServer(file.name, base64);
                };
                reader.readAsDataURL(file);
            });
        } else {
            this.showCustomToast('Error', 'Please select a file first', 'error');
        }
    }

    uploadFileToServer(fileName, base64Data) {
        uploadFile({ fileName, base64Data, recordId: this.recordId })
            .then(() => {
                console.log('Showing toast: Success File uploaded successfully'); // Debugging line
                this.showCustomToast('Success', 'File uploaded successfully', 'success');
                this.disableUpload = true;
                this.filesToUpload = [];
            })
            .catch(error => {
                console.error('Error uploading file:', error); // Debugging line
                this.showCustomToast('Error', error.body.message, 'error');
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

