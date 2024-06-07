public without sharing class RegisterCustomerController {

    @AuraEnabled
    public static void registerUser(String accessCode, String userName, String password){
        UserRole userRole;
        User adminUser;

        // Set the user role for the insert
        userRole = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'US_Secretary_of_Energy' LIMIT 1];

        adminUser = [SELECT Id, UserRoleId FROM User WHERE Profile.Name='System Administrator' LIMIT 1];
        if (userRole != null && adminUser != null) {
            adminUser.UserRoleId = userRole.Id;
            update adminUser;
        }

        try {
            
            // Find the contact with the access code
            Contact contact = [SELECT Id, Email, FirstName, LastName, Access_Code__c, Access_Code_Used__c, AccountId FROM Contact WHERE Access_Code__c = :accessCode LIMIT 1];

            // Check if the access code has been used
            if (contact.Access_Code_Used__c){
                throw new AuraHandledException('Access Code already used');
            }

            // Create a new user
            System.runAs(adminUser){
                User user = new User(
                    Username = FormatUsername.formatUsername(userName),
                    FirstName = contact.FirstName,
                    LastName = contact.LastName,
                    ContactId = contact.Id,
                    Email = contact.Email,
                    Alias = contact.FirstName.substring(0, 1) + contact.LastName,
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US',
                    EmailEncodingKey = 'UTF-8',
                    ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community User'].Id
                );
                insert user;

                // Create the user in the community
                Site.createExternalUser(user, contact.AccountId, password);

                // Update the contact
                contact.Access_Code_Used__c = true;
                update contact;
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}