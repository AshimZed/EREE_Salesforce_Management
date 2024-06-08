public with sharing class EnergyGovDataService {
    // Base URL for the energy.gov API
    // private static final String BASE_URL = 'https://www.energy.gov/sites/default/files/2024-04/pdl040124_0.json';
    private static final String BASE_URL = 'https://ed-skillstorm.appiancloud.com/suite/webapi/articles';
    
    public EnergyGovDataService() {}

    // Energy Project class - convert JSON to an object
    public class EnergyProject {
        public String title;
        public String description;
        public List<String> theme;
        public List<String> bureauCode;
        public List<String> programCode;
        public List<String> keyword;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getEnergyProjects() {
        // List to store the result
        List<Map<String, Object>> results = new List<Map<String, Object>>();
        
        try {
            // Create Http Request
            HttpRequest req = new HttpRequest();
            req.setMethod('GET'); // Set the HTTP method to GET
            // req.setEndpoint(BASE_URL); // Endpoint to fetch energy projects from
            
            // referencing the created named credentials
            req.setEndPoint('callout:Energy_Gov_Projects_Appian_Endpoint/suite/webapi/articles');

            // Create a new Http object and HttpResponse object
            Http http = new Http();
            HttpResponse res = http.send(req); // Send the request and return a response

            // Log status code for debugging
            System.debug('Response Status Code: ' + res.getStatusCode());

            // Check if the response status code is 200 (OK)
            if (res.getStatusCode() == 200) {
                // Deserialize the response body into a list of EnergyProject objects
                List<EnergyProject> projects = (List<EnergyProject>) JSON.deserialize(res.getBody(), List<EnergyProject>.class);

                // Convert each EnergyProject object into a Map and add to results
                for (EnergyProject project : projects) {
                    Map<String, Object> projectMap = new Map<String, Object>();
                    projectMap.put('title', project.title);
                    projectMap.put('description', project.description);
                    projectMap.put('theme', (project.theme != null && project.theme.size() > 0) ? project.theme[0] : '');
                    projectMap.put('bureau', (project.bureauCode != null && project.bureauCode.size() > 0) ? project.bureauCode[0] : '');
                    projectMap.put('programCode', (project.programCode != null && project.programCode.size() > 0) ? project.programCode[0] : '');
                    // capitalize starting letter of each keyword using utility method
                    if (project.keyword != null && project.keyword.size() > 0) {
                        List<String> capitalizedKeywords = new List<String>();
                        for (String keyword : project.keyword) {
                            capitalizedKeywords.add(capitalizeFirstLetter(keyword));
                        }
                        projectMap.put('keyword', String.join(capitalizedKeywords, ', '));
                    } else {
                        projectMap.put('keyword', '');
                    }
                    results.add(projectMap);
                }
            } else {
                // Handle non-200 status codes
                System.debug('Failed to retrieve data: ' + res.getStatus());
                System.debug('Response Body: ' + res.getBody());
            }
        } catch (Exception e) {
            // Handle general exceptions
            System.debug('An error occurred: ' + e.getMessage());
        }   
        // Return the result
        System.debug(results);
        return results;
    }

     // Utility method to capitalize the first letter of each word
    public static String capitalizeFirstLetter(String input) {
        if (input == null || String.isEmpty(input)) {
            return input;
        }
        return input.substring(0, 1).toUpperCase() + input.substring(1).toLowerCase();
    }
}
