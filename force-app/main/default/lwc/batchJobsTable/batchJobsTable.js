import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getBatchJobsTableData from '@salesforce/apex/BatchJobsTableController.getBatchJobsTableData';
import getBatchJobLogsTableData from '@salesforce/apex/BatchJobsTableController.getBatchJobLogsTableData';
import rerunBatch from '@salesforce/apex/BatchJobsTableController.rerunBatch';
import abortBatch from '@salesforce/apex/BatchJobsTableController.abortBatch';
import BatchJobLogsTable from 'c/batchJobLogsTable';

import BatchClassName from '@salesforce/label/c.BatchClassName';
import Status from '@salesforce/label/c.Status';
import CompletedDate from '@salesforce/label/c.CompletedDate';
import Action from '@salesforce/label/c.Action';
import MoreDetails from '@salesforce/label/c.MoreDetails';
import RerunButton from '@salesforce/label/c.RerunButton';
import AbortButton from '@salesforce/label/c.AbortButton';

import NoBatchJobRecords from '@salesforce/label/c.NoBatchJobRecords';
import Error from '@salesforce/label/c.Error';
import ErrorLoadingBatchJobs from '@salesforce/label/c.ErrorLoadingBatchJobs';
import ErrorLoadingBatchJobLogs from '@salesforce/label/c.ErrorLoadingBatchJobLogs';
import NoLogRecords from '@salesforce/label/c.NoLogRecords';
import BatchJobRestarted from '@salesforce/label/c.BatchJobRestarted';
import BatchJobForClass from '@salesforce/label/c.BatchJobForClass';
import NewBatchJobId from '@salesforce/label/c.NewBatchJobId';
import RestartBatchError from '@salesforce/label/c.RestartBatchError';
import BatchJobAborted from '@salesforce/label/c.BatchJobAborted';
import BatchJobWithId from '@salesforce/label/c.BatchJobWithId';
import WasAborted from '@salesforce/label/c.WasAborted';
import AbortBatchError from '@salesforce/label/c.AbortBatchError';

export default class BatchJobsTable extends LightningElement {

    labels = {
        BatchClassName,
        Status,
        CompletedDate,
        Action,
        MoreDetails,
        RerunButton,
        AbortButton
    };

    messages = {
        NoBatchJobRecords,
        Error,
        ErrorLoadingBatchJobs,
        ErrorLoadingBatchJobLogs,
        NoLogRecords,
        BatchJobRestarted,
        BatchJobForClass,
        NewBatchJobId,
        RestartBatchError,
        BatchJobAborted,
        BatchJobWithId,
        WasAborted,
        AbortBatchError
    }

    @api
    fieldSetName;
    showTable = false;
    batchJobsTableData = [];
    batchJobLogsTableColumns = [];
    batchJobLogsTableData = [];

    connectedCallback() {
        this.loadBatchJobsTableData();
    }

    loadBatchJobsTableData() {
        getBatchJobsTableData()
            .then (data => {
                if (data.length > 0) {
                    this.batchJobsTableData = data;
                    this.showTable = true;
                } else {
                    this.showMessage(
                        this.messages.NoBatchJobRecords,
                        '',
                        'warning'
                    );
                }
            })
            .catch (error => {
				this.showMessage(
                    this.messages.Error,
                    this.messages.ErrorLoadingBatchJobs,
                    'error'
                );
                console.log(error);
			});
    }

    async openModal(event) {
        event.preventDefault();
        const batchJobId = event.target.dataset.batchJobId;
        getBatchJobLogsTableData({
            fieldSetName: this.fieldSetName,
            batchJobId: batchJobId
        })
            .then (data => {
                this.batchJobLogsTableColumns = data.columns;
                this.batchJobLogsTableData = data.logs;
            })
            .catch (error => {
				this.showMessage(
                    this.messages.Error,
                    this.messages.ErrorLoadingBatchJobLogs,
                    'error'
                );
                console.log(error);
			});
        if (this.batchJobLogsTableData.length > 0) {
            const result = await BatchJobLogsTable.open({
                size: 'large',
                columns: this.batchJobLogsTableColumns,
                logs: this.batchJobLogsTableData
            });
        } else {
            this.showMessage(
                this.messages.NoLogRecords,
                '',
                'warning'
            );
        }
    }

    rerunBatch(event){
        event.preventDefault();
        const batchJobClassName = event.target.dataset.batchJobClassName;
        rerunBatch({
            batchClassName: batchJobClassName
        })
            .then (data => {
                this.connectedCallback();
                this.showMessage(
                    this.messages.BatchJobRestarted,
                    this.messages.BatchJobForClass + batchJobClassName + this.messages.NewBatchJobId + data,
                    'success'
                );
            })
            .catch (error => {
				this.showMessage(
                    this.messages.Error,
                    this.messages.RestartBatchError + batchJobClassName,
                    'error'
                );
                console.log(error);
			});
    }

    abortBatch(event) {
        event.preventDefault();
        const batchJobId = event.target.dataset.batchJobId;
        abortBatch({
            batchJobId: batchJobId
        })
        .then (data => {
            if (data === 'Success') {
                this.connectedCallback();
                this.showMessage(
                    this.messages.BatchJobAborted,
                    this.messages.BatchJobWithId + batchJobId + this.messages.WasAborted,
                    'success'
                );
            } else {
                this.showMessage(
                    this.messages.Error,
                    data,
                    'error'
                );
            }
        })
        .catch (error => {
            this.showMessage(
                this.messages.Error,
                this.messages.AbortBatchError + batchJobId,
                'error'
            );
            console.log(error);
        });
    }

    showMessage(customTitle = '', customMessage = '', customVariant = 'info'){
        const evt = new ShowToastEvent({
            title: customTitle,
            message: customMessage,
            variant: customVariant,
        });
        this.dispatchEvent(evt);
    }
}