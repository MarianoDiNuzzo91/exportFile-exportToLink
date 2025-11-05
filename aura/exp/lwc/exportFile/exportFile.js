import { LightningElement, track, api} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import USER_ID from "@salesforce/user/Id";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';  
import describeListView from '@salesforce/apex/ListViewAPI.describeListView';

export default class ExportFile extends NavigationMixin(LightningElement) {
    @track isModalOpen = true;
    @api recordId;

    value = '';

    get options() {
        return [
            { label: '.pdf', value: 'pdf' },
            { label: '.csv', value: 'csv' },
            { label: '.xls', value: 'xls' },
            { label: '.xlsx', value: 'xlsx' },
        ];
    }

    closeModal() {
        this.isModalOpen = false;
    }

    exportList() {
        console.log();
        describeListView({
                listViewId: this.recordId
            })
            .then(listViewDescResp => {
                console.log('listViewDescResp->',listViewDescResp);
            })
            .catch(error => {
                console.log(error);
            });
    }

}