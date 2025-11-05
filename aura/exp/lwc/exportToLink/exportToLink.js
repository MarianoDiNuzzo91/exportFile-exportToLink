import { LightningElement, wire, track, api } from "lwc";
import {NavigationMixin} from 'lightning/navigation'
/* import getListViewQuery from '@salesforce/apex/ListViewAPI.getListViewQuery'; */

export default class ExportToLink extends NavigationMixin(LightningElement) {
    siteURL;
    @api recordId;

    connectedCallback() {
        
        this.siteURL = '/apex/Example?recId=' + this.recordId;

    }
    
}