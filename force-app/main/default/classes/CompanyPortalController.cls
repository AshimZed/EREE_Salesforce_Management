public with sharing class CompanyPortalController {

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

}