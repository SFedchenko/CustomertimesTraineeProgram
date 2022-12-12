import { api } from 'lwc';
import LightningModal from 'lightning/modal';

import BatchJobLogs from '@salesforce/label/c.BatchJobLogs';
import CloseButton from '@salesforce/label/c.CloseButton';

export default class BatchJobLogsTable extends LightningModal {

    labels = {
        BatchJobLogs,
        CloseButton
    }

    @api
    columns;
    @api
    logs;

    handleCloseButtonClick() {
        this.close();
    }
}