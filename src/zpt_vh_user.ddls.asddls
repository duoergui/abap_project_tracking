@AbapCatalog.sqlViewName: 'ZPT_VH_V_USER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '用户搜索帮助'

@Search.searchable: true

@ObjectModel: {
    representativeKey: 'userName'
}

define view ZPT_VH_USER as 
        select from ZPT_I_USER {

        @ObjectModel.text.element: ['name']
        @Semantics.contact.type: #PERSON
        key userName,
    
        @Search.defaultSearchElement: true
        @Search.fuzzinessThreshold: 0.8
        @Search.ranking: #HIGH
        @Semantics.name.fullName: true
        @Semantics.text: true
        _userInfo.name_text as name,
        
        @Semantics.name.givenName: true
        _userInfo.name_first as firstName,
        
        @Semantics.name.familyName: true
        _userInfo.name_last as lastName,
        
        @Semantics.name.additionalName: true
        _userInfo.namemiddle as middleName,
        
        @Semantics.eMail.type: [#PREF,#WORK]
        _emailAddress.smtp_addr as email,

        @Semantics.telephone.type: [#PREF,#WORK]
        _businessAddress.tel_number as telephone
    
} where userType = 'A' or userType = 'L' or userType = 'C'
