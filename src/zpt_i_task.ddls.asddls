@AbapCatalog.sqlViewName: 'ZPT_I_V_TASK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '任务'


@Search.searchable: true

@ObjectModel: {
    modelCategory: #BUSINESS_OBJECT,
    compositionRoot: true,
    representativeKey: 'task_no',
    semanticKey: [ 'project_no', 'task_no' ],
    createEnabled: true,
    updateEnabled: 'EXTERNAL_CALCULATION',
    deleteEnabled: 'EXTERNAL_CALCULATION',
    transactionalProcessingEnabled: true, 
    writeActivePersistence: 'ZPT_T_TASK'
}


define view ZPT_I_TASK as select from zpt_t_task
    association [1]    to ZPT_I_PROJECT                as _project            on $projection.project_no             = _project.project_no
    association [0..1] to ZPT_VH_USER                  as _functionalUserInfo on $projection.functional_resp        = _functionalUserInfo.userName
    association [0..1] to ZPT_VH_USER                  as _technicalUserInfo  on $projection.technical_resp         = _technicalUserInfo.userName
    association [0..*] to ZPT_I_TASK_TRAN_REQ          as _transportRequests  on $projection.task_no                = _transportRequests.task_no
    association [0..*] to ZPT_I_TASK_COMMENT           as _comments           on $projection.task_no                = _comments.task_no 
    association [0..1] to ZPT_I_TASK_STATUS            as _status            on $projection.status                 = _status.status
  
 { 

      @Search.defaultSearchElement: true
      @ObjectModel.readOnly: 'EXTERNAL_CALCULATION'
      @ObjectModel.mandatory: true
      @ObjectModel.text.association: '_project'
      @Search.ranking: #HIGH
      @ObjectModel.foreignKey.association: '_project'
  key project_no,

      @ObjectModel: { 
          mandatory: true,
          readOnly: 'EXTERNAL_CALCULATION',
          text.element: ['description']
      }
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
  key task_no,

      @Search.defaultSearchElement: true
      @Search.ranking: #MEDIUM
      description,

      @Search.defaultSearchElement: true
      @ObjectModel.foreignKey.association: '_status'
      status,

      status_previous,

      progress,

      estimation,

      @ObjectModel.foreignKey.association: '_timeUnit'
      time_unit,

      plan_end_date,
 
      ended_on, 

      @ObjectModel.foreignKey.association: '_functionalUserInfo'
      @Semantics.user.responsible: true
      functional_resp,

      @ObjectModel.foreignKey.association: '_technicalUserInfo'
      @Semantics.user.responsible: true
      technical_resp,

      crea_date_time,

      crea_uname,

      lchg_date_time,

      lchg_uname,

      /* Associations */
      _project,
      @ObjectModel.association.type: #TO_COMPOSITION_CHILD
      _comments,
      @ObjectModel.association.type: #TO_COMPOSITION_CHILD
      _transportRequests,
      _functionalUserInfo,
      _technicalUserInfo
}
