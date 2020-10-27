@AbapCatalog.sqlViewName: 'ZPT_C_V_TASK_TR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consumption: 任务关联请求'

@Search.searchable: true
@Metadata.allowExtensions

@ObjectModel: {
    representativeKey: 'request',
    semanticKey: ['taskno', 'request' ],
    createEnabled: true,
    updateEnabled: true,
    deleteEnabled: true,
    transactionalProcessingDelegated: true
}

@UI.headerInfo:
{
    typeName: 'Transport Request',
    typeNamePlural: 'Transport Requests',
    title.value: 'request',
    title.label: 'Transport Request'
}

define view ZPT_C_TASK_TRAN_REQ
  as select from ZPT_I_TASK_TRAN_REQ 
  association [1] to ZPT_C_TASK           as _task            on $projection.task_no    = _task.task_no
  association [0..1] to ZPT_I_TR_STATUS   as _requestStatus   on $projection.requestStatus = _requestStatus.status
  association [0..1] to ZPT_I_TR_FUNCTION as _requestFunction on $projection.requestFunction = _requestFunction.function
{    
        @UI: {
            identification: [{ position: 20, importance: #HIGH }],
            lineItem:[{position: 20, importance: #HIGH}],
            selectionField:[{position: 20}],
            dataPoint.title: 'Task'
        }
        @Search: {
            defaultSearchElement: true,
            ranking: #HIGH,
            fuzzinessThreshold: 1
        }
        @Consumption.valueHelp:'_task'
    key task_no,    
        @UI: {
            identification: [{ position: 30, importance: #HIGH }],
            lineItem:[{position: 30, importance: #HIGH}],
            selectionField:[{position: 30}],
            dataPoint.title: 'Transport Request'
        }
        @Search: {
            defaultSearchElement: true,
            ranking: #HIGH,
            fuzzinessThreshold: 1
        }
        @Consumption.valueHelp:'_request'
    key transport_request as request,
    
        @UI: {
            identification: [{ position: 35, importance: #LOW }],
            lineItem:[{position: 35, importance: #LOW}],
            selectionField:[{position: 35}],
            textArrangement: #TEXT_ONLY
        }
        @Search: {
            defaultSearchElement: true,
            ranking: #HIGH,
            fuzzinessThreshold: 1
        }
        @Consumption.valueHelp:'_requestFunction'
        @ObjectModel: {
            readOnly: true,
            foreignKey.association: '_requestFunction'
        }
        _request.function as requestFunction,
        
        @UI: {
            identification: [{ position: 37, importance: #LOW }],
            lineItem:[{position: 37, importance: #LOW}],
            selectionField:[{position: 37}],
            textArrangement: #TEXT_ONLY
        }
        @Search: {
            defaultSearchElement: true,
            ranking: #HIGH,
            fuzzinessThreshold: 1
        }
        @Consumption.valueHelp:'_requestStatus'
        @ObjectModel: {
            readOnly: true,
            foreignKey.association: '_requestStatus'
        }
        _request.status as requestStatus,
    
        @UI: {
            identification: [{ position: 50, importance: #LOW }],
            lineItem:[{position: 50, importance: #LOW}]
        }
        commentary,
        
        /* Associations */ 
        @ObjectModel.association.type: [#TO_COMPOSITION_ROOT,#TO_COMPOSITION_PARENT]
        _task,
        _requestStatus,
        _requestFunction,
        _request
    
}
