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

}