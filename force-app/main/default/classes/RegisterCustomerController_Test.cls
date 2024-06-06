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

    @isTest
    static void testRegisterUser_Success() {
        // Grab the test contact
        Contact testContact = [SELECT Id, Access_Code__c FROM Contact WHERE FirstName = 'Test' LIMIT 1];

        // Assert there are 8 users in the system
        List<User> preTestUsersList = [SELECT Id FROM User];
        Assert.areEqual(8, preTestUsersList.size());

        // Test the register user method
        Test.startTest();
        RegisterCustomerController.registerUser(testContact.Access_Code__c, 'testusername', 'testpassword');
        Test.stopTest();

        // Assert a user has been created
        List<User> postTestUserList = [SELECT Id FROM User];
        Assert.areEqual(9, postTestUserList.size());

        // Assert the contact is related to the user
        User insertedUser = [SELECT Id FROM User WHERE ContactId = :testContact.Id];
        Assert.isNotNull(insertedUser);
    }
}