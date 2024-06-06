public without sharing class RegisterCustomerController {

    @AuraEnabled
    public static void registerUser(String accessCode, String userName, String password){
        try {
            
            // Find the contact with the access code
            Contact contact = [SELECT Id, Email, FirstName, LastName, Access_Code__c, AccountId FROM Contact WHERE Access_Code__c = :accessCode LIMIT 1];
            if(contact == null){
                throw new AuraHandledException('Invalid Access Code');
            }

            // Create a new user
            User user = new User(
                Username = FormatUsername.formatUsername(userName),
                ContactId = contact.Id,
                Email = contact.Email,
                Alias = contact.FirstName.substring(0, 1) + contact.LastName.substring(0, 1),
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community User'].Id
            );
            insert user;

            // Create the user in the community
            Site.createExternalUser(user, contact.AccountId, password);

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}