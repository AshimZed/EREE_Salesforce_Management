@isTest
private class ObjectTypeHelper_Test {
    
    @TestSetup
    static void makeData(){
        
        Account acc = new Account(
            Name = 'Test Account'
        );
        insert acc;

    }

    @isTest
    private static void getSObjectTypeFromId_Success() {
        // Grab test Account
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        // Grab test Account object type
        Schema.SObjectType accountObjectType = testAccount.getSObjectType();

        // Test getSObjectTypeFromId
        Schema.SObjectType testObjectType = ObjectTypeHelper.getSObjectTypeFromId(testAccount.Id);

        // Ensure the object types are equal
        Assert.isTrue(accountObjectType == testObjectType, 'Object types should be equal');
    }

    @isTest
    private static void getSObjectTypeFromId_NoMatch() {
        // Create an ID that does not exist
        Id testId = '000000000000000000';

        // Test getSObjectTypeFromId
        Schema.SObjectType testObjectType = ObjectTypeHelper.getSObjectTypeFromId(testId);

        // Ensure the object types are equal
        Assert.isTrue(testObjectType == null, 'Object type should be null');
    }

}