@AbapCatalog.sqlViewName: 'ZPT_I_V_T_TR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '任务单的请求列表'

@Search.searchable: true

@ObjectModel: {
    modelCategory: #BUSINESS_OBJECT,
    representativeKey: 'transport_request',
    semanticKey: ['task_no', 'transport_request' ],
    createEnabled: true,
    updateEnabled: true,
    deleteEnabled: true,
    transactionalProcessingEnabled: true,
    writeActivePersistence: 'ZPT_T_TRAN_REQ'
}

define view ZPT_I_TASK_TRAN_REQ
    as select from zpt_t_tran_req 
    association [1]    to ZPT_I_TASK               as _task           on $projection.task_no   = _task.task_no
    association [1]    to ZPT_I_TRAN_REQ           as _request        on $projection.transport_request = _request.request    
    association [0..1] to ZPT_VH_USER              as _createUserInfo on $projection.crea_uname = _createUserInfo.userName
    association [0..1] to ZPT_VH_USER              as _updateUserInfo on $projection.lchg_uname  = _updateUserInfo.userName
{
         @Search.defaultSearchElement: true
        @ObjectModel: {
            mandatory: true,
            readOnly: true, 
            text.association: '_project',
            foreignKey.association: '_project'
        }
    key task_no,
        @Search.ranking: #HIGH
        @ObjectModel: {
            mandatory: true,
            readOnly: 'EXTERNAL_CALCULATION',
            foreignKey.association: '_request'
        }
    key transport_request,
        
        @Semantics.text
        commentary,
        
        @ObjectModel.readOnly: true
        crea_date_time,
        
        @ObjectModel.readOnly: true
        @ObjectModel.foreignKey.association: '_createUserInfo'
        @ObjectModel.text.association: '_createUserInfo'
        crea_uname,
        
        @ObjectModel.readOnly: true
        lchg_date_time,
        
        @ObjectModel.readOnly: true
        @ObjectModel.foreignKey.association: '_updateUserInfo'
        @ObjectModel.text.association: '_updateUserInfo'
        lchg_uname,
        
         @ObjectModel.association.type: [#TO_COMPOSITION_ROOT,#TO_COMPOSITION_PARENT]
        _task,
        
        _request,
        _createUserInfo,
        _updateUserInfo

} where _request.request <> ''
