@AbapCatalog.sqlViewName: 'ZPT_I_V_STATUS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '任务状态' 
@Search.searchable: true

@ObjectModel: {
    representativeKey: 'status',
    resultSet.sizeCategory: #XS
}

@UI.headerInfo.typeName: '状态'
@UI.headerInfo.typeNamePlural: '状态'
@UI.headerInfo.title.value: 'status'

define view ZPT_I_TASK_STATUS
    as select from dd07l as status
    association [0..*] to ZPT_I_DOMAIN_TEXT as _text on _text.domainName    = 'ZD_PT_TASK_STATUS'
                                                      and _text.valuePosition = status.valpos
{
    @ObjectModel.text.association: '_text'
    @Search: { defaultSearchElement: true, ranking: #HIGH }
    key cast( domvalue_l as ze_pt_task_status ) as status,
    
    @Consumption.hidden: true
    valpos,
    
    _text
    
} where status.domname = 'ZD_PT_TASK_STATUS'
    and status.as4local = 'A';
