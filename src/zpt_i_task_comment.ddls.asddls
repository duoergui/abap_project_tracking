@AbapCatalog.sqlViewName: 'ZPT_I_V_TASK_COM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '注释'


@Search.searchable: true

@ObjectModel: {
    modelCategory: #BUSINESS_OBJECT,
    representativeKey: 'code',
    semanticKey: [ 'task_no', 'code' ],
    createEnabled: true,
    updateEnabled: true,
    deleteEnabled: true,
    transactionalProcessingEnabled: true,
    writeActivePersistence: 'ZPT_T_COMMENT'
}

define view ZPT_I_TASK_COMMENT as select from 
    zpt_t_comment  
    association [1] to ZPT_I_TASK as _task               on $projection.task_no      = _task.task_no    
    association [0..1] to ZPT_VH_USER as _createUserInfo on $projection.crea_uname   = _createUserInfo.userName
    association [0..1] to ZPT_VH_USER as _updateUserInfo on $projection.lchg_uname   = _updateUserInfo.userName
{    
        @Search.defaultSearchElement: true
        @ObjectModel.readOnly: true
        @ObjectModel.foreignKey.association: '_task'
        key task_no,

        key code,
    
        @Search.ranking: #HIGH
        commentary,
        
        @ObjectModel.readOnly: true
        crea_date_time,
        
        @ObjectModel.readOnly: true
        @ObjectModel.foreignKey.association: '_createUserInfo'
        crea_uname,
        
        @ObjectModel.readOnly: true
        lchg_date_time,
    
        @ObjectModel.readOnly: true
        @ObjectModel.foreignKey.association: '_updateUserInfo'
        lchg_uname,
        
        @ObjectModel.association.type: [#TO_COMPOSITION_ROOT,#TO_COMPOSITION_PARENT]
        _task,
        
        _createUserInfo,
        _updateUserInfo
}
