@RestResource(urlMapping='/Contact/*')
global with sharing class ContactApi {
    @HttpPost
    /*global static String doPost(String lastname,
        String phone) {
        Contact contact = new Contact();
        contact.LastName = lastname;
        contact.phone = phone;
        insert contact;
        return contact.Id;
    }*/
    
    global static Map<String,String> createContact(String lastname, String firstname, String phone,
        String email) {
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');

        List<Contact> contactList = [SELECT Id, Email FROM Contact WHERE Email =:email];
		Map<String, String> contactIdMap = null;
         system.debug('id contact'+contactList);
            system.debug('size'+contactList.size());
            system.debug('email'+email);

		if(contactList.size() == 0){
        	try{
            
               Contact contact = new Contact(
                	LastName = lastname,
                    FirstName = firstname,
                    Phone = phone,
                    Email = email
                );
                insert contact;
                system.debug('insert id'+contact.id);
                
                contactIdMap = new Map<String, String>{
                    'Contact Id ' => contact.id,
                     'Test' => 'test'
                };
                res.responseBody = Blob.valueOf(JSON.serialize(contactIdMap));
                
            	res.statusCode = 200;
            }
            catch(Exception e){
                res.responseBody = Blob.valueOf(e.getMessage());
                System.debug('error post'+e.getMessage());
           	    res.statusCode = 500;
            }
                
        }            
        else{
            try{
                for(Integer i=0; i<contactList.size();i++){
                     contactIdMap = new Map<String, String>{
                        'Contact Id ' => contactList[i].Id,
                         'Email' => contactList[i].Email
                    };
                }
                res.responseBody = Blob.valueOf(JSON.serialize(contactIdMap));
            	res.statusCode = 200;

            }
            catch(Exception e){
                res.responseBody = Blob.valueOf(e.getMessage());
           	    res.statusCode = 500;
            }
               
        }
        system.debug('id 1'+contactIdMap.get('Contact Id'));
		return contactIdMap;
    }   
    @HttpDelete
    global static void deleteContact() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id, Desactivated__c FROM Contact WHERE Id = :contactId];
        thisContact.Desactivated__c = true;
        update thisContact;
    }     
    
    @HttpPatch
    global static void updateContact() {
       RestResponse res = RestContext.response;
       res.addHeader('Content-Type', 'application/json');
	   
       try{
            RestRequest request = RestContext.request;
            String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
            system.debug('idco'+contactId); 
            Contact thisContact = [SELECT Id, Email FROM Contact WHERE Id = :contactId];
            // Deserialize the JSON string into name-value pairs
            system.debug('req'+request.requestbody.tostring());
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
            // Iterate through each parameter field and value
          //// system.debug('map'+params); 
          system.debug('parammap'+params.keySet());
           for(String fieldName : params.keySet()) {
                // Set the field and value on the Case sObject
              thisContact.put(fieldName, params.get(fieldName));
           }
            update thisContact;
        
           res.responseBody = Blob.valueOf(JSON.serialize(params));
           res.statusCode = 200;

       		
       }
        catch(Exception e){
                res.responseBody = Blob.valueOf('error update : '+e.getMessage());
           	    res.statusCode = 500;
        }     
    }
}