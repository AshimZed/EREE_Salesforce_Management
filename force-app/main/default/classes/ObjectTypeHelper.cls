public class ObjectTypeHelper {

    // Static map to cache the prefix to SObject type mappings
    // Improves perfomance by storing the mappings in memory and allow for O(1)-lookup
    private static Map<String, Schema.SObjectType> prefixToSObjectTypeMap;

    static {
        prefixToSObjectTypeMap = new Map<String, Schema.SObjectType>();
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        for (Schema.SObjectType sObjectType : globalDescribe.values()) {
            String prefix = sObjectType.getDescribe().getKeyPrefix();
            if (prefix != null) {
                prefixToSObjectTypeMap.put(prefix, sObjectType);
            }
        }
    }

    public static Schema.SObjectType getSObjectTypeFromId(Id recordId) {
        // Extract the prefix from the record ID
        String prefix = recordId.toString().substring(0, 3);

        // Retrieve the SObject type from the cached map
        return prefixToSObjectTypeMap.get(prefix);
    }
}