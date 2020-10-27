@AbapCatalog.sqlViewName: 'ZPT_I_V_TR_T'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '传输请求文本'

@Search.searchable: true

@ObjectModel.dataCategory: #TEXT
@ObjectModel.representativeKey: [ 'request' ]

define view ZPT_I_TRAN_REQ_TEXT     
as select from e07t
{
    key trkorr as request,
    
    @Semantics.language: true
    key langu as language,
    
    @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    @Search.ranking: #HIGH
    as4text as text
}
