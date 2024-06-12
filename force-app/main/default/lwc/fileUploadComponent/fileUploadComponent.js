import { LightningElement, api } from 'lwc';

export default class FileUploadComponent extends LightningElement {
    @api recordId;
    acceptedFormats = ['.pdf', '.png', '.jpg', '.doc', '.docx'];
    console.log(``)

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        console.log('Uploaded files:', uploadedFiles);

        // Optional: Display a toast or further process the files
        uploadedFiles.forEach(file => {
            console.log('File uploaded:', file.name, file.documentId);
        });
    }
}