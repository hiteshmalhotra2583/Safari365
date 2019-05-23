public class JSON2Apex {
	public static void consumeObject(JSONParser parser) {
		Integer depth = 0;
		do {
			JSONToken curr = parser.getCurrentToken();
			if (curr == JSONToken.START_OBJECT || 
				curr == JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == JSONToken.END_OBJECT ||
				curr == JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

	public class Rates {
        public Map<String,Double> FxRates{get;set;}
        
		public Rates(JSONParser parser,List<CurrencyExchangeRate__c> countryNames) {
            FxRates = new Map<String,Double>();
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
                       for(CurrencyExchangeRate__c currencyExchangeRate : countryNames)
                       {
                           if (text == currencyExchangeRate.Country__c) {
                               FxRates.put(text,parser.getDoubleValue());
                           }
                       } 
					}
				}
			}
		}
	}
	
	public class CurrencyExchangeRate {
		public String disclaimer {get;set;} 
		public String license {get;set;} 
		public Integer timestamp {get;set;} 
		public String base {get;set;} 
		public Rates rates {get;set;} 

		public CurrencyExchangeRate(JSONParser parser,List<CurrencyExchangeRate__c> countryNames) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'disclaimer') {
							disclaimer = parser.getText();
						} else if (text == 'license') {
							license = parser.getText();
						} else if (text == 'timestamp') {
							timestamp = parser.getIntegerValue();
						} else if (text == 'base') {
							base = parser.getText();
						} else if (text == 'rates') {
							rates = new Rates(parser,countryNames);
						} else {
							System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public static CurrencyExchangeRate parse(String json,List<CurrencyExchangeRate__c> countryNames) {
		return new CurrencyExchangeRate(System.JSON.createParser(json),countryNames);
	}
	
	public static List<WetuLocation__c> parseWetuLocationJson(JSONParser parser)
	{
    	List<WetuLocation__c> wetuLocations = new List<WetuLocation__c>();
    	WetuLocation__c  wL = null;
    	while(parser.nextToken() != JSONToken.END_ARRAY)
    	{
    		if(parser.getCurrentToken() == JSONToken.VALUE_NULL)
    		{
    			system.debug('parser.getCurrentToken():::'+parser.getCurrentToken());
    			continue;
    		}
	    	
	    	if(parser.getCurrentToken() == JSONToken.FIELD_NAME)
		    {
    			String text = parser.getText();
    			if (parser.nextToken() != JSONToken.VALUE_NULL)
    		    {
    				if (text == 'id') {
    					wL = new WetuLocation__c();
						wL.Location_Id__c = Integer.valueOf(parser.getText());
					}
					else if(text == 'name')
					{
						wL.Location_Name__c = parser.getText();
					}
					else if(text == 'type')
					{
						wL.Location_Type__c = parser.getText();
					}
					else
					{
						consumeObject(parser);
					}
    			}
		    }
		    
		    if(parser.getCurrentToken() == JSONToken.END_OBJECT)
    		{
    			system.debug('wl:::'+wl);
    			wetuLocations.add(wl);
    		}
	    		 
    	}
	return wetuLocations;
  }
    
    
}