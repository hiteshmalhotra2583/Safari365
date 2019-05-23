<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_to_Account_User</fullName>
        <description>Send Email to Account User</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/Internal_Login_Reminder</template>
    </alerts>
    <fieldUpdates>
        <fullName>FieldUpdate_Newsletter1</fullName>
        <field>Newsletter__c</field>
        <literalValue>0</literalValue>
        <name>FieldUpdate:Newsletter1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Initaite_Workflow</fullName>
        <field>Initiate_Forget_Id_Workflow__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Initaite Workflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Initiate Forget Id Workflow</fullName>
        <actions>
            <name>Send_Email_to_Account_User</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Uncheck_Initaite_Workflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND (Initiate_Forget_Id_Workflow__c, NOT(PRIORVALUE(Initiate_Forget_Id_Workflow__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New HasPersonOptedOutOfEmail</fullName>
        <actions>
            <name>FieldUpdate_Newsletter1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.PersonHasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Task_Reminder</fullName>
        <assignedToType>owner</assignedToType>
        <description>This account have been created two day ago and this is a reminder to follow up with them!!</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Task Reminder</subject>
    </tasks>
</Workflow>
