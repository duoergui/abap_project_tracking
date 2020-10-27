@AbapCatalog.sqlViewName: 'ZPT_I_V_PROJECT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '项目定义'

@Search.searchable: true

@ObjectModel: {
    modelCategory: #BUSINESS_OBJECT,
    compositionRoot: true,
    representativeKey: 'project_no',
    semanticKey: 'project_no',
    createEnabled: true,
    updateEnabled: true,
    deleteEnabled: true,
    transactionalProcessingEnabled: true,
    writeActivePersistence: 'ZPT_T_PROJECT'
}

define view ZPT_I_PROJECT as 
  select from zpt_t_project 
   association [0..1] to ZPT_VH_USER as _createdBy on $projection.crea_uname = _createdBy.userName
   association [0..1] to ZPT_VH_USER as _updatedBy on $projection.lchg_uname = _updatedBy.userName
  {

        @Search.defaultSearchElement: true
        @Search.ranking: #HIGH
        @ObjectModel.readOnly: 'EXTERNAL_CALCULATION'
        @ObjectModel.text.element: ['name']
        @ObjectModel.mandatory: true
        key project_no,
    
        @Search.defaultSearchElement: true
        @ObjectModel.mandatory: true
        @Search.ranking: #MEDIUM
        name,
        
        started_on,
        
        ended_on,
        
        tr_target,
    
        cts_project,
        
        @ObjectModel.readOnly: true
        crea_date_time,
        
        @ObjectModel.readOnly: true
        @ObjectModel.foreignKey.association: '_createdBy'
        crea_uname,
        
        @ObjectModel.readOnly: true
        lchg_date_time,
        
        @ObjectModel.readOnly: true
        @ObjectModel.foreignKey.association: '_updatedBy'
        lchg_uname,
        
        /* Associations */
//        @ObjectModel.association.type: #TO_COMPOSITION_CHILD 
        _createdBy,
        _updatedBy
}
