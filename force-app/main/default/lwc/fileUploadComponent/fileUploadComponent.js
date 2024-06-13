import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import setGuestRecordFileUpload from '@salesforce/apex/CompanyPortalController.setGuestRecordFileUpload';

export default class FileUploadComponent extends LightningElement {
    @api relatedRecordId;

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        const documentIds = uploadedFiles.map(file => file.documentId);
        

        // Call Apex to set Guest_Record_fileupload__c
        setGuestRecordFileUpload({ contentVersionIds: documentIds, relatedRecordId: this.relatedRecordId })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Files uploaded and linked successfully.',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
                console.error('Error linking files:', error);
            });
    }
}
