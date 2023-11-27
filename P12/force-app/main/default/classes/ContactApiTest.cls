@isTest
    public class ContactApiTest {
        // prepare test-data
    @isTest static void testCreateContact() {
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://ocrooms-dev-ed.develop.my.salesforce.com/services/data/v59.0/sobjects/Contact/'; //Request URL
        req.httpMethod = 'POST';
    
        RestContext.request = req;
        RestContext.response= res;
    
        Test.startTest();

        Map<String,String> contactMap = ContactApi.createContact('test last name', 'test first name', '01.02.03.04.05', 'test@email.fr');
        List<Contact> contactList = DataTestFactory.createContact(1);
        insert contactList;
        String actual =  RestContext.response.responseBody.toString();	

        Test.stopTest();
    
        Assert.areNotEqual(null,contactList[0].id);
        //Assert.areNotEqual(null, actual.get('Contact Id'));
    }

     @isTest static void testEmailExisting() {
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://ocrooms-dev-ed.develop.my.salesforce.com/services/data/v59.0/sobjects/Contact/'; //Request URL
        req.httpMethod = 'POST';
    
        RestContext.request = req;
        RestContext.response = res;
		Id contactId = null; 
        Test.startTest();
		Map<String,String> contactMap = ContactApi.createContact('test last name', 
                                                                 'test first name', 
                                                                 '01.02.03.04.05',
                                                                 'test@email.fr');
        List<Contact> contactList = DataTestFactory.createContact(1, 'test@mail.com');
        insert contactList;
        
        String actual =  RestContext.response.responseBody.toString();	
        for(Integer i = 0; i<contactList.size();i++){
          if(contactList[i].Email == 'test@mail.com'){
              contactId = contactList[i].id;
        	}
        }       
        Test.stopTest();
    	
        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(res.responseBody.toString());

        Assert.areNotEqual(null, contactId);
        Assert.areEqual(contactList[0].Email,'test@mail.com');
        Assert.areEqual(200, res.statusCode);
    }
     @isTest static void testDeleteContact() {
        List<Contact> contactList = DataTestFactory.createContact(1);
        insert contactList;
        Id recordId = contactList[0].id;
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://ocrooms-dev-ed.develop.my.salesforce.com/services/data/v59.0/sobjects/Contact/'
            + recordId;
        RestContext.request = request;
        Test.startTest();

        ContactApi.deleteContact();
        List<Contact> contacts = [SELECT Id,Desactivated__c FROM Contact WHERE Id=:recordId];
        contacts[0].Desactivated__c = true;
        update contacts;
        
        Test.stopTest();

        Assert.areEqual(1,contacts.size());
        Assert.areEqual(true,contacts[0].Desactivated__c);
    }
     @isTest static void testUpdateContact() {
		
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        List<Contact> contactList = DataTestFactory.createContact(1);
        insert contactList;
        Id recordId = contactList[0].id;
        RestRequest request = new RestRequest();
        request.requestUri =
         'https://ocrooms-dev-ed.develop.my.salesforce.com/services/data/v59.0/sobjects/Contact/'
         + recordId;
        request.httpMethod = 'PATCH';
        //request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Phone": "01.02.03.04.55"}');
        RestContext.request = request;
        RestContext.response= res;
               
        Test.startTest();
        
        String thisContactId = ContactApi.updateContact();
        
        Test.stopTest();

        //Assert.areNotEqual(null, thisContactId);
        List<Contact> thisContact = [SELECT Id,Phone FROM Contact WHERE Id=:recordId];
        Assert.areEqual( '01.02.03.04.55',thisContact[0].Phone);
    } 
}