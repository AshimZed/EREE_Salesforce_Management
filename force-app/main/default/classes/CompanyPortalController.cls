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

    @AuraEnabled
    public static void updateApplication(Map<String, Object> fields) {
        Id recordId = (Id) fields.remove('Id');
        
        // Add debug statement
        System.debug('Record ID: ' + recordId);
        if (recordId == null) {
            throw new AuraHandledException('Record ID is missing.');
        }
        
        List<Application__c> apps = [SELECT Id FROM Application__c WHERE Id = :recordId LIMIT 1];
        
        // Add debug statement
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

}