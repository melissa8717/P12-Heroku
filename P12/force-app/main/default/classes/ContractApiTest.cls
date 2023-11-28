@isTest
    public class ContractApiTest {
    @testSetup
    	static void setup(){
    
            List<Account> accList = DataTestFactory.createAccount(1);
            insert accList;
            Id accId = accList[0].Id;
            
            List<Contract> contractList = DataTestFactory.createContract(1,accId );
            insert contractList;
        
    	}	
    @isTest static void testCreateContract() {
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://ocrooms-dev-ed.develop.my.salesforce.com/services/data/v59.0/sobjects/Contract/'; //Request URL
        req.httpMethod = 'POST';
    
        RestContext.request = req;
        RestContext.response= res;
    
        Test.startTest();

        Map<String,String> contractMap = ContractApi.createContract('0012o00003OAt2iAAD', 'draft');
        
        String actual =  RestContext.response.responseBody.toString();	
        List<Contract>contractList = [SELECT Id FROM Contract];
        Test.stopTest();
    
        Assert.areNotEqual(null,contractList[0].id);
        Assert.areNotEqual(null, (String)contractMap.get('Contract Id'));
    }
    
     @isTest static void testUpdateContract() {
		
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        List<Contract>contractList = [SELECT Id FROM Contract];
        Id recordId = contractList[0].id;
         
        RestRequest request = new RestRequest();
        request.requestUri =
         'https://ocrooms-dev-ed.develop.my.salesforce.com/services/data/v59.0/sobjects/Contract/'
         + recordId;
        request.httpMethod = 'PATCH';
        //request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"ContractTerm": 12}');
        RestContext.request = request;
        RestContext.response= res;
               
        Test.startTest();
        
        String thisContractId = ContractApi.updateContract();
        
        Test.stopTest();

        List<Contract> thisContract = [SELECT Id,ContractTerm FROM Contract WHERE Id=:recordId];
        Assert.areEqual(12,thisContract[0].ContractTerm );
    } 
}
