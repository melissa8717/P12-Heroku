public class DataTestFactory {
    public static List<Contact> createContact(Integer itContact){
        
        List<Contact> contacts = new List<Contact>();
        for(Integer i=0;i<itContact;i++){
            contacts.add(new Contact(LastName='Contact'+i));
        }
        return contacts;
    }
}
