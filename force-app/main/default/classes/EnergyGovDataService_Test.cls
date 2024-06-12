@IsTest
public class EnergyGovDataService_Test {
    // Mock HTTP Response Generator for a successful response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            String jsonResponse = '[{"title":"Project A","description":"Description A","theme":["Theme A"],"bureauCode":["Bureau A"],"programCode":["Program A"],"keyword":["Keyword A"]}, {"title":"Project B","description":"Description B","theme":["Theme B"],"bureauCode":["Bureau B"],"programCode":["Program B"],"keyword":["Keyword B"]}]';
            res.setBody(jsonResponse);
            return res;
        }
    }

    @IsTest
    static void testGetEnergyProjects() {
        // Set up the mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method to be tested
        List<Map<String, Object>> projects = EnergyGovDataService.getEnergyProjects();

        // Verify the results
        System.assertNotEquals(null, projects, 'Projects list should not be null');
        System.assertEquals(2, projects.size(), 'Projects list size should be 2');

        Map<String, Object> projectA = projects[0];
        System.assertEquals('Project A', projectA.get('title'), 'Project A title should be "Project A"');
        System.assertEquals('Description A', projectA.get('description'), 'Project A description should be "Description A"');
        System.assertEquals('Theme A', projectA.get('theme'), 'Project A theme should be "Theme A"');
        System.assertEquals('Bureau A', projectA.get('bureau'), 'Project A bureau should be "Bureau A"');
        System.assertEquals('Program A', projectA.get('programCode'), 'Project A program code should be "Program A"');
        System.assertEquals('Keyword a', projectA.get('keyword'), 'Project A keyword should be "Keyword A"');

        Map<String, Object> projectB = projects[1];
        System.assertEquals('Project B', projectB.get('title'), 'Project B title should be "Project B"');
        System.assertEquals('Description B', projectB.get('description'), 'Project B description should be "Description B"');
        System.assertEquals('Theme B', projectB.get('theme'), 'Project B theme should be "Theme B"');
        System.assertEquals('Bureau B', projectB.get('bureau'), 'Project B bureau should be "Bureau B"');
        System.assertEquals('Program B', projectB.get('programCode'), 'Project B program code should be "Program B"');
        System.assertEquals('Keyword b', projectB.get('keyword'), 'Project B keyword should be "Keyword B"');
    }

    @IsTest
    static void testCapitalizeFirstLetter() {
        // Test the utility method
        System.assertEquals('Test', EnergyGovDataService.capitalizeFirstLetter('test'), 'First letter should be capitalized');
        System.assertEquals('Test', EnergyGovDataService.capitalizeFirstLetter('Test'), 'First letter should remain capitalized');
        System.assertEquals(null, EnergyGovDataService.capitalizeFirstLetter(null), 'Null input should return null');
        System.assertEquals('', EnergyGovDataService.capitalizeFirstLetter(''), 'Empty input should return empty string');
    }
}
