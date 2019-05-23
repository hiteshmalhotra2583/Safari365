<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Autoresponse_China</fullName>
        <description>Autoresponse China</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Leads/Safari_365_Auto_Response_China</template>
    </alerts>
    <alerts>
        <fullName>Competition_Entry_Lead</fullName>
        <description>Competition Entry - Lead</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Competition_Reply_Templates/Competition_Lead_10_Year_Thank_you_for_entering_Icontact</template>
    </alerts>
    <alerts>
        <fullName>Competition_Entry_Lead_DE</fullName>
        <description>Competition Entry - Lead DE</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Competition_Reply_Templates_DE/Competition_10_Year_Thank_youleadDE</template>
    </alerts>
    <alerts>
        <fullName>Competition_Entry_Lead_PT</fullName>
        <description>Competition Entry - Lead PT</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Competition_Reply_Templates_PT/Competition_Lead_10_Year_Thank_you_for_entering_PT_2</template>
    </alerts>
    <alerts>
        <fullName>Competition_Entry_New_Referral_Lead_Ceated_Offer_to_enter_Competition</fullName>
        <description>Competition Entry - New Referral Lead Ceated_ Offer to enter Competition</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Competition_Reply_Templates/Competition_10_Year_Referral_Entrant_IContact</template>
    </alerts>
    <alerts>
        <fullName>Competition_Entry_New_Referral_Lead_Ceated_Offer_to_enter_Competition_DE</fullName>
        <description>Competition Entry - New Referral Lead Ceated_ Offer to enter Competition DE</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Competition_Reply_Templates_DE/Competition_10_Year_Referral_EntrantDE</template>
    </alerts>
    <alerts>
        <fullName>Competition_Entry_New_Referral_Lead_Ceated_Offer_to_enter_Competition_PT</fullName>
        <description>Competition Entry - New Referral Lead Ceated_ Offer to enter Competition PT</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Competition_Reply_Templates_PT/Competition_10_Year_Referral_Entrant_pt</template>
    </alerts>
    <alerts>
        <fullName>INternal_Lead_Assignement_Consultant_has_recieved_a_new_lead</fullName>
        <description>INternal Lead Assignement: Consultant has recieved a new lead</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Leads/LeadsNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Members_Club_Intro_to_New_Lead_Manually_Brazil_social_media_phone_referral</fullName>
        <description>Members Club Intro to New Lead Manually Brazil (social media, phone, referral)</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>infobr@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Brazil/Safari_365_manuallycreate_Brazil</template>
    </alerts>
    <alerts>
        <fullName>Members_Club_Intro_to_New_Lead_Manually_social_media_phone_referral</fullName>
        <description>Members Club Intro to New Lead Manually (social media, phone, referral)</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/Safari_365_Auto_Response_with_vide</template>
    </alerts>
    <alerts>
        <fullName>Non_Respnse_after_2_days_Safari365</fullName>
        <description>Consulting: Non Respnse after 2 days Safari365</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Leads/Safari365_Non_Response</template>
    </alerts>
    <alerts>
        <fullName>Non_Respnse_after_2_days_SaouthAfrica365</fullName>
        <description>Consulting: Non Respnse after 2 days South Africa 365</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Leads/South_Africa365_Non_Response</template>
    </alerts>
    <alerts>
        <fullName>Repeat_or_Referral_Lead_Created_Notification</fullName>
        <ccEmails>sales@safari365.com</ccEmails>
        <description>Repeat or Referral Lead Created Notification</description>
        <protected>false</protected>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/RepeatandReferralLeadCreated</template>
    </alerts>
    <alerts>
        <fullName>Safari365_Photobook_Offer_Send_Brazil</fullName>
        <description>Safari365 Photobook Offer Send Brazil</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>infobr@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consulting_Templates_Brazil/X1_9_1_STAGE_LEADBrazil</template>
    </alerts>
    <alerts>
        <fullName>Sales_Cycle_Email_New_Assign</fullName>
        <description>Sales Cycle_ Email Notify a New Consultant has been Assigned</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/Safari_365_Assigned_Leadb</template>
    </alerts>
    <alerts>
        <fullName>Sales_Cycle_Email_Notify_a_New_Consultant_has_been_Assigned_Brazil</fullName>
        <description>Sales Cycle_ Email Notify a New Consultant has been Assigned Brazil</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>infobr@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Brazil/Safari_365_Assigned_Leadb_Brazil</template>
    </alerts>
    <alerts>
        <fullName>Sales_Cycle_Email_Notify_a_New_Consultant_has_been_Assigned_German</fullName>
        <description>Sales Cycle_ Email Notify a New Consultant has been Assigned German</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_German/Safari_365_Assigned_LeadGerman</template>
    </alerts>
    <alerts>
        <fullName>Thank_You_for_Downloading_our_Brochure</fullName>
        <description>Thank You for Downloading our Brochure</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Leads/Safari_365_BrochureAuto_Respondse_Logo</template>
    </alerts>
    <alerts>
        <fullName>Thank_You_for_Downloading_our_Brochure3</fullName>
        <description>Thank You for Downloading our Brochure</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Leads/Safari_365_BrochureAuto_Respondse_Logo</template>
    </alerts>
    <fieldUpdates>
        <fullName>Date_Status_change</fullName>
        <field>Date_Status_Changed__c</field>
        <formula>TODAY()</formula>
        <name>Date Status change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_sent_to_Lead_Owner</fullName>
        <field>Email_Notified__c</field>
        <literalValue>1</literalValue>
        <name>Email sent to Lead Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_sent_to_Lead_OwnerGerman</fullName>
        <field>Email_Notified__c</field>
        <literalValue>1</literalValue>
        <name>Email sent to Lead Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FieldUpdate_Newsletter</fullName>
        <field>Newsletter__c</field>
        <literalValue>0</literalValue>
        <name>FieldUpdate:Newsletter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_Newsletter_Checkbox</fullName>
        <field>Newsletter__c</field>
        <literalValue>1</literalValue>
        <name>Field Update Newsletter Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Forward_Step_Convert_to_an_Opportunity</fullName>
        <field>Status</field>
        <literalValue>Qualified</literalValue>
        <name>Forward Step - Convert to an Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Process_Stage_Defult</fullName>
        <field>Leads_Process__c</field>
        <literalValue>Not Contacted Yet</literalValue>
        <name>Lead Process Stage Defult</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Newsletter_for_Opportunity_Update</fullName>
        <field>Newsletter_for_opportunity__c</field>
        <literalValue>1</literalValue>
        <name>Newsletter for Opportunity Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Path_Updates_Lead_Stage_to_Open</fullName>
        <description>Path Updates Lead Stage to Open</description>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>Path Updates Lead Stage to Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Path_Updating_Lead_Stage_In_Dialogue</fullName>
        <description>Path Updating Lead Stage In Dialogue</description>
        <field>Status</field>
        <literalValue>Contacted</literalValue>
        <name>Path Updating Lead Stage In Dialogue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Source_to_Google_Adwords</fullName>
        <field>LeadSource</field>
        <literalValue>Google AdWords</literalValue>
        <name>Update Lead Source to &apos;Google Adwords&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>newLead_Country_of_residence_Australia</fullName>
        <field>New_Country_of_Residence__c</field>
        <literalValue>Australia</literalValue>
        <name>newLead Country of residence Australia</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>newcountry_of_residence_USA</fullName>
        <field>New_Country_of_Residence__c</field>
        <literalValue>USA</literalValue>
        <name>newcountry of residence = USA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AutoResponse%3A Safari 365 Brochure Download  Auto Response</fullName>
        <actions>
            <name>Thank_You_for_Downloading_our_Brochure3</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Brochure Download</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com,Web: safari365.com.au,Web: southafrica365.com,Web: safari365.com.cn,Web: safari365.es</value>
        </criteriaItems>
        <description>AutoResponse: Safari 365 Brochure Download  Auto Response</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Competition Entry - Lead DE</fullName>
        <actions>
            <name>Competition_Entry_Lead_DE</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Competition_Name__c</field>
            <operation>equals</operation>
            <value>10 Year Anniversary Giveaway</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web: safari365.de</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Competition Entry - Lead EN</fullName>
        <actions>
            <name>Competition_Entry_Lead</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Competition_Name__c</field>
            <operation>equals</operation>
            <value>10 Year Anniversary Giveaway</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com,Web: safari365.com.au,Web: southafrica365.com,Web: top5africa.com,Web: goodsafariguide.com,Web: safari365.com.cn,Web: safari365.es</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Competition Entry - Lead PT</fullName>
        <actions>
            <name>Competition_Entry_Lead_PT</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Competition_Name__c</field>
            <operation>equals</operation>
            <value>10 Year Anniversary Giveaway</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web:safari365.com.tur.br</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Competition Entry - New Referral Lead DE</fullName>
        <actions>
            <name>Competition_Entry_New_Referral_Lead_Ceated_Offer_to_enter_Competition_DE</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Competition Entry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Competition_Name__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web: safari365.de</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Competition Entry - New Referral Lead EN</fullName>
        <actions>
            <name>Competition_Entry_New_Referral_Lead_Ceated_Offer_to_enter_Competition</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Competition Entry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Competition_Name__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com,Web: safari365.com.au,Web: southafrica365.com,Web: top5africa.com,Web: goodsafariguide.com,Web: safari365.com.cn,Web: safari365.es</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Competition Entry - New Referral Lead PT</fullName>
        <actions>
            <name>Competition_Entry_New_Referral_Lead_Ceated_Offer_to_enter_Competition_PT</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Competition Entry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Competition_Name__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web:safari365.com.tur.br</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Field Update Newsletter</fullName>
        <actions>
            <name>Field_Update_Newsletter_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7</booleanFilter>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com.au</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web: safari365.de</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web:safari365.com.tur.br</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web: top5africa.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web: safari365.es</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com.cn</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Internal Assignment Rule%3A A_Consultant_has_recieved_new_lead</fullName>
        <actions>
            <name>INternal_Lead_Assignement_Consultant_has_recieved_a_new_lead</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>Marcus Brain</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Marcus Brain</value>
        </criteriaItems>
        <description>Inform a consultant they have been assigned a new lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Country of residence Australia</fullName>
        <actions>
            <name>newLead_Country_of_residence_Australia</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.DaddyAnalytics__DA_Campaign_Name__c</field>
            <operation>contains</operation>
            <value>Australia</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Country of residence USA</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.DaddyAnalytics__DA_Campaign_Name__c</field>
            <operation>contains</operation>
            <value>USA</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Process Stage Defult</fullName>
        <actions>
            <name>Lead_Process_Stage_Defult</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>contains</operation>
            <value>@</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status Date Change</fullName>
        <actions>
            <name>Date_Status_change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Members Club Brazil%3A A New Consultant has been  Assigned %28Brazil%29</fullName>
        <actions>
            <name>Sales_Cycle_Email_Notify_a_New_Consultant_has_been_Assigned_Brazil</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>Marcus Brain</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web:safari365.com.tur.br</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Marcus Brain</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Do_Not_Send_Photobook_Offer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Do_Not_Send_Auto_Intro_Email_on_Assign__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Inform a client that a new consultant has been assigned to their request  (Brazil)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Members Club German%3A A New Consultant has been Assigned %28German%29</fullName>
        <actions>
            <name>Sales_Cycle_Email_Notify_a_New_Consultant_has_been_Assigned_German</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_sent_to_Lead_OwnerGerman</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>Marcus Brain</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web: safari365.de</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Marcus Brain</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Do_Not_Send_Photobook_Offer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Do_Not_Send_Auto_Intro_Email_on_Assign__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Inform a client that a new consultant has been assigned to their request  (German)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Members Club%3A A New Consultant has been  Assigned</fullName>
        <actions>
            <name>Sales_Cycle_Email_New_Assign</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_sent_to_Lead_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>Marcus Brain</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com.au,Web: safari365.com,Web: top5africa.com,Web: southafrica365.com,Web: safari365.es</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Marcus Brain</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Do_Not_Send_Photobook_Offer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Do_Not_Send_Auto_Intro_Email_on_Assign__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Inform a client that a new consultant has been assigned to their request</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Members Club%3A Welcome to the Members Club %28user created lead%29</fullName>
        <actions>
            <name>Members_Club_Intro_to_New_Lead_Manually_social_media_phone_referral</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>Marcus Brain</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com.au,Web: safari365.com,Web: top5africa.com,Web: southafrica365.com,Web: safari365.es</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Do_Not_Send_Photobook_Offer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Send welcome to MC when the user has created the lead</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Members Club%3A Welcome to the Members Club Brazil %28user created lead%29</fullName>
        <actions>
            <name>Members_Club_Intro_to_New_Lead_Manually_Brazil_social_media_phone_referral</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>Marcus Brain</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website_origin__c</field>
            <operation>equals</operation>
            <value>Web:safari365.com.tur.br</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Do_Not_Send_Photobook_Offer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Send welcome to MC when the user has created the lead Brazil</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New HasOptedOutOfEmail</fullName>
        <actions>
            <name>FieldUpdate_Newsletter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Newsletter for Opportunity Field Update</fullName>
        <actions>
            <name>Newsletter_for_Opportunity_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Newsletter__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Path Updates Lead Stage to In Dialogue</fullName>
        <actions>
            <name>Path_Updating_Lead_Stage_In_Dialogue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Leads_Process__c</field>
            <operation>equals</operation>
            <value>Forward Step - In Dialogue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Path Updates Lead Stage to Open</fullName>
        <actions>
            <name>Path_Updates_Lead_Stage_to_Open</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Leads_Process__c</field>
            <operation>equals</operation>
            <value>1st Step - Intro Phone Call,2nd Step - 1st Follow up Email,3rd Step - Call Again,4th Step - Detailed Itinerary Suggestion Email,&quot;5th Step - No Response, Closed Lost&quot;</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Path Updates Lead Stage to Qualified</fullName>
        <actions>
            <name>Forward_Step_Convert_to_an_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Leads_Process__c</field>
            <operation>equals</operation>
            <value>Forward Step - Convert to an Opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Repeat or Referral Lead Created Notification</fullName>
        <actions>
            <name>Repeat_or_Referral_Lead_Created_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Client Referral,Employee Referral,Repeat Client</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Source to %27Google Adwords%27 %28by DA%29</fullName>
        <actions>
            <name>Update_Lead_Source_to_Google_Adwords</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.DaddyAnalytics__DA_Campaign_Term__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.DaddyAnalytics__DA_Campaign_Source__c</field>
            <operation>equals</operation>
            <value>google</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.DaddyAnalytics__DA_Campaign_Medium__c</field>
            <operation>equals</operation>
            <value>cpc</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Web Direct</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Email_Current_Specials_English_SA365</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email: Current Specials Photo Book (English Safari 365)</subject>
    </tasks>
    <tasks>
        <fullName>Email_Current_Specials_Photo_Book_English_Safari_365</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email: Current Specials Photo Book (English Safari 365)</subject>
    </tasks>
    <tasks>
        <fullName>New_Lead_Assigned_to_you</fullName>
        <assignedToType>owner</assignedToType>
        <description>A new Lead has been assigned to you.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Lead Assigned to you</subject>
    </tasks>
    <tasks>
        <fullName>Non_Response_Lead</fullName>
        <assignedToType>owner</assignedToType>
        <description>Reminder to contact Non Response leads!!</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Non Response Lead</subject>
    </tasks>
    <tasks>
        <fullName>Non_Response_Lead2</fullName>
        <assignedToType>owner</assignedToType>
        <description>Reminder to contact Non Response leads!!</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Non Response Lead2</subject>
    </tasks>
</Workflow>
