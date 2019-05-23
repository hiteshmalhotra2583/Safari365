<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Bookingconfirmationoverdue</fullName>
        <description>Send Mail Raised Booking confirmation Not yet Paid</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Quotation_Workflow_Templates/Booking_confirmation_overdue</template>
    </alerts>
    <alerts>
        <fullName>External_Client_Balance_Payment_Due</fullName>
        <ccEmails>currency@safari365.com</ccEmails>
        <description>External: Client Balance Payment Due</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>paid@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/External_Client_Balance_Payment_Due</template>
    </alerts>
    <alerts>
        <fullName>External_Client_Funds_Received</fullName>
        <description>External: Client Funds Received</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>paid@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/External_Client_Funds_Received</template>
    </alerts>
    <alerts>
        <fullName>External_Thank_You_For_Booking</fullName>
        <description>External: Thank You For Booking</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/External_Thank_You_For_Booking</template>
    </alerts>
    <alerts>
        <fullName>Finance_Approved_a_Quotation</fullName>
        <description>Finance Approved a Quotation</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/Finance_Approved_Quotation</template>
    </alerts>
    <alerts>
        <fullName>Finance_rejected_a_Quotation</fullName>
        <description>Finance rejected a Quotation</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/Finance_Rejected_Quotation</template>
    </alerts>
    <alerts>
        <fullName>Internal_Client_Funds_Received</fullName>
        <ccEmails>accounts1@safari365.com</ccEmails>
        <description>Internal: Client Funds Received</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>paid@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/Internal_Client_Funds_Received</template>
    </alerts>
    <alerts>
        <fullName>Internal_Client_Has_Requested_Requote</fullName>
        <description>Internal: Client Has Requested Requote</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sales@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/Internal_Client_Has_Requested_Requote</template>
    </alerts>
    <alerts>
        <fullName>Internal_FX_Treasury_Approval_Required</fullName>
        <description>Internal: FX Treasury Approval Required</description>
        <protected>false</protected>
        <recipients>
            <recipient>currency@safari365.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>currency@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/Internal_FX_Treasury_Approval_Required</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Check_Quotation_Stage_Quoting_Client_Requested_Overdue</fullName>
        <description>Send Email Check Quotation Stage Quoting Client Requested Overdue</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/Internal_Booking_Confirmation_Threshold</template>
    </alerts>
    <alerts>
        <fullName>Send_Mail_Quotation_Stage_Quoting</fullName>
        <ccEmails>sales@safari365.com</ccEmails>
        <description>Send Mail Quotation Stage Quoting</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Quotation_Workflow_Templates/Booking_confirmation_overdue</template>
    </alerts>
    <alerts>
        <fullName>Send_Mail_Raised_Booking_confirmation_Not_yet_Paid</fullName>
        <description>Send Mail Raised Booking confirmation Not yet Paid</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/Internal_Client_Deposit_Not_Received</template>
    </alerts>
    <alerts>
        <fullName>Workflow_Internal_Booking_Confirmation_Threshold</fullName>
        <description>Workflow-Internal-Booking Confirmation Threshold</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/Internal_Booking_Confirmation_Threshold</template>
    </alerts>
    <alerts>
        <fullName>Workflow_Internal_Booking_Confirmation_Threshold1</fullName>
        <description>Workflow-Internal-Booking Confirmation Threshold</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/Internal_Booking_Confirmation_Threshold</template>
    </alerts>
    <alerts>
        <fullName>Workflow_Internal_Booking_Confirmation_Threshold2</fullName>
        <description>Workflow-Internal-Booking Confirmation Threshold</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/Internal_Booking_Confirmation_Threshold</template>
    </alerts>
    <alerts>
        <fullName>Workflow_Internal_Booking_Confirmation_Threshold3</fullName>
        <description>Workflow-Internal-Booking Confirmation Threshold</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Quotation_Templates_English/Internal_Client_Deposit_Not_Received</template>
    </alerts>
    <alerts>
        <fullName>Workflow_Internal_Booking_Confirmation_Threshold4</fullName>
        <description>Workflow-Internal-Booking Confirmation Threshold</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Quotation_Templates_English/Internal_Booking_Confirmation_Threshold</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Status_to_Approved</fullName>
        <field>Quote_Approved_by_Finance__c</field>
        <literalValue>1</literalValue>
        <name>Approval Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_Approved_Confirm</fullName>
        <field>Quotation_Stage__c</field>
        <literalValue>Confirmed</literalValue>
        <name>Approval Status to Approved - Confirm</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Charge_Insurance_in_ZAR</fullName>
        <field>Include_Passenger_Insurance_ZAR__c</field>
        <literalValue>1</literalValue>
        <name>Charge Insurance in ZAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Charge_Photobooks_ZAR</fullName>
        <field>Include_Photobooks_ZAR__c</field>
        <literalValue>1</literalValue>
        <name>Charge Photobooks ZAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Charge_Photobooks_and_Insurance_in_USD</fullName>
        <field>Include_Passenger_Insurance_USD__c</field>
        <literalValue>1</literalValue>
        <name>Charge Insurance in USD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Charge_Photobooks_in_USD</fullName>
        <field>Include_Photobooks_USD__c</field>
        <literalValue>1</literalValue>
        <name>Charge Photobooks in USD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_Populate</fullName>
        <field>Email__c</field>
        <formula>email_formula__c</formula>
        <name>Email Populate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quoation_Stage_Set_to_confirmed</fullName>
        <field>Confirmed__c</field>
        <literalValue>1</literalValue>
        <name>Quoation Stage Set to confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Locked</fullName>
        <field>Record_Locked__c</field>
        <literalValue>1</literalValue>
        <name>Record Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Send_Email_To_Customer</fullName>
        <field>Send_Email_To_Customer__c</field>
        <literalValue>1</literalValue>
        <name>Send Email To Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unselect_Insurance_in_USD</fullName>
        <field>Include_Passenger_Insurance_USD__c</field>
        <literalValue>0</literalValue>
        <name>Unselect Insurance in USD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unselect_Insurance_in_ZAR</fullName>
        <field>Include_Passenger_Insurance_ZAR__c</field>
        <literalValue>0</literalValue>
        <name>Unselect Insurance in ZAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unselect_Insurancein_USD</fullName>
        <field>Include_Photobooks_ZAR__c</field>
        <literalValue>0</literalValue>
        <name>Unselect Photobooks in ZAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unselect_Photobooks_in_USD</fullName>
        <field>Include_Photobooks_USD__c</field>
        <literalValue>0</literalValue>
        <name>Unselect Photobooks in USD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Always_Include_Quotation_Value</fullName>
        <description>Always Include Quotation value will be set to false</description>
        <field>Primary_by_Consultant__c</field>
        <literalValue>1</literalValue>
        <name>Update Always Include Quotation Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Stage_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Finance Approved</literalValue>
        <name>Update Approval Stage - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Stage_Pending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Finance Approval Pending</literalValue>
        <name>Update Approval Stage - Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Charge Photobooks and Insurance in USD</fullName>
        <actions>
            <name>Charge_Photobooks_and_Insurance_in_USD</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Charge_Photobooks_in_USD</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Unselect_Insurance_in_ZAR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Unselect_Insurancein_USD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quotations__c.Charge_Photobooks_and_Insurance_in__c</field>
            <operation>equals</operation>
            <value>USD</value>
        </criteriaItems>
        <description>Charge Photobooks and Insurance in</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Charge Photobooks and Insurance in ZAR</fullName>
        <actions>
            <name>Charge_Insurance_in_ZAR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Charge_Photobooks_ZAR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Unselect_Insurance_in_USD</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Unselect_Photobooks_in_USD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quotations__c.Charge_Photobooks_and_Insurance_in__c</field>
            <operation>equals</operation>
            <value>ZAR</value>
        </criteriaItems>
        <description>Charge Photobooks and Insurance in ZAR</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check Quotation Stage confirmed</fullName>
        <actions>
            <name>Quoation_Stage_Set_to_confirmed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quotations__c.Quotation_Stage__c</field>
            <operation>equals</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <description>If Quotation stage is confirmed make the Checkbox true</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>External%3A Client Balance Payment Due</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Quotations__c.Client_Fund_Recieved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quotations__c.Total_Funds_Outstanding__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Sends email to client when client balance payment is due</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>External_Client_Balance_Payment_Due</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Quotations__c.Balance_Due_Date__c</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>External%3A Client Funds Received</fullName>
        <actions>
            <name>External_Client_Funds_Received</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quotations__c.Client_Fund_Recieved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sends email to client when client funds received</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>External%3A Thank You For Booking</fullName>
        <actions>
            <name>External_Thank_You_For_Booking</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quotations__c.Client_Has_Requested_Confirmation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sends email when client clicks &apos;Book This&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Internal%3A Client Funds Received</fullName>
        <actions>
            <name>Internal_Client_Funds_Received</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quotations__c.Client_Fund_Recieved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sends email to consultant when first deposit funds are received</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Internal%3A Client Has Requested Requote</fullName>
        <actions>
            <name>Internal_Client_Has_Requested_Requote</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quotations__c.Client_Has_Requested_Requote__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sends email to consultant when client has requested a requote</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Internal%3A FX Treasury Approval Required</fullName>
        <actions>
            <name>Internal_FX_Treasury_Approval_Required</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quotations__c.Approval_from_FX_Treasury_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sends email to consultant when FX approval is needed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Email Check Quotation Stage Confirmed Overdue</fullName>
        <actions>
            <name>Bookingconfirmationoverdue</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_Mail_Raised_Booking_confirmation_Not_yet_Paid</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quotations__c.isBookingConfStatusOverdue__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Email Check Quotation Stage Quoting Client Requested Overdue</fullName>
        <actions>
            <name>Send_Email_Check_Quotation_Stage_Quoting_Client_Requested_Overdue</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quotations__c.isClientRequestedConfStatusOverdue__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Always Include Quotation Value</fullName>
        <actions>
            <name>Update_Always_Include_Quotation_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quotations__c.Quotation_Stage__c</field>
            <operation>equals</operation>
            <value>Confirmed,Raised Invoice</value>
        </criteriaItems>
        <description>This workflow rule will update the Always Include Quotation value field to false every time the quotation stage is equals to &quot;Confirmed&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Finance_Approval_Required</fullName>
        <assignedTo>finance@safari365.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>$Label.Quotation_Approval_Requested + testing</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Quotation: Finance Approval Required</subject>
    </tasks>
    <tasks>
        <fullName>Prepare_your_Quote_for_approval</fullName>
        <assignedToType>owner</assignedToType>
        <description>Opportunity owner Please complete the following before requesting Approval

Step 1
Step 2
Step 3</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Quotation: Prepare your Quote for approval</subject>
    </tasks>
    <tasks>
        <fullName>Quotation_Approved_Proceed_to_Confirmed</fullName>
        <assignedToType>owner</assignedToType>
        <description>Your Quotation is approved by finance, please proceed to the Confirmed and change your opportunity to Closed Won Deal.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Quotation: Approved, Proceed to Confirmed</subject>
    </tasks>
    <tasks>
        <fullName>Quotation_rejected_Please_Resubmit_for_approval_once_corrected</fullName>
        <assignedToType>owner</assignedToType>
        <description>Quotation rejected, Please Resubmit for approval once corrected</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Quotation: Rejected, Resubmit Once Quotation Corrected</subject>
    </tasks>
</Workflow>
