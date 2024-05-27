public class ForceLookupFields {
    
    public class Input {

        @InvocableVariable(label='Child ID')
        public Id childId;

        @InvocableVariable(label='Child-to-Parent Field')
        public String relationshipField;

        @InvocableVariable(label='Parent Object Name')
        public String parentObjectAPI;

        @InvocableVariable(label='Parent Field Name')
        public String parentKnownField;

        @InvocableVariable(label='Parent Field Value')
        public String parentKnownValue;

    }

    @InvocableMethod(label='Force Lookup Field')
    public static void ForceLookup(List<Input> inputs) {
        // Create list of objects to update
        List<SObject> objectsToUpdate = new List<SObject>();

        // Loop through each input
        for (Input input : inputs) {

            // Build parent query
            String parentQuery = 'SELECT Id FROM ' + String.escapeSingleQuotes(input.parentObjectAPI);
            parentQuery       += ' WHERE ' + String.escapeSingleQuotes(input.parentKnownField) + ' = \'' + input.parentKnownValue;
            parentQuery       += '\' LIMIT 1';

            // Query for the parent object
            List<SObject> parentObjects = Database.query(parentQuery);
            
            if (parentObjects.isEmpty()) { continue; }

            SObject parentObject = parentObjects[0];

            // Get child object type
            Schema.SObjectType childObjectType = ObjectTypeHelper.getSObjectTypeFromId(input.childId);

            // Build child query
            String childQuery = 'SELECT Id FROM ' + childObjectType + ' WHERE Id = \'' + input.childId;
            childQuery       += '\' LIMIT 1';

            // Query for the child object
            SObject childObject = Database.query(childQuery);

            // Set relationship
            childObject.put(input.relationshipField, parentObject.Id);

            // Add the child object to update list
            objectsToUpdate.add(childObject);

        }

        if (!objectsToUpdate.isEmpty()) {
            update objectsToUpdate;
        }
        
    }
}