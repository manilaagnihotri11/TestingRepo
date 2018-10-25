global class LPL_Onetime_Region_Contact_Batch implements Database.Batchable<sObject> {
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query='select Id, name,Region__c,Contact__c from Opportunity where (RecordType.Name=\'IAS Business Development\') AND Contact__c!=\'\' AND Contact__c In (Select id from Contact where  Discovery_Home_Zip__c!=null)';
               return database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<Opportunity> OppUpdateList) 
    { 
        Set<ID> conid = new  Set<ID>();
        Map<ID, Contact> prospConMap = new Map<Id, Contact>(); 
        set<string> zips = new set<string>();
        Map<String, IAS_Recruiter_Assignment__c > zipMap= new Map <String, IAS_Recruiter_Assignment__c >();
        List<Opportunity>opplist=new List<Opportunity>();
        for(Opportunity OppObj : OppUpdateList){
            conid.add(OppObj.Contact__c);
        }
        for(Contact cons:[Select id,Discovery_Home_Zip__c from contact where Discovery_Home_Zip__c != null and ID in:conid]){
            prospConMap.put(cons.id,cons);
            zips.add(cons.Discovery_Home_Zip__c);
        }
        for(IAS_Recruiter_Assignment__c ias :  [Select Name,region__c  
                                                from IAS_Recruiter_Assignment__c
                                                where name in :zips] ){ 
                                                    zipMap.put(ias.name,ias); 
                                                }
        
        for(Opportunity opp :OppUpdateList){  
            if(opp.Contact__c!=null){
              
						                    
                    if(prospConMap.size()>0 && prospConMap.get(opp.Contact__c) != null && prospConMap.get(opp.Contact__c).Discovery_Home_Zip__c != null){
                       String homezip=prospConMap.get(opp.Contact__c).Discovery_Home_Zip__c;
                        System.debug('homezip>>'+homezip);
                        if(homezip!=''&& zipMap.get(homezip) !=null){
                           System.debug('IRD region >>'+zipMap.get(homezip).region__c);
                            Opp.Region__c= zipMap.get(homezip).region__c;
                            opplist.add(Opp);
                            
                        }
                      
                    }
           }
       }
        
         if(opplist !=null && opplist.size()>0){
                System.debug('opplist>>'+opplist);
            update opplist;
           
        }
    }
        global void finish(Database.BatchableContext BC){
        }
    }