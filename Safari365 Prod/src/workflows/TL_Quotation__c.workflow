<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Field_Update</fullName>
        <field>Primary_Quotation__c</field>
        <literalValue>1</literalValue>
        <name>Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Primary_to_true</fullName>
        <field>Primary_Quotation__c</field>
        <literalValue>1</literalValue>
        <name>Primary to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Primary by Consultant%28New%29%29</fullName>
        <actions>
            <name>Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TL_Quotation__c.Primary_by_Consultant__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>TL Quotation: Tick to always include in deal valueequalsTrue</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
