/**
 * @description       : 
 * @author            : Mariano Di Nuzzo
 * @group             : 
 * @last modified on  : 11-03-2022
 * @last modified by  : Mariano Di Nuzzo
**/
global with sharing class ListViewAPI {

        public class FlowInputs{
            @InvocableVariable
            public String idListView; 
        }

        @InvocableMethod(label='Passare la lista con un solo Id della list View')
        public static void exportListView(List<FlowInputs> listView) {      
            /* String listViewId = String.valueOf(listView[0]); */
            String listViewId = '00B7Q00000KV8NrUAL';
            System.debug('listViewId, ' + listViewId);
            Http http = new Http();
            HTTPRequest httpReq = new HTTPRequest();
            String orgDomain = Url.getSalesforceBaseUrl().toExternalForm();
            String endpoint = orgDomain + '/services/data/v37.0/sobjects/Case/listviews/' + listViewId + '/describe';
            
            httpReq.setEndpoint( endpoint );
            httpReq.setMethod( 'GET' );
            httpReq.setHeader( 'Content-Type', 'application/json; charset=UTF-8' );
            httpReq.setHeader( 'Accept', 'application/json' );
            
            /*  
                string paramvalue = EncodingUtil.base64Encode(Blob.valueOf(userinfo.getSessionId()));
                System.debug('paramvalue, ' + paramvalue);
                string paramvalue2 = UserInfo.getOrganizationId()+''+UserInfo.getSessionId().substring(15);
                string paramvalue4 = UserInfo.getOrganizationId().substring(0, 15) + '' +  UserInfo.getSessionId().substring(15)
                System.debug('paramvalue2, ' + paramvalue2);
                string paramvalue3 = UserInfo.getSessionId();
                System.debug('paramvalue3, ' + paramvalue3);
            */

            String sessionId = UserInfo.getOrganizationId()+''+UserInfo.getSessionId().substring(15);

            System.debug('sessionId -> ' + sessionId );

            ListViewAPI.getBearerKey();

            httpReq.setHeader( 'Authorization', sessionId);
            
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
                                                            //per modificare il file excel editare anche la vf page
                                                            //inserire i campi come primo elemento
            for(Case el : caseList){
                passingTogenXls.add(String.valueOf(el));    //parsing delle stringhe 
            }
        
            XLSXGenerator.generate(passingTogenXls);
        }

      
        public class responseWrapper{
            public String id;
            public String access_token;
            public String instance_url;
        }

        public static String getBearerKey(){
            String listViewId = '00B7Q00000KV8NrUAL';
            String orgDomain = Url.getSalesforceBaseUrl().toExternalForm();
            String endpoint = orgDomain + '/services/data/v37.0/sobjects/Case/listviews/' + listViewId + '/describe';
            System.debug('endpoint ' + endpoint);
            
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setEndpoint(endpoint);
            req.setBody('grant_type=xxxxxxxx' + '&username=xxxxxx' + '&password=xxxxxxx');
            
            Http h = new Http();
            HTTPResponse res = h.send(req);
            System.debug('Body ' + res.getBody());
            System.debug('Status ' + res.getStatus());
            System.debug('Status code ' + res.getStatusCode());
            
            String strResponse = res.getBody();
            Map<String,Object> newMap = (Map<String, Object>)JSON.deserializeUntyped(strResponse);
            //String tkn = (List<Object>) newMap.get('value');
            string tkn= String.valueOf(newMap.get('access_token'));
            System.debug('tkn ' + tkn);
            
            return tkn;
        }

     /*    public static httpResponse getBearerKey () {
            String listViewId = 'xxxxxxxxxxx';
            String orgDomain = Url.getSalesforceBaseUrl().toExternalForm();
            String endpoint = orgDomain + '/services/data/v37.0/sobjects/Case/listviews/' + listViewId + '/describe';
            
            HTTP h = new HTTP();
            String httpMethod = 'GET';
            String accountId = 'xxxxxxxxxxxxxxxxxxxxxx';
            String authToken = 'xxxxxxxxxxxxxxxxxxxxxx';
            String endpoint = 'https://api.apifonica.com/v2/accounts/' + accountId ;
            httpRequest req = new httpRequest();
            String authValue = accountId + ':' + authToken;
            Blob headerValue = Blob.valueOf(accountId +':'+authToken);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization',authorizationHeader);
            req.setMethod(httpMethod);
            req.setEndpoint(endpoint);
            httpResponse res = h.send(req);
            System.debug('response' + res.getBody());
            return res;
        } */

    /*      public String sessionId;

        @future (callout=true)
        public static void getRequestToken(){
            String cKey = 'xxxxxxxx';
            String cSecret = 'xxxxxxxx';
            String uName = 'xxxxxxxxx';
            String passwd = 'xxxxxxxxx';
    
                           String reqBody = 'grant_type=password&client_id='+cKey+'&client_secret='+cSecret+'&username='+uName+'&password='+passwd;                                      

                            Http h = new Http();
                            HttpRequest req = new HttpRequest();
                            req.setBody(reqBody);
                            req.setMethod('POST');
                            req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
               
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://my_endpoint.example.com/some_path');
            req.setMethod('GET');

            String username = 'marianodinuzzo.bip@cunning-fox-ksux2m.com';
            String password = 'asd123A!SD';
            
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' +
            EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            
            // Create a new http object to send the request object
            // A response object is generated as a result of the request  
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
        } */


}
