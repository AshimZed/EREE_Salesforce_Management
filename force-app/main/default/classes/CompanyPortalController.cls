public without sharing class CompanyPortalController {

    // Get the company information for the current user
    @AuraEnabled(cacheable=true)
    public static Account getCompany(String userId) {
        User user = [SELECT Id, ContactId FROM User WHERE Id = :userId LIMIT 1];
        Contact contact = [SELECT Id, AccountId FROM Contact WHERE Id = :user.ContactId LIMIT 1];
        return [SELECT Id, Name, AnnualRevenue, NumberOfEmployees, NAICS_Code__c, Region__c FROM Account WHERE Id = :contact.AccountId LIMIT 1];
    }

    // Get the user information for the current user
    @AuraEnabled(cacheable=true)
    public static User getUser(String userId) {
        return [SELECT Id, Name, Username FROM User WHERE Id = :userId LIMIT 1]; // If you use the username, you must substring to remove everything after the @ symbol
    }

    // Get the application information from the current user
    @AuraEnabled(cacheable=true)
    public static Application__c getApplication(String userId) {
        User user = [SELECT Id, ContactId FROM User WHERE Id = :userId LIMIT 1];
        Contact contact = [SELECT Id, AccountId FROM Contact WHERE Id = :user.ContactId LIMIT 1];
        return [SELECT Id, Name, Additional_Information__c, Annual_Revenue__c, Budget__c, Budget_Justification__c, Business_Contact__c,
                        Confidentiality_Statements__c, FOA__r.Name, Project_Title__c, Public_Release_Abstract__c,
                        Service_End_Date__c, Stage__c, Statement_of_Project_Objective__c, Submission_Date__c,
                        Technical_Contact__c, Technical_Description__c FROM Application__c WHERE Company__c = :contact.AccountId LIMIT 1];
    }

    // Get the list of current notifications for the current user
    @AuraEnabled(cacheable=true)
    public static List<Notification__c> getNotifications(String userId) {
        User user = [SELECT Id, ContactId FROM User WHERE Id = :userId LIMIT 1];
        Contact contact = [SELECT Id, AccountId FROM Contact WHERE Id = :user.ContactId LIMIT 1];
        Application__c application = [SELECT Id FROM Application__c WHERE Company__c = :contact.AccountId LIMIT 1];
        return [SELECT Subject__c, Detail__c, Seen__c, CreatedDate FROM Notification__c WHERE Application__c = :application.Id ORDER BY CreatedDate DESC];
    }

    // Set the notification as seen
    @AuraEnabled
    public static void setNotificationAsSeen(String notificationId) {
        Notification__c notification = [SELECT Id, Seen__c FROM Notification__c WHERE Id = :notificationId LIMIT 1];
        notification.Seen__c = true;
        update notification;
    }

    @AuraEnabled
    public static void updateApplication(Map<String, Object> fields) {
        Id recordId = (Id) fields.remove('Id');
        
        System.debug('Record ID: ' + recordId);
        if (recordId == null) {
            throw new AuraHandledException('Record ID is missing.');
        }
        
        List<Application__c> apps = [SELECT Id FROM Application__c WHERE Id = :recordId LIMIT 1];
        
        
        System.debug('Fetched Application: ' + apps);

        if (apps.isEmpty()) {
            throw new AuraHandledException('No application found with the provided ID.');
        }
        
        Application__c app = apps[0];

        for (String key : fields.keySet()) {
            app.put(key, fields.get(key));
        }
        update app;
    }

    // Method to handle saving of uploaded file - WORKS WITH LWR
    @AuraEnabled
    public static void uploadFile(String fileName, String base64Data, String recordId) {
        try {
            // Create ContentVersion
            ContentVersion contentVersion = new ContentVersion();
            contentVersion.Title = fileName;
            contentVersion.PathOnClient = fileName;
            contentVersion.VersionData = EncodingUtil.base64Decode(base64Data);
            contentVersion.FirstPublishLocationId = recordId;
            insert contentVersion;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Methods to display and delete files to logged in users
    // Fetch files related to a specific record
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getFiles(String recordId) {
        return [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId = :recordId];
    }

    // // Delete a file
    // @AuraEnabled
    // public static void deleteFile(String contentDocumentId) {
    //     List<ContentDocumentLink> linksToDelete = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :contentDocumentId];
    //     delete linksToDelete;

    //     ContentDocument docToDelete = [SELECT Id FROM ContentDocument WHERE Id = :contentDocumentId];
    //     delete docToDelete;
    // }

    @AuraEnabled
    public static void deleteFile(String contentDocumentId) {
    try {
        // Delete all ContentDocumentLink records associated with the ContentDocumentId
        List<ContentDocumentLink> linksToDelete = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :contentDocumentId];
        delete linksToDelete;

        // Delete the ContentDocument record
        ContentDocument docToDelete = [SELECT Id FROM ContentDocument WHERE Id = :contentDocumentId];
        delete docToDelete;
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}

    
}