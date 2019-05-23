<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>A_New_Client_Review_has_been_Uploaded</fullName>
        <ccEmails>marcus@safari365.com</ccEmails>
        <ccEmails>sales@safari365.com</ccEmails>
        <ccEmails>social@safari365.com</ccEmails>
        <description>A New Client Review has been Uploaded</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/A_New_Review_Has_Been_Upload</template>
    </alerts>
    <alerts>
        <fullName>Client_Referral_Booked_MD_Send_Thank_You</fullName>
        <ccEmails>marcus@safari365.com</ccEmails>
        <ccEmails>sales@safari365.com</ccEmails>
        <description>Client Referral Booked - MD Send Thank You</description>
        <protected>false</protected>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Social_Media_Templates/MDThanksYouEN</template>
    </alerts>
    <alerts>
        <fullName>Client_Referral_Booked_We_Have_Sent_The_Gift</fullName>
        <ccEmails>photobooks@safari365.com</ccEmails>
        <description>Client Referral Booked: We Have Sent The Gift</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Social_Media_Templates/Gift_Sent_to_Your_Client</template>
    </alerts>
    <alerts>
        <fullName>Consulting_1_Year_after_travel_date_email</fullName>
        <description>Consulting: 1 Year after travel date</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/X1_Year_After_Travel_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Consulting_5_days_before_travel_date_reminder_email</fullName>
        <description>Consulting: 5 days before travel date reminder</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/ClientArrives5day</template>
    </alerts>
    <alerts>
        <fullName>Consulting_Client_Starts_Travelling_in_30_days_Reminder_Vouchers_and_Pre_Departu</fullName>
        <description>Consulting: Client Starts Travelling in 30 days Reminder (Vouchers and Pre-Departure Guides)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/Client_Arrival_in_30_Days</template>
    </alerts>
    <alerts>
        <fullName>Consulting_Client_Starts_Travelling_in_60_days_Reminder_Balance_Due</fullName>
        <description>Consulting: Client Starts Travelling in 60 days Reminder (Balance Due)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/Client_Arrival_in_60_Days</template>
    </alerts>
    <alerts>
        <fullName>Consulting_One_Year_after_travel_date</fullName>
        <description>Consulting: One Year after travel date</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/X1_Year_After_Travel_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Email_A_Client_Referral_has_Confirmed</fullName>
        <ccEmails>admin@safari365.com</ccEmails>
        <ccEmails>marcus@safari365.com</ccEmails>
        <ccEmails>sales@safari365.com</ccEmails>
        <description>Email: A Client Referral has Confirmed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Social_Media_Templates/Client_Referral_Booked</template>
    </alerts>
    <alerts>
        <fullName>Email_Support_Incident_Recorded</fullName>
        <description>Email: Support Incident Recorded</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>integration@safari365.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kerry@southafrica365.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>marcus@safari365.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/Client_Service_Request</template>
    </alerts>
    <alerts>
        <fullName>Internal_Photos_for_Photobook_Stared_Loading</fullName>
        <ccEmails>photobooks@safari365.com</ccEmails>
        <ccEmails>judd@safari365.com</ccEmails>
        <description>Internal: Photos for Photobook Stared Loading</description>
        <protected>false</protected>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/New_Photographs_for_a_Photo_Book_started_uploaded</template>
    </alerts>
    <alerts>
        <fullName>Members_Club_External_Client_hasn_t_completed_upload_in_7_days_Brazil</fullName>
        <description>Members Club External: Client hasn&apos;t completed upload in 7 days Brazil</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Brazil/External_photo_Upload_prob_br</template>
    </alerts>
    <alerts>
        <fullName>Members_Club_External_Reminder_to_Upload_photos_at_60_days</fullName>
        <description>Members Club External: Reminder to Upload photos at 60 days</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/External_You_have_not_uploaded_your_photographs</template>
    </alerts>
    <alerts>
        <fullName>Members_Club_External_Reminder_to_complete_review</fullName>
        <description>Members Club External: Reminder to complete review</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>reviews@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/External_You_have_not_reviewed_your_safari</template>
    </alerts>
    <alerts>
        <fullName>Members_Club_External_Reminder_to_complete_review_Brazil</fullName>
        <description>Members Club External: Reminder to complete review (Brazil)</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>reviews@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Brazil/External_You_have_not_reviewed_your_safari_Brazil</template>
    </alerts>
    <alerts>
        <fullName>Members_Club_External_Reminder_to_upload_photographs_and_review_Brazil</fullName>
        <description>Members Club External: Reminder to upload photographs and review (Brazil)</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Brazil/External_You_have_not_uploaded_your_photographsBrazil</template>
    </alerts>
    <alerts>
        <fullName>Members_Club_External_See_is_a_client_needs_assitance_uploading_photo_English</fullName>
        <description>Members Club External: See is a client needs assitance uploading photo English</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/External_photo_Upload_prob</template>
    </alerts>
    <alerts>
        <fullName>Members_Club_External_See_is_a_client_needs_assitance_uploading_photos_English</fullName>
        <ccEmails>photobooks@safari365.com</ccEmails>
        <description>Members Club External: See is a client needs assitance uploading photos English</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/External_photo_Upload_prob</template>
    </alerts>
    <alerts>
        <fullName>Members_Club_External_Thank_you_for_uploading_your_photographs_Brazil</fullName>
        <description>Members Club External: Thank you for uploading your photographs Brazil</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Brazil/Thank_you_for_uploading_your_photographsBrazil</template>
    </alerts>
    <alerts>
        <fullName>Members_Club_External_We_have_sent_your_photobook_Brazil</fullName>
        <description>Members Club External: We have sent your photobook Brazil</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Brazil/We_have_sent_your_photiobookBrazil</template>
    </alerts>
    <alerts>
        <fullName>New_Photographs_for_a_Photo_Book_have_been_uploaded</fullName>
        <ccEmails>photobooks@safari365.com</ccEmails>
        <ccEmails>marcus@safari365.com</ccEmails>
        <ccEmails>social@safari365.com</ccEmails>
        <description>New Photographs for a Photo Book have been uploaded</description>
        <protected>false</protected>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/New_Photographs_for_a_Photo_Book_have_been_uploaded</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Over_40k_Lost</fullName>
        <ccEmails>info@safari365.com</ccEmails>
        <description>Opportunity_Over_40k_Lost</description>
        <protected>false</protected>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/Opportunity_Over_R40k_Lost</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Quote_to_Travel_Logic</fullName>
        <ccEmails>salesforce@southafrica365.com</ccEmails>
        <description>Opportunity Quote to Travel Logic</description>
        <protected>false</protected>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/New_Lead_to_Travel_Logic</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Quote_to_Travel_Logic_4</fullName>
        <ccEmails>tl4@safari365.com</ccEmails>
        <description>Opportunity Quote to Travel Logic 4</description>
        <protected>false</protected>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/New_Lead_to_Travel_Logic</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Quote_to_Travel_Logic_New</fullName>
        <ccEmails>tl3@safari365.com</ccEmails>
        <description>Opportunity Quote to Travel Logic(New)</description>
        <protected>false</protected>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/New_Lead_to_Travel_Logic</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Client_referral_address_is_needed</fullName>
        <ccEmails>marcus@safari365.com</ccEmails>
        <ccEmails>sales@safari365.com</ccEmails>
        <ccEmails>admin@safari365.com</ccEmails>
        <description>Reminder: Client Referral Address is Needed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Social_Media_Templates/Client_Referral_Booked_reminder</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Free_Photobook</fullName>
        <description>Reminder: Free Photobook</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/Reminder_free_Photobook</template>
    </alerts>
    <alerts>
        <fullName>Reminder_to_upload_photographs_and_review_Rnglish</fullName>
        <description>Reminder to upload photographs and review English</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/External_You_have_not_uploaded_your_photographs</template>
    </alerts>
    <alerts>
        <fullName>Repeat_Client_Booking_in_Progress</fullName>
        <description>Repeat Client Booking in Progress</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Social_Media_Templates/Repeat_Client_Booking_in_Progress</template>
    </alerts>
    <alerts>
        <fullName>Request_client_to_upload_photographs_and_review</fullName>
        <description>Request client to upload photographs and reviews</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/External_Request_client_to_upload_photographs_and_reviews</template>
    </alerts>
    <alerts>
        <fullName>Request_client_to_upload_photographs_and_reviews</fullName>
        <description>Request client to upload photographs and reviews</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/External_Request_client_to_upload_photographs_and_reviews</template>
    </alerts>
    <alerts>
        <fullName>Request_client_to_upload_photographs_and_reviews2</fullName>
        <description>Request client to upload photographs and reviews</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/External_Request_client_to_upload_photographs_and_reviews</template>
    </alerts>
    <alerts>
        <fullName>Request_client_to_upload_photographs_and_reviews_14Days</fullName>
        <description>Request client to upload photographs and reviews</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/External_Request_client_to_upload_photographs_and_reviews</template>
    </alerts>
    <alerts>
        <fullName>Request_client_to_upload_photographs_and_reviews_21days</fullName>
        <description>Request client to upload photographs and reviews</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/External_Request_client_to_upload_photographs_and_reviews</template>
    </alerts>
    <alerts>
        <fullName>Review_Rating_1or2</fullName>
        <ccEmails>info@safari365.com</ccEmails>
        <description>Review Rating  = 1 or 2</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>integration@00dd0000000lfnoma2.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/Review_Rating_1_or_2</template>
    </alerts>
    <alerts>
        <fullName>Review_Rating_5</fullName>
        <ccEmails>info@safari365.com</ccEmails>
        <description>Review Rating  = 5</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>integration@safari365.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/Review_Rating_5</template>
    </alerts>
    <alerts>
        <fullName>Review_your_Safari_and_Receive_your_Complimentary_Photo_Book_21_Days_Brazil</fullName>
        <description>Review your Safari and Receive your Complimentary Photo Book (21 Days) Brazil</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Brazil/Client_Photo_Book_and_Review_Upload_Request_Brazil</template>
    </alerts>
    <alerts>
        <fullName>Send_Gift_Client_Referral_Booking</fullName>
        <ccEmails>admin@safari365.com</ccEmails>
        <description>Send Gift: Client Referral Booking</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Social_Media_Templates/Client_Referral_Booked_sendgift</template>
    </alerts>
    <alerts>
        <fullName>Thank_you_for_uploading_your_photographs</fullName>
        <description>Thank you for uploading your photographs</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/Thank_you_for_uploading_your_photographs</template>
    </alerts>
    <alerts>
        <fullName>Update_the_owner_for_the_client_travelled14_days</fullName>
        <description>Update the owner for the client travelled14 days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/Welcome_Home_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Update_the_owner_for_the_client_travelled_one_year_ago</fullName>
        <ccEmails>info@safari365.com</ccEmails>
        <description>Update the owner for the client travelled one year ago</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/X1_Year_After_Travel_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Update_the_owner_for_the_client_travelling_in_30_days</fullName>
        <description>Update the owner for the client travelling in 30 days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/Client_Arrival_in_30_Days</template>
    </alerts>
    <alerts>
        <fullName>Update_the_owner_for_the_client_travelling_in_5_days_time</fullName>
        <description>Update the owner for the client travelling in 5 days time</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/ClientArrives5day</template>
    </alerts>
    <alerts>
        <fullName>We_have_sent_your_photobook</fullName>
        <description>We have sent your photobook</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Members_Club_Templates_Eng/We_have_sent_your_photiobook</template>
    </alerts>
    <alerts>
        <fullName>Welcome_Home_Reminder_Rule</fullName>
        <description>Consulting: Welcome Home Reminder Rule</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>info@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/Welcome_Home_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Welcome_Home_letter_to_be_sent</fullName>
        <description>Welcome Home letter to be sent</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/Welcome_Home_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Your_Client_Starts_Travelling_in_30_Days</fullName>
        <description>Your Client Starts Travelling in 30 Days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/Client_Arrival_in_30_Days</template>
    </alerts>
    <alerts>
        <fullName>Your_client_starts_travelling_in_5_days_time</fullName>
        <description>Your client starts travelling in 5 days time</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>photobooks@safari365.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consultant_Reminder_Templates/ClientArrives5day</template>
    </alerts>
    <fieldUpdates>
        <fullName>Opp_Close_Date</fullName>
        <field>CloseDate</field>
        <formula>CreatedDate + 30</formula>
        <name>Opp Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opp_hCreatedinTL</fullName>
        <field>hCreatedinTL__c</field>
        <literalValue>1</literalValue>
        <name>Update Opp hCreatedinTL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opp_hCreatedinTL4</fullName>
        <field>hCreatedinTL__c</field>
        <literalValue>1</literalValue>
        <name>Update Opp hCreatedinTL4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opp_hCreatedinTL_New</fullName>
        <field>hCreatedinTL__c</field>
        <literalValue>1</literalValue>
        <name>Update Opp hCreatedinTL(New))</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Client Referral Booked</fullName>
        <actions>
            <name>Email_A_Client_Referral_has_Confirmed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Money in the Bank,Closed Won Deal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.LeadSource</field>
            <operation>equals</operation>
            <value>Client Referral</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Client Referral Booked%3A MD Send Thank You Letter</fullName>
        <actions>
            <name>Client_Referral_Booked_MD_Send_Thank_You</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Money in the Bank,Closed Won Deal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.LeadSource</field>
            <operation>equals</operation>
            <value>Client Referral</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Gift_Sent_to_this_Opportunity_Referrer__c</field>
            <operation>equals</operation>
            <value>MD to send &apos;Thank You&apos; letter (No gift will be sent)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Client Referral Booked%3A Reminder for Address</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Money in the Bank,Closed Won Deal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.LeadSource</field>
            <operation>equals</operation>
            <value>Client Referral</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Gift_Sent_to_this_Opportunity_Referrer__c</field>
            <operation>equals</operation>
            <value>Address Yet To Be Provided</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_Client_referral_address_is_needed</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Client Referral Booked%3A Send Gift</fullName>
        <actions>
            <name>Send_Gift_Client_Referral_Booking</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Money in the Bank,Closed Won Deal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.LeadSource</field>
            <operation>equals</operation>
            <value>Client Referral</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Gift_Sent_to_this_Opportunity_Referrer__c</field>
            <operation>equals</operation>
            <value>Address Provided/Updated -  Send Gift</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Client Referral Booked%3A We Have Sent The Gift</fullName>
        <actions>
            <name>Client_Referral_Booked_We_Have_Sent_The_Gift</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Gift_Sent_to_this_Opportunity_Referrer__c</field>
            <operation>equals</operation>
            <value>Gift Sent</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Members Club External%3A Client hasnt completed upload in 7 days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Money in the Bank</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Do_Not_Send_Phptpbook_Offer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Photobook_Stage__c</field>
            <operation>equals</operation>
            <value>Started Loading</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Website_origin_2__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com,Web: safari365.com.au,Web: southafrica365.com,Web: safari365.com.cn,Web: safari365.es,Web: safari365.de</value>
        </criteriaItems>
        <description>Client Reminder -  are they having problems uploading</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Members_Club_External_See_is_a_client_needs_assitance_uploading_photo_English</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Members Club External%3A Client hasnt completed upload in 7 days BR</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Money in the Bank</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Do_Not_Send_Phptpbook_Offer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Photobook_Stage__c</field>
            <operation>equals</operation>
            <value>Started Loading</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Website_origin_2__c</field>
            <operation>equals</operation>
            <value>Web:safari365.com.tur.br</value>
        </criteriaItems>
        <description>Client Reminder -  are they having problems uploading</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Members_Club_External_Client_hasn_t_completed_upload_in_7_days_Brazil</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Members Club External%3A Reminder to review your safari</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Money in the Bank</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Do_Not_Send_Phptpbook_Offer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Review_Stage__c</field>
            <operation>equals</operation>
            <value>Not Loaded</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Website_origin_2__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com,Web: safari365.com.au,Web: southafrica365.com,Web: safari365.com.cn,Web: safari365.es</value>
        </criteriaItems>
        <description>Client Reminder -  Review your safari</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Members_Club_External_Reminder_to_complete_review</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Reminder_to_Review_Safari_has_been_Sent</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.Arrival_Date__c</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Members Club External%3A Reminder to review your safari %28Brazil%29</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Money in the Bank</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Do_Not_Send_Phptpbook_Offer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Review_Stage__c</field>
            <operation>equals</operation>
            <value>Not Loaded</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Website_origin_2__c</field>
            <operation>equals</operation>
            <value>Web:safari365.com.tur.br</value>
        </criteriaItems>
        <description>Client Reminder -  Review your safari</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Members_Club_External_Reminder_to_complete_review_Brazil</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Reminder_to_Review_Safari_has_been_Sent_to_Client_Brazil</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.Arrival_Date__c</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Members Club External%3A Reminder to upload photographs</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won Deal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Do_Not_Send_Phptpbook_Offer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Photobook_Stage__c</field>
            <operation>equals</operation>
            <value>Not Loaded</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Website_origin_2__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com,Web: safari365.com.au,Web: southafrica365.com,Web: safari365.com.cn,Web: safari365.es</value>
        </criteriaItems>
        <description>Client Reminder -  Receive your Complimentary Photo Book</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_to_upload_photographs_and_review_Rnglish</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Reminder_to_upload_photographs_has_been_sent</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.Arrival_Date__c</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Members Club External%3A Reminder to upload photographs Brazil</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won Deal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Do_Not_Send_Phptpbook_Offer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Photobook_Stage__c</field>
            <operation>equals</operation>
            <value>Not Loaded</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Website_origin_2__c</field>
            <operation>equals</operation>
            <value>Web:safari365.com.tur.br</value>
        </criteriaItems>
        <description>Client Reminder -  Receive your Complimentary Photo Book Brazil</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Members_Club_External_Reminder_to_upload_photographs_and_review_Brazil</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Reminder_to_upload_photographs_has_been_sent_Brazil</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.Arrival_Date__c</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Members Club External%3A Thank you for uploading your photographs</fullName>
        <actions>
            <name>Thank_you_for_uploading_your_photographs</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Photobook_Stage__c</field>
            <operation>equals</operation>
            <value>Uploaded</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Website_origin_2__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com,Web: safari365.com.au,Web: southafrica365.com,Web: safari365.com.cn,Web: safari365.es</value>
        </criteriaItems>
        <description>Thank client for uploading photographs</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Members Club External%3A Thank you for uploading your photographs Brazil</fullName>
        <actions>
            <name>Members_Club_External_Thank_you_for_uploading_your_photographs_Brazil</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Photobook_Stage__c</field>
            <operation>equals</operation>
            <value>Uploaded</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Website_origin_2__c</field>
            <operation>equals</operation>
            <value>Web:safari365.com.tur.br</value>
        </criteriaItems>
        <description>Thank client for uploading photographs Brazil</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Members Club External%3A We have sent your photobook</fullName>
        <actions>
            <name>We_have_sent_your_photobook</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Photobook_Stage__c</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Website_origin_2__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com,Web: safari365.com.au,Web: southafrica365.com,Web: safari365.com.cn,Web: safari365.es</value>
        </criteriaItems>
        <description>External: We have sent your photobook</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Members Club External%3A We have sent your photobook Brazil</fullName>
        <actions>
            <name>Members_Club_External_We_have_sent_your_photobook_Brazil</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Photobook_Stage__c</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Website_origin_2__c</field>
            <operation>equals</operation>
            <value>Web:safari365.com.tur.br</value>
        </criteriaItems>
        <description>External: We have sent your photobook Brazil</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Members Club Internal%3A A New Review had been Uploaded</fullName>
        <actions>
            <name>A_New_Client_Review_has_been_Uploaded</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Review_Stage__c</field>
            <operation>equals</operation>
            <value>De -Active</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Members Club Internal%3A New Photographs for a Photo Book have been uploaded</fullName>
        <actions>
            <name>New_Photographs_for_a_Photo_Book_have_been_uploaded</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Photobook_Stage__c</field>
            <operation>equals</operation>
            <value>Uploaded</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity at Quote Stage for TL4</fullName>
        <actions>
            <name>Opportunity_Quote_to_Travel_Logic_4</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Opp_hCreatedinTL4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>TL Quotation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.hCreatedinTL__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity at Quote Stage%28New%29%29</fullName>
        <actions>
            <name>Opportunity_Quote_to_Travel_Logic_New</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Opp_hCreatedinTL_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>TL Quotation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.hCreatedinTL__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reapeat Client Booking in Progress</fullName>
        <actions>
            <name>Repeat_Client_Booking_in_Progress</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>TL Quotation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.LeadSource</field>
            <operation>equals</operation>
            <value>Repeat Client</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Review your Safari and Receive your Complimentary Photo Book %2821 Days%29</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won Deal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Do_Not_Send_Phptpbook_Offer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Website_origin_2__c</field>
            <operation>equals</operation>
            <value>Web: safari365.com,Web: safari365.com.au,Web: southafrica365.com,Web: safari365.com.cn,Web: safari365.es</value>
        </criteriaItems>
        <description>Auto email sent to the client 21 days after travel date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Request_client_to_upload_photographs_and_reviews_21days</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_to_Review_your_Safari_and_Receive_your_Complimentary_Photo_Book_has_been_S</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.Arrival_Date__c</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Review your Safari and Receive your Complimentary Photo Book %2821 Days%29 Brazil</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Money in the Bank</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Do_Not_Send_Phptpbook_Offer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Website_origin_2__c</field>
            <operation>equals</operation>
            <value>Web:safari365.com.tur.br</value>
        </criteriaItems>
        <description>Auto email sent to the client 21 days after travel date Brazil</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Review_your_Safari_and_Receive_your_Complimentary_Photo_Book_21_Days_Brazil</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_to_Review_your_Safari_and_Receive_BR</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.Arrival_Date__c</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Sales Cycle%3A Client starts travelling in 30 days</fullName>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Money in the Bank</value>
        </criteriaItems>
        <description>New Opportunity Trigger: Your client starts travelling in 30 days time</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Consulting_Client_Starts_Travelling_in_30_days_Reminder_Vouchers_and_Pre_Departu</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Arrival_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Sales Cycle%3A Client starts travelling in 60 days - Balance Due</fullName>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Money in the Bank,Closed Won Deal</value>
        </criteriaItems>
        <description>New Opportunity Trigger: Your client starts travelling in 60 days time - Balance Due</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Consulting_Client_Starts_Travelling_in_60_days_Reminder_Balance_Due</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Arrival_Date__c</offsetFromField>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Sales Cycle%3A Client travelled 1 year ago</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Money in the Bank,Closed Won Deal</value>
        </criteriaItems>
        <description>New Opportunity Trigger: Your Client travelled 1 year ago</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Consulting_1_Year_after_travel_date_email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Arrival_Date__c</offsetFromField>
            <timeLength>360</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Sales Cycle%3A Client_starts_travelling_in_5_days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Money in the Bank</value>
        </criteriaItems>
        <description>New Opportunity Trigger: Your client starts travelling in 5 days time</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Consulting_5_days_before_travel_date_reminder_email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Arrival_Date__c</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Sales Cycle%3A Field Update - One year ago</fullName>
        <actions>
            <name>Update_the_owner_for_the_client_travelled_one_year_ago</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.WorkflowRun__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>APEX code updating all opportunities pre 1 March 2013</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Cycle%3A Field Update -30 days before</fullName>
        <actions>
            <name>Update_the_owner_for_the_client_travelling_in_30_days</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.WorkflowRun2__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>APEX code updating all opportunities pre 1 March 2013</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Cycle%3A Update field client travelled after 14 days</fullName>
        <actions>
            <name>Update_the_owner_for_the_client_travelled14_days</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.WorkflowRun4__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>APEX code updating all opportunities pre 1 March 2013</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Cycle%3A Update field client travelling before 5 days</fullName>
        <actions>
            <name>Update_the_owner_for_the_client_travelling_in_5_days_time</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.WorkflowRun3__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>APEX code updating all opportunities pre 1 March 2013</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Cycle%3A Welcome Home Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Money in the Bank</value>
        </criteriaItems>
        <description>New Opportunity Trigger: 2 weeks after opportunity arrival date, send a reminder for welcome home letter</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Welcome_Home_Reminder_Rule</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Arrival_Date__c</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Support Servce Request Updated</fullName>
        <actions>
            <name>Email_Support_Incident_Recorded</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Support_Aservice_Description__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Email_to_Review_your_Safari_and_Receive_BR</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email to Review your Safari and Receive your Complimentary Photo Book has been Sent Brazil</subject>
    </tasks>
    <tasks>
        <fullName>Email_to_Review_your_Safari_and_Receive_your_Complimentary_Photo_Book_has_been_S</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email to Review your Safari and Receive your Complimentary Photo Book has been Sent</subject>
    </tasks>
    <tasks>
        <fullName>Reminder_to_Review_Safari_has_been_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Reminder to Review Safari has been Sent to Client</subject>
    </tasks>
    <tasks>
        <fullName>Reminder_to_Review_Safari_has_been_Sent_to_Client_Brazil</fullName>
        <assignedToType>owner</assignedToType>
        <description>Reminder to Review Safari has been Sent to Client</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Reminder to Review Safari has been Sent to Client</subject>
    </tasks>
    <tasks>
        <fullName>Reminder_to_upload_photographs_has_been_sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Reminder to upload photographs has been sent</subject>
    </tasks>
    <tasks>
        <fullName>Reminder_to_upload_photographs_has_been_sent_Brazil</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Reminder to upload photographs has been sent (Brazil)</subject>
    </tasks>
</Workflow>
