@isTest
private class LoginCustomerController_Test {

    @isTest 
    static void testLoginCustomer_Success() {

        // Set up inputs
        String userName = 'testusername';
        String password = 'password1234';

        // Test the login user method in user mode
        String testReturn = LoginCustomerController.loginUser(userName, password);

        // Verify the return value
        Assert.areEqual('https://test.salesforce.com', testReturn);
    }

}