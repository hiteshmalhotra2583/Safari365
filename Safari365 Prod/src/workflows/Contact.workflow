<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Competition_Entry_Contact</fullName>
        <description>Competition Entry - Contact</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Competition_Reply_Templates/Competition_Account_10_Year_Thank_you_for_entering_IContact</template>
    </alerts>
    <alerts>
        <fullName>Competition_Entry_Contact_DE</fullName>
        <description>Competition Entry - Contact DE</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Competition_Reply_Templates_DE/Competition_10_Year_Thank_you_AccountDE</template>
    </alerts>
    <alerts>
        <fullName>Competition_Entry_Contact_PT</fullName>
        <description>Competition Entry - Contact PT</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Competition_Reply_Templates_PT/Competition_Acocunt_210_Year_Thank_you_for_entering_PT_2</template>
    </alerts>
    <rules>
        <fullName>Competition Entry - Contact DE</fullName>
        <actions>
            <name>Competition_Entry_Contact_DE</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Competition_Name__c</field>
            <operation>equals</operation>
            <value>10 Year Anniversary Giveaway</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Website_Origin_c__c</field>
            <operation>equals</operation>
            <value>Web: safari365.de</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Competition Entry - Contact EN</fullName>
        <actions>
            <name>Competition_Entry_Contact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Competition_Name__c</field>
            <operation>equals</operation>
            <value>10 Year Anniversary Giveaway</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Website_Origin_c__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com,Web: safari365.com.au,Web: southafrica365.com,Web: top5africa.com,Web: goodsafariguide.com,Web: safari365.com.cn,Web: safari365.es</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Competition Entry - Contact PT</fullName>
        <actions>
            <name>Competition_Entry_Contact_PT</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Competition_Name__c</field>
            <operation>equals</operation>
            <value>10 Year Anniversary Giveaway</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Website_Origin_c__c</field>
            <operation>equals</operation>
            <value>Web:safari365.com.tur.br</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
