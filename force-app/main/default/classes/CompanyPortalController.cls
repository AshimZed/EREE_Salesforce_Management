public with sharing class CompanyPortalController {

    @AuraEnabled(cacheable=true)
    public static Account getCompany(String userId) {
        User user = [SELECT Id, ContactId FROM User WHERE Id = :userId];
        Contact contact = [SELECT Id, AccountId FROM Contact WHERE Id = :user.ContactId];
        return [SELECT Id, Name, AnnualRevenue, NumberOfEmployees, NAICS_Code__c, Region__c FROM Account WHERE Id = :contact.AccountId];
    }



}