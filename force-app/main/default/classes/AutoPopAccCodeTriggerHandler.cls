public with sharing class AutoPopAccCodeTriggerHandler {
    public static void generateAccessCodeField(List<Contact> contacts) {
        // Collect the IDs of the contacts to update
        Set<Id> contactIdsToUpdate = new Set<Id>();
        for (Contact con : contacts) {
            if (con.Access_Code__c == null) {
                contactIdsToUpdate.add(con.Id);
            }
        }

        // Query the contacts to update them
        List<Contact> contactsToUpdate = [SELECT Id, Access_Code__c FROM Contact WHERE Id IN :contactIdsToUpdate];
        for (Contact con : contactsToUpdate) {
            // Convert the Id to String and extract the last 8 characters
            String contactIdString = String.valueOf(con.Id);
            String last8Chars = contactIdString.substring(contactIdString.length() - 8);
            con.Access_Code__c = last8Chars;
        }

        // Update the contacts
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}
