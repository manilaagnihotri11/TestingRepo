@isTest(SeeAllData=false)
public class LPL_Onetime_Region_Contact_Batch_Test {

    @testSetup
    public static void testDataSetup() {
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = true;
        insert tbp;
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();
        List<Contact> conList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        Account acc = new Account(Name='Test Account');
        insert acc;
        system.debug('Hi');
        for(Integer i=1;i<=5;i++){
            conList.add(new Contact(LastName='Test'+i,Discovery_Home_Zip__c='100'+i,MailingPostalCode='200'+i,recordTypeId=conRecordTypeId));
        }
        system.debug('Hello world');
        insert conList;
        for(Integer i=1;i<=5;i++){
            for(Integer j=1;j<=2;j++){
                oppList.add(new Opportunity(Name='TestOpp'+j,Account=acc,StageName='1 - Unscreened Contact',Probability=10,CloseDate=System.today(),Contact__c=conList[i-1].Id));
            }
        }
        insert oppList;
        System.debug('Opp List '+oppList);
        List<IAS_Recruiter_Assignment__c> iasList = new List<IAS_Recruiter_Assignment__c>();
        for(Integer i=1;i<=3;i++){
            iasList.add(new IAS_Recruiter_Assignment__c(Name='100'+i,Region__c='Central'));
        }
        insert iasList;
    }
    
    public static testmethod void getResult(){
        Test.startTest();
        LPL_Onetime_Region_Contact_Batch bc = new LPL_Onetime_Region_Contact_Batch();
        Database.executeBatch(bc,200);
        Test.stopTest();
        Opportunity o = [Select id,region__c from Opportunity order by createddate limit 1];
        IAS_Recruiter_Assignment__c ias = [Select id,region__c from IAS_Recruiter_Assignment__c order by createddate limit 1];
        System.assertEquals(ias.Region__c, o.Region__c);
    }
    
}