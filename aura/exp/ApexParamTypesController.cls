/**
 * @description       : 
 * @author            : Mariano Di Nuzzo
 * @group             : 
 * @last modified on  : 11-03-2022
 * @last modified by  : Mariano Di Nuzzo
**/
public with sharing class ApexParamTypesController {
    @future
    public static void serverEcho(String sessionId) {
        System.debug('Hello from the server, ' + sessionId);
        string paramvalue = EncodingUtil.base64Encode(Blob.valueOf(userinfo.getSessionId()));
        /*  
            System.debug('paramvalue, ' + paramvalue);
            string paramvalue2 = UserInfo.getOrganizationId()+''+UserInfo.getSessionId().substring(15);
            string paramvalue4 = UserInfo.getOrganizationId().substring(0, 15) + '' +  UserInfo.getSessionId().substring(15)
            System.debug('paramvalue2, ' + paramvalue2);
            string paramvalue3 = UserInfo.getSessionId();
            System.debug('paramvalue3, ' + paramvalue3);
        */
        String listViewId = 'xxxxxxx';

        Http http = new Http();
        HTTPRequest httpReq = new HTTPRequest();
        String orgDomain = Url.getSalesforceBaseUrl().toExternalForm();
        String endpoint = orgDomain + '/services/data/v37.0/sobjects/Case/listviews/' + listViewId + '/describe';
        
        httpReq.setEndpoint( endpoint );
        httpReq.setMethod( 'GET' );
        httpReq.setHeader( 'Content-Type', 'application/json; charset=UTF-8' );
        httpReq.setHeader( 'Accept', 'application/json' );
        
        // ListViewAPI.getRequestToken();
        
        String sessionIdP = 'Bearer ' + paramvalue;

        System.debug('sessionIdsessionIdP -> ' + sessionIdP );
        httpReq.setHeader( 'Authorization', sessionIdP);
        
        HTTPResponse httpRes = http.send( httpReq );
        String jsonStr = httpRes.getBody();
        System.debug('httpRes -> ' + httpRes);
        ListViewsDescribeResponse listViewDescResp = ( ListViewsDescribeResponse ) JSON.deserialize( jsonStr , ListViewsDescribeResponse.class );
    
        System.debug('listViewDescResp.query -> ' + listViewDescResp.query);
        

        /* PARTE DI EXPORT FUNZIONANTE */

        ListView listVCaseTest = [SELECT Id, Name, DeveloperName, NamespacePrefix, SobjectType, IsSoqlCompatible, CreatedDate, CreatedBy.Name, LastModifiedDate, LastModifiedBy.Name, LastViewedDate, LastReferencedDate FROM ListView WHERE Id =: listViewId LIMIT 1]; 
        //prendere questa query dal vecchio metodo
        List<Case> caseList = [SELECT CaseNumber, Contact.Name, Subject, toLabel(Status), toLabel(Priority), Owner.Alias, Id, CreatedDate, LastModifiedDate, SystemModstamp FROM Case USING SCOPE mine WHERE (Status = 'Working' OR Status = 'Closed') AND Priority = 'High' ORDER BY CaseNumber ASC NULLS FIRST, Id ASC NULLS FIRST];
    
        List<String> passingTogenXls = new List<String>();
                                                        //per modificaare il file excel editare anche la vf page
                                                        //inserire i campi come primo elemento
        for(Case el : caseList){
            passingTogenXls.add(String.valueOf(el));    //parsing delle stringhe 
        }
    
        XLSXGenerator.generate(passingTogenXls);
    }

    public class FlowInputs{
        @InvocableVariable
        public String idListView; 
    }

    @InvocableMethod(label='Passare la lista con un solo Id della list View')
    public static void exportListView(List<FlowInputs> listView) {      
       
    }

  
    public class responseWrapper{
        public String id;
        public String access_token;
        public String instance_url;
    }

    public String sessionId;

    @future (callout=true)
    public static void getRequestToken(){

        String cKey = 'xxxxxxx';
        String cSecret = 'xxxxxx';
        String uName = 'xxxxxxx';
        String passwd = 'xxxxxx';

        String reqBody = 'grant_type=password&client_id='+cKey+'&client_secret='+cSecret+'&username='+uName+'&password='+passwd;                                      

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqBody);
        req.setMethod('POST');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');

        /* 
        String username = 'username';
        String password = 'password+security_token';
        partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
        partnerSoapSforceCom.LoginResult loginResult = sp.login(username, password);
      
        sessionId = loginResult.sessionId; 
        */
        System.debug('sessionId->'+  UserInfo.getOrganizationId().substring(0, 15) + '' +  UserInfo.getSessionId().substring(15));
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getOrganizationId().substring(0, 15) + '' +  UserInfo.getSessionId().substring(15));
        req.setHeader('Content-Type', 'application/json');

        HttpResponse hresp = h.send(req);
        System.debug('hresp ->'+ hresp);
        responseWrapper wResp=(responseWrapper)JSON.deserialize(hresp.getBody(),responseWrapper.class);
        System.debug('Instance url -> '+wResp.instance_url);
        System.debug('session id -> '+wResp.access_token);
        //return wResp.access_token;
      
    }
}
