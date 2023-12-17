@RestResource(urlMapping='/Contract/*')
global with sharing class ContractApi {
    @HttpPost
    global static Map<String,String> createContract(String accountid, String status) {
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');

		Map<String, String> contractIdMap = null;
		try{
            contract contract = new contract(
            AccountId = accountid,
            Status = status
           // StartDate = startdate,
            //ContractTerm = term
            );
            insert contract;
	    contract.ExternalId__c = 'Ext'+contract.id;
            update contract;
            system.debug('insert id'+contract.id);
                
            contractIdMap = new Map<String, String>{
            'contract Id ' => contract.id,
            'account id' => contract.AccountId
             };
             res.responseBody = Blob.valueOf(JSON.serialize(contractIdMap));
                
             res.statusCode = 200;
            }
            catch(Exception e){
                res.responseBody = Blob.valueOf(e.getMessage());
                System.debug('error post'+e.getMessage());
           	    res.statusCode = 500;
            }
        system.debug('id 1'+contractIdMap.get('contract Id'));
		return contractIdMap;
    }   
    
    @HttpPatch
    global static String updatecontract() {
       RestResponse res = RestContext.response;
       res.addHeader('Content-Type', 'application/json');
	   String contractId = null;
       try{
            RestRequest request = RestContext.request;
            contractId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
            system.debug('idco'+contractId); 
            contract thiscontract = [SELECT Id FROM Contract WHERE Id = :contractId];
            // Deserialize the JSON string into name-value pairs
            system.debug('req'+request.requestbody.tostring());
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
            // Iterate through each parameter field and value
          //// system.debug('map'+params); 
          system.debug('parammap'+params.keySet());
           for(String fieldName : params.keySet()) {
                // Set the field and value on the Case sObject
               thiscontract.put(fieldName, params.get(fieldName));
           }
           update thiscontract;
        
           res.responseBody = Blob.valueOf(JSON.serialize(params));
           res.statusCode = 200;

       		
       }
        catch(Exception e){
                res.responseBody = Blob.valueOf('error update : '+e.getMessage());
           	    res.statusCode = 500;
        } 
        return contractId;
    }
}
