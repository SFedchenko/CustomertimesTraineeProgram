public with sharing class Callout {

    private static final String CUSTOM_METADATA_RECORD_NAME = 'TargetOrg';
    private static final String TARGET_ORG_URL = 'https://uacom3-dev-ed.my.salesforce.com/services/apexrest/Account/';
	private static final String JSON_CONTENT_TYPE = 'application/json';
	private static final String POST_METHOD = 'POST';

    @future(callout=true)
	public static void makeCreateAccountCallout(String newAccountsJSON){
		AuthenticationCredentials__mdt authData = getAuthData(CUSTOM_METADATA_RECORD_NAME);
		SF_Authentication authBody = getSFAccessToken(authData);
		createAccounts(authBody, newAccountsJSON);
	}

	private static AuthenticationCredentials__mdt getAuthData(String customMetadataRecordName){
		return AuthenticationCredentials__mdt.getInstance(customMetadataRecordName);
	}

    private static String generateEndpointURL(AuthenticationCredentials__mdt authData){
		String authURL = authData.AuthenticationURL__c;
		authURL += '?grant_type=' + authData.GrantType__c;
		authURL += '&client_secret=' + authData.ClientSecret__c;
		authURL += '&client_id=' + authData.ClientId__c;
		authURL += '&username=' + authData.Username__c;
		authURL += '&password=' + authData.Password__c;
		authURL += '&security_token=' + authData.SecurityToken__c;
		return authURL;
	}

	private static SF_Authentication getSFAccessToken(AuthenticationCredentials__mdt authData){
		HttpRequest authReq = new HttpRequest();
		authReq.setMethod(POST_METHOD);
		authReq.setEndpoint(generateEndpointURL(authData));
		authReq.setHeader('Content-Type', authData.ContentType__c);
		Http http = new Http();
		HttpResponse response = http.send(authReq);
		SF_Authentication authBody = new SF_Authentication().parse(response.getBody());
		return authBody;
	}

	private static void createAccounts(SF_Authentication authBody, String newAccountsJSON){
		HttpRequest dataReq = new HttpRequest();
		dataReq.setMethod(POST_METHOD);
		dataReq.setEndpoint(TARGET_ORG_URL);
		dataReq.setHeader('Authorization', authBody.token_type + ' ' + authBody.access_token);
		dataReq.setHeader('Content-Type', JSON_CONTENT_TYPE);
		dataReq.setBody(newAccountsJSON);
		Http http = new Http();
		HttpResponse response = http.send(dataReq);
	}

	public static AccountWrapper wrapAccounts(List<Account> accounts){
		AccountWrapper wrapper = new AccountWrapper();
		wrapper.accounts = accounts;
		return wrapper;
	}
}