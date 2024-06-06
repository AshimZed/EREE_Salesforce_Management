@isTest
private class FormatUsername_Test {
    
    @isTest
    static void testFormatUsername() {
        // Test the format username method
        String username = FormatUsername.formatUsername('Testusername');
        System.assertEquals('Testusername@sfafsproject2.username', username);
    }
}