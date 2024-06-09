public without sharing class RegisterCustomerController {

    @AuraEnabled
    public static String registerUser(String accessCode, String userName, String password){

        try {
            
            // Find the contact with the access code
            Contact contact = [SELECT Id, Email, FirstName, LastName, Access_Code__c, Access_Code_Used__c, AccountId FROM Contact WHERE Access_Code__c = :accessCode LIMIT 1];

            // Check if the access code has been used
            if (contact.Access_Code_Used__c){
                throw new AuraHandledException('Access Code already used');
            }

            // Create a new user
            User u = new User();
            u.Username = FormatUsername.formatUsername(userName);
            u.CommunityNickname = userName;
            u.FirstName = contact.FirstName;
            u.LastName = contact.LastName;
            u.ContactId = contact.Id;
            u.Email = contact.Email;
            u.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community User'].Id;

            // Create the user in the community
            String portalId = Site.createExternalUser(u, contact.AccountId, password);

            // Update the contact
            if (portalId != null) {
                contact.Access_Code_Used__c = true;
                update contact;
            }

            // Log the user in
            String startUrl = System.Label.customerPortal;
            ApexPages.PageReference pageRef = Site.login(
                FormatUsername.formatUsername(userName), 
                password, 
                startUrl
            );

            // Return the URL
            return pageRef.getUrl();

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}