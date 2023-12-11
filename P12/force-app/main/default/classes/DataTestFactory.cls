public class DataTestFactory {
    public static List<Account> createAccount(Integer itAcc){
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i<itAcc;i++){
            accounts.add(new Account(name='Account'+i)); 
        }
        return accounts;
    }
    public static List<Contact> createContact(Integer itContact, String email){
        
        List<Contact> contacts = new List<Contact>();
        for(Integer i=0;i<itContact;i++){
            contacts.add(new Contact(LastName='Contact'+i, Email=email));
        }
        return contacts;
    }
    public static List<Contract> createContract(Integer itContract, Id accountId){
        
        List<Contract> contracts = new List<Contract>();
        for(Integer i=0;i<itContract;i++){
            contracts.add(new Contract(AccountId = accountId, Status = 'Draft'));
        }
        return contracts;
    }
}
