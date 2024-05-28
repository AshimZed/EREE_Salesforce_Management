@isTest
private class ForceLookupFields_Test {
    
    @TestSetup
    static void makeData(){
        
        Account acc = new Account(
            Name = 'Test Account'
        );
        insert acc;

        Opportunity opp = new Opportunity(
            Name      = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );
        insert opp;

    }

    @isTest
    private static void ForceLookup_Success() {
        // Grab test data
        Account testAccount         = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Opportunity testOpportunity = [SELECT Id, AccountId FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];

        // Set up inputs
        List<ForceLookupFields.Input> inputs = new List<ForceLookupFields.Input>();
        ForceLookupFields.Input input        = new ForceLookupFields.Input();
        input.childId           = testOpportunity.Id;
        input.relationshipField = 'AccountId';
        input.parentObjectAPI   = 'Account';
        input.parentKnownField  = 'Name';
        input.parentKnownValue  = 'Test Account';
        inputs.add(input);

        // Check current relationship
        Assert.isNull(testOpportunity.AccountId, 'Opportunity should not have an Account linked');

        // Run test
        Test.startTest();
        ForceLookupFields.ForceLookup(inputs);
        Test.stopTest();

        // Re-query the Opportunity for the updated opportunity
        testOpportunity = [SELECT Id, AccountId FROM Opportunity WHERE Id = :testOpportunity.Id LIMIT 1];

        // Check that the Opportunity has an Account linked and that the Account is the est Account
        Assert.isNotNull(testOpportunity.AccountId, 'Opportunity should have an Account linked');
        Assert.isTrue(testOpportunity.AccountId == testAccount.Id, 'Opportunity should be linked to the test Account');
    }

    @isTest
    private static void ForceLookup_NoMatch() {
        // Grab test data
        Account testAccount         = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Opportunity testOpportunity = [SELECT Id, AccountId FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];

        // Set up inputs
        List<ForceLookupFields.Input> inputs = new List<ForceLookupFields.Input>();
        ForceLookupFields.Input input        = new ForceLookupFields.Input();
        input.childId           = testOpportunity.Id;
        input.relationshipField = 'AccountId';
        input.parentObjectAPI   = 'Account';
        input.parentKnownField  = 'Name';
        input.parentKnownValue  = 'No Account Has This Name';
        inputs.add(input);

        // Check current relationship
        Assert.isNull(testOpportunity.AccountId, 'Opportunity should not have an Account linked');

        // Run test
        Test.startTest();
        ForceLookupFields.ForceLookup(inputs);
        Test.stopTest();

        // Re-query the Opportunity for the updated opportunity
        testOpportunity = [SELECT Id, AccountId FROM Opportunity WHERE Id = :testOpportunity.Id LIMIT 1];

        // Check that the Opportunity has an Account linked and that the Account is the est Account
        Assert.isNull(testOpportunity.AccountId, 'Opportunity should not have an Account linked');
        Assert.isTrue(testOpportunity.AccountId != testAccount.Id, 'Opportunity should not be linked to the test Account');
    }
}