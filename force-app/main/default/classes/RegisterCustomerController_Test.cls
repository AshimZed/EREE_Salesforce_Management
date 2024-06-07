@isTest
private class RegisterCustomerController_Test {
    
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Test Account'
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

    // Test the register user method with valid parameters
    @isTest
    static void testRegisterUser_Success() {
        // Grab the test contact
        Contact testContact = [SELECT Id, Access_Code__c FROM Contact WHERE FirstName = 'Test' LIMIT 1];

        // Assert there are 8 users in the system
        List<User> preTestUsersList = [SELECT Id FROM User];
        Integer preTestUserCount = preTestUsersList.size();

        // Test the register user method
        Test.startTest();
        RegisterCustomerController.registerUser(testContact.Access_Code__c, 'testusername', 'testpassword');
        Test.stopTest();

        // Assert a user has been created
        List<User> postTestUserList = [SELECT Id FROM User];
        Assert.areEqual(preTestUserCount + 1, postTestUserList.size());

        // Assert the contact is related to the user
        User insertedUser = [SELECT Id FROM User WHERE ContactId = :testContact.Id];
        Assert.isNotNull(insertedUser);
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