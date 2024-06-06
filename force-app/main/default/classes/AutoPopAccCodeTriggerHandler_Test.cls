@isTest
public class AutoPopAccCodeTriggerHandler_Test {
    @isTest
    static void testContactAutoPopulate() {
        // Start the test context
        Test.startTest();

        // Create a new Contact record
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'User'
        );

        // Insert the Contact record
        insert testContact;

        // End the test context
        Test.stopTest();

        // Retrieve the Contact record from the database
        Contact insertedContact = [SELECT Id, Access_Code__c FROM Contact WHERE Id = :testContact.Id];

        // Convert the Id to String and verify that the custom field is populated with the last 8 characters of the Contact ID
        String contactIdString = String.valueOf(insertedContact.Id);
        String expectedLast8Chars = contactIdString.substring(10, 18);
        System.assertEquals(expectedLast8Chars, insertedContact.Access_Code__c, 'The custom field should be populated with the last 8 characters of the Contact ID.');
    }
}
