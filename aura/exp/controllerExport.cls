/**
 * @description       : 
 * @author            : Mariano Di Nuzzo
 * @group             : 
 * @last modified on  : 10-26-2022
 * @last modified by  : Mariano Di Nuzzo
**/
global with sharing class controllerExport {
    global String mySubject {get;set;}

    public PageReference myMethod(){
        System.debug('mySubject: ' + mySubject);
        return null;
    }

    @AuraEnabled
    global static void controllerExport() {
        String id = ApexPages.currentPage().getParameters().get('id'); 
        System.debug('id->'+id); 

        String sessionId = 'Bearer ' + UserInfo.getSessionId();
        System.debug('sessionId->'+sessionId); 
    }
}
