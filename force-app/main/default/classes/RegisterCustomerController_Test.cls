@isTest
private class RegisterCustomerController_Test {
    
    @TestSetup
    static void makeData(){

        // Create a role
        UserRole userRole = new UserRole(Name = 'Test Role');
        insert userRole;

        // Create an account owner with a role
        User accountOwner = new User(Alias = 'accown', Email='accountowner@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Owner', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='accountowner' + DateTime.now().getTime() + '@testorg.com',
            UserRoleId = userRole.Id);
        insert accountOwner;

        System.runAs(accountOwner) {
            // Create an account
            Account acc = new Account(
                Name = 'Test Account',
                OwnerId = accountOwner.Id
            );
            insert acc;

            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Email = 'test@example.com',
                AccountId = acc.Id
            );
            insert testContact;
        }
    }

    // Test the register user method with valid parameters
    @isTest
    static void testRegisterUser_Success() {
        // Grab the test contact
        Contact testContact = [SELECT Id, Access_Code__c FROM Contact WHERE FirstName = 'Test' LIMIT 1];

        // Test the register user method in user mode
        Profile p = [SELECT Id FROM Profile WHERE Name='Minimum Access - Salesforce'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='standarduser' + DateTime.now().getTime() + '@testorg.com');

        String testUrl;
        System.runAs(u) {
            // Test the register user method
            Test.startTest();
            testUrl = RegisterCustomerController.registerUser(testContact.Access_Code__c, 'testusername', 'password1234');
            Test.stopTest();
        }
        
        // Grab the test contact
        Contact postTestContact = [SELECT Id, Access_Code_Used__c FROM Contact WHERE FirstName = 'Test' LIMIT 1];
        Assert.areEqual(true, postTestContact.Access_Code_Used__c);
        Assert.areEqual(testUrl, 'https://test.salesforce.com');
    }

    // Test the register user method with an invalid access code
    @isTest
    static void testRegisterUser_InvalidAccessCode() {
        
        // Test the register user method
        Test.startTest();
        try {
            RegisterCustomerController.registerUser('invalidaccesscode', 'testusername', 'testpassword');
            Assert.fail('Expected an exception');
        } catch (Exception e) {
            Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    // Test the register user method with an access code that has already been used
    @isTest
    static void testRegisterUser_AccessCodeAlreadyUsed() {
        // Grab the test contact
        Contact testContact = [SELECT Id, Access_Code__c FROM Contact WHERE FirstName = 'Test' LIMIT 1];

        // Set the access code as used
        testContact.Access_Code_Used__c = true;
        update testContact;

        // Test the register user method in user mode
        Profile p = [SELECT Id FROM Profile WHERE Name='Minimum Access - Salesforce'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='standarduser' + DateTime.now().getTime() + '@testorg.com');

        System.runAs(u) {

        Test.startTest();
            try {
                RegisterCustomerController.registerUser(testContact.Access_Code__c, 'testusername', 'testpassword');
                Assert.fail('Expected an exception');
            } catch (Exception e) {
                Assert.areEqual('Script-thrown exception', e.getMessage());
            }
            Test.stopTest();
        }
    }
}