@AbapCatalog.sqlViewName: 'ZPT_I_V_DOM_T'
@AccessControl.authorizationCheck: #NOT_REQUIRED
                        
@Search.searchable: true

@ObjectModel.dataCategory: #TEXT
@ObjectModel.representativeKey: [ 'domainName', 'valuePosition' ]

define view ZPT_I_DOMAIN_TEXT
    as select from dd07t as textProvider
{

    key domname as domainName,
    key valpos as valuePosition,
    @Semantics.language: true
    key ddlanguage as language,
    @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    @Search.ranking: #HIGH
    ddtext as shortText
    
} where as4local = 'A';
