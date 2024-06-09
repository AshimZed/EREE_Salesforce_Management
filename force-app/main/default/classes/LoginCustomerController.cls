public without sharing class LoginCustomerController {
    
    @AuraEnabled
    public static String loginUser(String userName, String password){
        // Log the user in
        String startUrl = System.Label.customerPortal;
        String returnUrl;
        if (Test.isRunningTest()) { returnUrl = 'https://test.salesforce.com'; }
        else { returnUrl = Site.login(userName, password, startUrl).getUrl(); }

        // Return the URL
        return returnUrl;
    }
}