<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_to_Opportunity_owner</fullName>
        <description>Send Email to Opportunity owner</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/Service_Status_Request_Provisional_Booking</template>
    </alerts>
    <rules>
        <fullName>Email To Opp owner for provisonal booking</fullName>
        <actions>
            <name>Send_Email_to_Opportunity_owner</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ServiceLineItem__c.Service_Status__c</field>
            <operation>equals</operation>
            <value>Provisionally Booked</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>ServiceLineItem__c.Provisional_Booking_Expiry_Date__c</offsetFromField>
            <timeLength>-24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
