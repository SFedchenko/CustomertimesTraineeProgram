({
    getData : function(cmp) {
        let action = cmp.get('c.getAccountsTableData');
        action.setParams({ fieldSetName : cmp.get('v.fieldSetName') });
        action.setCallback(this, $A.getCallback(function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.columns', response.getReturnValue().columns);
                cmp.set('v.accounts', response.getReturnValue().accounts);
            } else if (state === "ERROR") {
                console.error(response.getError());
            }
        }));
        $A.enqueueAction(action);
    }
})