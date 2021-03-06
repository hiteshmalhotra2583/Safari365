trigger lead_onConvert on Lead (after update) {

    Map<String,  Lead_History__c> map_Opportunity2LeadHistory = new Map<String,  Lead_History__c>();
    for (Lead newLead : Trigger.New) {
        
        Lead oldLead = Trigger.oldMap.get(newLead.Id);
        System.debug('lead Information>>>'+oldLead);
        if(!oldLead.IsConverted && newLead.isConverted){
            Lead_History__c leadHistory = new Lead_History__c();
            leadHistory.Name = oldLead.FirstName + ' ' + oldLead.LastName;
            leadHistory.Absolute_luxury__c=oldLead.Absolute_luxury__c;
            leadHistory.Activate_Workflow__c = oldLead.Activate_Workflow__c;
            leadHistory.Active_and_adventure_tours__c=oldLead.Active_and_adventure_tours__c;
            leadHistory.Activities__c=oldLead.Activities__c;
            leadHistory.Adventure__c=oldLead.Adventure__c;
            leadHistory.Adventure_activities__c=oldLead.Adventure_activities__c;
            leadHistory.Agent__c=oldLead.Agent__c;
            leadHistory.Ages_of_Children__c=oldLead.Ages_of_Children__c;
            leadHistory.Arrival_Date__c=oldLead.Arrival_Date__c;
            leadHistory.Basket_Information__c=oldLead.Basket_Information__c;
            leadHistory.Beach_and_bush_safaris__c=oldLead.Beach_and_bush_safaris__c;
            leadHistory.Beach_relaxation__c=oldLead.Beach_relaxation__c;
            leadHistory.Botswana__c=oldLead.Botswana__c;
            leadHistory.Browser_Trial__c=oldLead.Browser_Trial__c;
            leadHistory.Budget_or_Star_Rating__c=oldLead.Budget_or_Star_Rating__c;
            leadHistory.Budget_safaris__c=oldLead.Budget_safaris__c;
            leadHistory.Budget_Total__c=oldLead.Budget_Total__c;
            leadHistory.Canoe_Safari__c=oldLead.Canoe_Safari__c;
            leadHistory.Cape_Town_SA__c=oldLead.Cape_Town_SA__c;
           // leadHistory.City__c=oldLead.City__c;
            leadHistory.Client_Comments__c=oldLead.Client_Comments__c;
            leadHistory.Climbing_Kilimanjaro__c=oldLead.Climbing_Kilimanjaro__c;
            leadHistory.Comments__c=oldLead.Comments__c;
            leadHistory.Company__c=oldLead.Company;
            leadHistory.Consultant_Profile__c=oldLead.Consultant_Profile__c;
            leadHistory.Consultanthasreplied__c=oldLead.Consultanthasreplied__c;
            leadHistory.Contact_Method__c=oldLead.Contact_Method__c;
            leadHistory.ConvertMe__c=oldLead.ConvertMe__c;
            leadHistory.Country_of_residence__c=oldLead.New_Country_of_residence__c;
            leadHistory.Culture_and_history__c=oldLead.Culture_and_history__c;
            leadHistory.Currency__c=oldLead.Currency__c;
            leadHistory.Customer_has_Replied__c=oldLead.Customer_has_Replied__c;
          //  leadHistory.Data_Quality_Description__c=oldLead.Data_Quality_Description__c;
           // leadHistory.Data_Quality_Score__c=oldLead.Data_Quality_Score__c;
            leadHistory.Destinations__c=oldLead.Destinations__c;
            leadHistory.Do_not_remind_me__c=oldLead.Do_not_remind_me__c;
            leadHistory.Duration__c=oldLead.Duration__c;
            leadHistory.Email__c=oldLead.Email;
            leadHistory.Enquiry_item__c=oldLead.Enquiry_item__c;
            leadHistory.Enquiry_Ref_No__c=oldLead.Enquiry_Ref_No__c;
            leadHistory.Lead_Nurture__c=oldLead.Lead_Nurture__c;
            leadHistory.Family_Friendly__c=oldLead.Family_Friendly__c;
            leadHistory.Family_safaris__c=oldLead.Family_safaris__c;
            leadHistory.FirstName__c=oldLead.FirstName;
            leadHistory.Fishing_adventures__c=oldLead.Fishing_adventures__c;
            leadHistory.Fly_In_safaris__c=oldLead.Fly_In_safaris__c;
            leadHistory.Food_and_Wine__c=oldLead.Food_and_Wine__c;
            leadHistory.Garden_Route_SA__c=oldLead.Garden_Route_SA__c;
            leadHistory.Golf_combination_holidays__c=oldLead.Golf_combination_holidays__c;
            leadHistory.Gorilla_Trekking__c=oldLead.Gorilla_Trekking__c;
            leadHistory.Hiking__c=oldLead.Hiking__c;
            leadHistory.History_and_culture__c=oldLead.History_and_culture__c;
            leadHistory.Honeymoons_and_Romance__c=oldLead.Honeymoons_and_Romance__c;
            leadHistory.Hot_air_ballooning__c=oldLead.Hot_air_ballooning__c;
            leadHistory.Internal_Comments__c=oldLead.Internal_Comments__c;
            leadHistory.International_Flight_Required__c=oldLead.International_Flight_Required__c;
            leadHistory.IP_Address__c=oldLead.IP_Address__c;
            leadHistory.Kenya__c=oldLead.Kenya__c;
            leadHistory.Kenyan_beaches__c=oldLead.Kenyan_beaches__c;
            leadHistory.Kruger_National_Park_SA__c=oldLead.Kruger_National_Park_SA__c;
            leadHistory.Kwa_Zulu_Natal_SA__c=oldLead.Kwa_Zulu_Natal_SA__c;
            leadHistory.LastName__c=oldLead.LastName;
            leadHistory.Lead_Age__c=oldLead.LeadAge__c;
            leadHistory.Lead_Cost__c=oldLead.Lead_Cost__c;
            leadHistory.Other__c=oldLead.Other__c;
            leadHistory.Other_Kenyan_National_Reserves__c=oldLead.Other_Kenyan_National_Reserves__c;
            leadHistory.Other_Tanzania_National_Parks__c=oldLead.Other_Tanzania_National_Parks__c;
            leadHistory.Phone__c=oldLead.Phone;
            //leadHistory.Rating__c=oldLead.Rating__c;
            leadHistory.Referral_Client_s_Name__c=oldLead.Referral_Client_s_Name__c;
            leadHistory.Roughing_it__c=oldLead.Roughing_it__c;
            leadHistory.Rwanda__c=oldLead.Rwanda__c;
            //leadHistory.Salutation__c=oldLead.Salutation__c;
            leadHistory.Scheduled_escorted_tours__c=oldLead.Scheduled_escorted_tours__c;
            leadHistory.Self_drive_tours__c=oldLead.Self_drive_tours__c;
            leadHistory.Serengeti_National_Park__c=oldLead.Serengeti_National_Park__c;
            leadHistory.Shark_cage_diving__c=oldLead.Shark_cage_diving__c;
            leadHistory.South_Africa__c =oldLead.South_Africa__c ;
            leadHistory.Spa_and_rejuvenation__c=oldLead.Spa_and_rejuvenation__c;
            leadHistory.Standard__c=oldLead.Standard__c;
            leadHistory.Supplier__c=oldLead.Supplier__c;
            leadHistory.Tanzania__c=oldLead.Tanzania__c;
            leadHistory.The_Great_Migration__c=oldLead.The_Great_Migration__c;
            leadHistory.Total_Participants__c=oldLead.Total_Participents__c;
            leadHistory.Travel_Date_Options__c=oldLead.Travel_Date_Options__c;
            leadHistory.Uganda__c=oldLead.Uganda__c;
            leadHistory.Unqualified_Reason__c=oldLead.Unqualified_Reason__c;
            leadHistory.Value__c=oldLead.Value__c;
            leadHistory.Victoria_Falls__c=oldLead.Victoria_Falls__c;
            leadHistory.Walking_Safaris__c=oldLead.Walking_Safaris__c;
            leadHistory.Website_origin__c=oldLead.Website_origin__c;
            leadHistory.Whale_watching__c=oldLead.Whale_watching__c;
            leadHistory.Wildlife_Safaris__c=oldLead.Wildlife_Safaris__c;
            leadHistory.Zambia__c=oldLead.Zambia__c;
            leadHistory.Zanzibar_and_Pemba__c=oldLead.Zanzibar_and_Pemba__c;            
            map_Opportunity2LeadHistory.put(newLead.convertedOpportunityId, leadHistory);
        }
        
    }
    insert map_Opportunity2LeadHistory.values();
    List<Opportunity> lst_Opportunity = new List<Opportunity>();
    for(String var : map_Opportunity2LeadHistory.keyset()){
        lst_Opportunity.add(new Opportunity(Id=var, Lead_History__c= map_Opportunity2LeadHistory.get(var).Id,Basket_Information__c=map_Opportunity2LeadHistory.get(var).Basket_Information__c));
    }
    
    if (lst_Opportunity.size() > 0) {
        update lst_Opportunity;
    }
    
}