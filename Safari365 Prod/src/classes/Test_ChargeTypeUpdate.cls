@isTest
private class Test_ChargeTypeUpdate {
	@isTest static void ChargeTypeUpdateTest(){
        
        Test.startTest();
        ChargeTypeUpdate ctu = new ChargeTypeUpdate();
        ctu.ChargeTypeId = '10';
        ctu.ServiceLineItemId = '10';
        ctu.Markup = '10';
        ctu.NettCost = '10';
        ctu.ClientNotes = '10';
        ctu.Status = '10';
        Test.stopTest();
    }
}