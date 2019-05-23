<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Internal_Verify_Passenger_Details</fullName>
        <description>Internal: Verify Passenger Details</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Passenger_Templates_English/Internal_Verify_Passenger_Details</template>
    </alerts>
    <rules>
        <fullName>Internal%3A Verify Passenger Details</fullName>
        <actions>
            <name>Internal_Verify_Passenger_Details</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Passenger__c.Waiver_Of_Liability__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Internal: Verify Passenger Details</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
