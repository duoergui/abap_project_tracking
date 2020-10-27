CLASS zcl_pt_d_task_at_creation DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_d_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /bobf/if_frw_determination~execute
        REDEFINITION .
protected section.
    "! <p class="shorttext synchronized" lang="zh">修改字段</p>
    "!
    "! @parameter task | <p class="shorttext synchronized" lang="zh">Task</p>
  methods FILL
    changing
      !TASK type ZSPTI_TASK .
private section.

  types:
    ty_number TYPE n LENGTH 5 .
  types:
    BEGIN OF ts_last_project_number,
        project_no TYPE ze_pt_project_no,
        number     TYPE ty_number,
      END OF ts_last_project_number .
  types:
    tt_last_project_number TYPE HASHED TABLE OF ts_last_project_number WITH UNIQUE KEY project_no .

  data READ type ref to /BOBF/IF_FRW_READ .
  data CONTEXT type /BOBF/S_FRW_CTX_DET .
  data LAST_PROJECT_NUMBERS type TT_LAST_PROJECT_NUMBER .

  methods GET_NEXT_NUMBER
  IMPORTING
        project_no       TYPE ze_pt_project_no
      RETURNING
        VALUE(next_number) TYPE ty_number.
ENDCLASS.



CLASS ZCL_PT_D_TASK_AT_CREATION IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA: lt_task TYPE ztpti_task.

    CLEAR: eo_message, et_failed_key.

    IF is_ctx-exectime <> /bobf/if_conf_c=>sc_time_after_modify.
      RAISE EXCEPTION TYPE /bobf/cx_lib
        EXPORTING
          textid = /bobf/cx_lib=>wrong_determination_time.
    ENDIF.

    io_read->retrieve( EXPORTING iv_node = is_ctx-node_key
                                 it_key  = it_key
                       IMPORTING et_data = lt_task ).

    read = io_read.
    context = is_ctx.

    LOOP AT lt_task INTO DATA(task).

      fill( CHANGING task = task ).

      io_modify->update( iv_node = is_ctx-node_key
                         iv_key  = task-key
                         is_data = REF #( task ) ).

    ENDLOOP.
  ENDMETHOD.


  METHOD fill.
    DATA: number TYPE n LENGTH 5.

    IF task-time_unit IS INITIAL.
      task-time_unit = 'HOUR'.
    ENDIF.

    IF task-task_no IS INITIAL.
      task-task_no = |{ task-project_no }-{ get_next_number( task-project_no ) }|.
    ENDIF.

  ENDMETHOD.


  METHOD get_next_number.

    IF project_no IS INITIAL.
      RETURN.
    ENDIF.

    READ TABLE last_project_numbers ASSIGNING FIELD-SYMBOL(<last_project_number>)
      WITH KEY project_no = project_no.
    IF sy-subrc <> 0.

      INSERT VALUE #( project_no = project_no ) INTO TABLE last_project_numbers
        ASSIGNING <last_project_number>.

      SELECT COUNT(*)
        INTO @DATA(count)
        FROM zpt_t_task
        WHERE project_no = @project_no.
      <last_project_number>-number = count.

    ENDIF.

    <last_project_number>-number = <last_project_number>-number + 1.

    next_number = <last_project_number>-number.
  ENDMETHOD.
ENDCLASS.
