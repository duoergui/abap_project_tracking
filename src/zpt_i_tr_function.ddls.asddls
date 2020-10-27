@AbapCatalog.sqlViewName: 'ZPT_I_V_TR_FUNC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '传输请求功能'

@ObjectModel: {
    representativeKey: 'function',
    resultSet.sizeCategory: #XS
}

@UI.headerInfo.typeName: '传输请求功能'
@UI.headerInfo.typeNamePlural: '传输请求功能'
@UI.headerInfo.title.value: '功能'

@Search.searchable: true
define view ZPT_I_TR_FUNCTION 
   as select from dd07l
    association [0..*] to ZPT_I_DOMAIN_TEXT as _text on _text.domainName    = 'TRFUNCTION'
                       and _text.valuePosition = dd07l.valpos
{
    @ObjectModel.text.association: '_text'
    @Search.defaultSearchElement: true
    @Search.ranking: #HIGH
    key cast( dd07l.domvalue_l as trfunction ) as function,
    
    @Consumption.hidden: true
    valpos,
    
    _text
    
} where dd07l.domname  = 'TRFUNCTION'
    and dd07l.as4local = 'A';
