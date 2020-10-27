@AbapCatalog.sqlViewName: 'ZPT_I_V_TR_STAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '传输请求状态'

@ObjectModel: {
    representativeKey: 'status',
    resultSet.sizeCategory: #XS
}

@UI.headerInfo.typeName: '请求传输状态'
@UI.headerInfo.typeNamePlural: '请求传输状态'
@UI.headerInfo.title.value: '状态'

@Search.searchable: true

define view ZPT_I_TR_STATUS     
    as select from dd07l
    association [0..*] to ZPT_I_DOMAIN_TEXT as _text on _text.domainName    = 'TRSTATUS'
                                                     and _text.valuePosition = dd07l.valpos
{
    @ObjectModel.text.association: '_text'
    @Search.defaultSearchElement: true
    @Search.ranking: #HIGH
    key cast( dd07l.domvalue_l as trstatus ) as status,
    
    @Consumption.hidden: true
    valpos,
    
    _text
    
} where dd07l.domname  = 'TRSTATUS'
    and dd07l.as4local = 'A';
