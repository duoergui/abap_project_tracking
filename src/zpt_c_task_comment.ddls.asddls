@AbapCatalog.sqlViewName: 'ZPT_C_V_TASK_COM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consumption: 任务注释'

@Search.searchable: true
@Metadata.allowExtensions

@ObjectModel: {
    representativeKey: 'code',
    semanticKey: [  'task_no', 'code' ],
    createEnabled: true,
    updateEnabled: true,
    deleteEnabled: true,
    transactionalProcessingDelegated: true
}

@UI.headerInfo:
{
    typeName: '注释',
    typeNamePlural: '注释',
    title.value: 'code',
    title.label: '注释'
}

//@UI.presentationVariant: [{sortOrder: [{by: 'projectCode', direction: #ASC},
//                                       {by: 'taskCode', direction: #DESC},
//                                       {by: 'createdOn', direction: #DESC}] }]

define view ZPT_C_TASK_COMMENT
    as select from ZPT_I_TASK_COMMENT 
    association [1] to ZPT_C_TASK as _task              on  $projection.task_no = _task.task_no
    association [0..1] to ZPT_VH_USER as _createUserInfo on $projection.createdBy = _createUserInfo.userName
    association [0..1] to ZPT_VH_USER as _updateUserInfo on $projection.updatedBy = _updateUserInfo.userName
{
       
        @ObjectModel: { 
            mandatory: true,
            readOnly: true
        }
        @Search: {
            defaultSearchElement: true,
            ranking: #HIGH,
            fuzzinessThreshold: 1
        }
        @UI: {
            selectionField.position: 20,
            dataPoint.title: 'Task code'
        }
        @ObjectModel.foreignKey.association: '_task'
    key task_no ,
 
    key code,
    
        @ObjectModel: { 
            mandatory: true
        }
        @Search: {
            ranking: #HIGH,
            fuzzinessThreshold: 0.8
        }
        @UI: {
            identification: {
                position: 40,
                importance: #HIGH
            },
            lineItem: {
                position: 40,
                importance: #HIGH
            },
            multiLineText: true
        }
        @Semantics.text: true
        commentary as commentary,
        
        @UI: {
            identification: {
                position: 60,
                importance: #HIGH
            },
            dataPoint.responsibleName: 'createdBy'
        }
        crea_date_time as createdOn,
        
        @UI: {
            identification: {
                position: 50,
                importance: #HIGH
            }
        }
        @ObjectModel.foreignKey.association: '_createUserInfo'
        crea_uname as createdBy,
        
        lchg_date_time as updatedOn,
        
        @ObjectModel.foreignKey.association: '_updateUserInfo'
        lchg_uname as updatedBy,
         
        _task,
        _createUserInfo,
        _updateUserInfo
    
}
