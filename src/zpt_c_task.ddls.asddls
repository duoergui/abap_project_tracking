@AbapCatalog.sqlViewName: 'ZPT_C_V_TASK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '任务'

@Search.searchable: true
@OData.publish: true
@Metadata.allowExtensions

@ObjectModel: {
    representativeKey: 'task_no',
    semanticKey: [ 'project_no', 'task_no' ],
    createEnabled: true,
    updateEnabled: 'EXTERNAL_CALCULATION',
    deleteEnabled: 'EXTERNAL_CALCULATION',
    transactionalProcessingDelegated: true
}

@UI: {
    headerInfo: {
        typeName: '任务',
        typeNamePlural: '任务',
        title.label: 'Description',
        title.value: 'description',
        title.criticality: 'endCritically',
        description.label: 'Task code',
        description.value: 'code',
        description.criticality: 'endCritically'
    },
    lineItem:[{criticality:'endCritically'}]
}

define view ZPT_C_TASK
    as select from ZPT_I_TASK as task
    association [1] to ZPT_C_PROJECT                   as _project            on $projection.project_no  = _project.project_no
    association [0..1] to ZPT_VH_USER                  as _functionalUserInfo on $projection.functional_resp = _functionalUserInfo.userName
    association [0..1] to ZPT_VH_USER                  as _technicalUserInfo  on $projection.technical_resp = _technicalUserInfo.userName
    association [0..1] to ZPT_I_TASK_STATUS            as _status             on $projection.status         = _status.status 
    association [0..*] to ZPT_C_TASK_COMMENT           as _comments           on $projection.task_no        = _comments.task_no
    association [0..*] to ZPT_C_TASK_TRAN_REQ          as _transportRequests  on $projection.task_no        = _transportRequests.task_no 
{

        @Search: {
            defaultSearchElement: true,
            ranking: #HIGH,
            fuzzinessThreshold: 1
        }
        @UI: {
            identification: [
                {type: #FOR_ACTION, position: 2, dataAction: 'BOPF:CREATE_TR_WB', label: 'New Workbench TR'},
                {type: #FOR_ACTION, position: 3, dataAction: 'BOPF:CREATE_TR_CU', label: 'New Customizing TR'},
                {type: #FOR_ACTION, position: 8, dataAction: 'BOPF:CANCEL', label: 'Cancel'},
                {type: #FOR_ACTION, position: 8, dataAction: 'BOPF:BACK_PREVIOUS_VERSION', label: 'Restore status'},
                {type: #FOR_ACTION, position: 9, dataAction: 'BOPF:END_TASK', label: 'End task'},
                { position: 10, importance: #HIGH }
            ],
            lineItem: [
                {type: #FOR_ACTION, position: 1, dataAction: 'BOPF:CANCEL', label: 'Cancel'},
                {position: 10, importance: #HIGH }
            ],
            selectionField.position: 10,
            dataPoint.title: 'Project code'
        }
        @Consumption.valueHelp:'_project'
        @ObjectModel.foreignKey.association: '_project'
    key project_no,
    
        @Search: {
            defaultSearchElement: true,
            ranking: #HIGH,
            fuzzinessThreshold: 1
        }
        @UI: {
            identification: {
                position: 20,
                importance: #HIGH
            },
            lineItem: {
                position: 20,
                importance: #HIGH
            },
            selectionField.position: 20,
            dataPoint: {
                title: 'Task',
                criticality: 'endCritically'
            }
        }
    key task_no,
    
        @Search: {
            defaultSearchElement: true,
            ranking: #MEDIUM,
            fuzzinessThreshold: 0.8
        }
        @UI: {
            identification: {
                position: 30,
                importance: #HIGH
            },
            lineItem: {
                position: 30,
                importance: #HIGH
            },
            selectionField.position: 30
        }
        @ObjectModel.mandatory: true
        @Semantics.text: true
        description,
        
        @Search: {
            defaultSearchElement: true,
            ranking: #MEDIUM,
            fuzzinessThreshold: 1
        }
        @UI: {
            identification: {
                position: 35,
                importance: #HIGH
            },
            lineItem: {
                position: 35,
                importance: #HIGH
            },
            selectionField.position: 35
        }
        @ObjectModel.mandatory: true
        @Consumption.valueHelp:'_status'
        @Consumption.filter.defaultValue: ['OPEN']
        @ObjectModel.foreignKey.association: '_status'
        @UI.statusInfo: [ { position: 10 } ]
        status,
        
        @ObjectModel.readOnly: true
        case when progress < 33 then 1
             when progress > 66 then 3
                                else 2
             end as progressCriticality,
        
        @UI.identification: {position: 38, importance: #MEDIUM }
        @UI.lineItem: {position: 38, importance: #HIGH, type:#AS_DATAPOINT, criticality:'progressCriticality' }
        @UI.dataPoint: {
            title: 'Progress',
            description: 'Progress percentage',
            longDescription: 'Progress percentage',
            minimumValue: 0,
            maximumValue: 100,
            responsible: 'functional_responsible',
            targetValue: '100',
            visualization: #PROGRESS
        }
        progress,
        
        @UI.identification: {position: 40, importance: #MEDIUM }
        @UI.lineItem: {position: 40, importance: #HIGH }
        estimation,
         

        @Search.defaultSearchElement: true
        @UI.identification: {position: 60, importance: #MEDIUM, criticality: 'endCritically' }
        @UI.lineItem: {position: 60, importance: #MEDIUM, criticality: 'endCritically' }
        plan_end_date as planEndDate,

        @Search.defaultSearchElement: true
        @UI.identification: {position: 63, importance: #MEDIUM }
        @UI.lineItem: {position: 63, importance: #MEDIUM }
        ended_on as endDate,
         
        
        @Search: {
            defaultSearchElement: true,
            ranking: #MEDIUM,
            fuzzinessThreshold: 1
        }
        @UI: {
            identification: {
                position: 70,
                importance: #HIGH
            },
            lineItem: {
                position: 70,
                importance: #HIGH,
                type: #AS_CONTACT,
                label: 'Functional Responsible',
                value: '_functionalUserInfo'
            },
            selectionField.position: 70
        }
        @Consumption.valueHelp:'_functionalUserInfo'
        @ObjectModel.foreignKey.association: '_functionalUserInfo'
        functional_resp,
        
        @Search: {
            defaultSearchElement: true,
            ranking: #MEDIUM,
            fuzzinessThreshold: 1
        }
        @UI: {
            identification: {
                position: 80,
                importance: #MEDIUM
            },
            lineItem: {
                position: 80,
                importance: #MEDIUM,
                type: #AS_CONTACT,
                label: 'Technical Responsible',
                value: '_technicalUserInfo'
            },
            selectionField.position: 80
        }
        @Consumption.valueHelp:'_technicalUserInfo'
        @ObjectModel.foreignKey.association: '_technicalUserInfo'
        technical_resp,
        
        /* Associations */
        _project,
        @ObjectModel.association.type: #TO_COMPOSITION_CHILD
        _comments,
        @ObjectModel.association.type: #TO_COMPOSITION_CHILD
        _transportRequests, 
        @UI: { fieldGroup: [{ qualifier: 'Responsible', importance: #HIGH, position: 20, label: 'Functional Responsible Contact Details', type: #AS_CONTACT, value: '_functionalUserInfo'}],
               identification: [{ importance: #HIGH, position: 71, label: 'Functional Responsible Contact Details', type: #AS_CONTACT, value: '_functionalUserInfo'}]}
        _functionalUserInfo,
        @UI: { fieldGroup: [{ qualifier: 'Responsible', importance: #MEDIUM, position: 21, label: 'Technical Responsible Contact Details', type: #AS_CONTACT, value: '_technicalUserInfo'}],
               identification: [{ importance: #MEDIUM, position: 81, label: 'Technical Responsible Contact Details', type: #AS_CONTACT, value: '_technicalUserInfo'}]}
        _technicalUserInfo,
        _status
}
