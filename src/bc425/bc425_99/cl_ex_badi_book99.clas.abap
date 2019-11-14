class CL_EX_BADI_BOOK99 definition
  public
  final
  create public .

*"* public components of class CL_EX_BADI_BOOK99
*"* do not include other source files here!!!
public section.

  interfaces IF_EX_BADI_BOOK99 .

  constants VERSION type VERSION value 000001. "#EC NOTEXT
  type-pools SXRT .
protected section.
*"* protected components of class CL_EX_BADI_BOOK99
*"* do not include other source files here!!!
private section.
*"* private components of class CL_EX_BADI_BOOK99
*"* do not include other source files here!!!

  type-pools SXRT .
  data INSTANCE_BADI_TABLE type SXRT_EXIT_TAB .
  data INSTANCE_FLT_CACHE type SXRT_FLT_CACHE_TAB .
ENDCLASS.



CLASS CL_EX_BADI_BOOK99 IMPLEMENTATION.


method IF_EX_BADI_BOOK99~CHANGE_VLINE .
  CLASS CL_EXIT_MASTER DEFINITION LOAD.
  DATA: EXIT_OBJ_TAB TYPE SXRT_EXIT_TAB,
        old_imp_class type seoclsname.
  DATA: exitintf TYPE REF TO IF_EX_BADI_BOOK99,
        wa_flt_cache TYPE sxrt_flt_cache_struct,
        flt_name TYPE FILTNAME.




  FIELD-SYMBOLS:
    <exit_obj>       TYPE SXRT_EXIT_TAB_STRUCT,
    <flt_cache_line> TYPE sxrt_flt_cache_struct.

  READ TABLE INSTANCE_FLT_CACHE
         WITH KEY flt_name    = flt_name
                  method_name = 'CHANGE_VLINE'
         TRANSPORTING NO FIELDS.
  IF sy-subrc NE 0.
    LOOP AT INSTANCE_BADI_TABLE ASSIGNING <exit_obj>
         WHERE INTER_NAME   = 'IF_EX_BADI_BOOK99'
           AND METHOD_NAME  = 'CHANGE_VLINE'.
      APPEND <exit_obj> TO EXIT_OBJ_TAB.
    ENDLOOP.

    IF sy-subrc = 4.
      CALL METHOD CL_EXIT_MASTER=>CREATE_OBJ_BY_INTERFACE_FILTER
         EXPORTING
            CALLER       = me
            INTER_NAME   = 'IF_EX_BADI_BOOK99'
            METHOD_NAME  = 'CHANGE_VLINE'

         IMPORTING
            exit_obj_tab = exit_obj_tab.

      APPEND LINES OF exit_obj_tab TO INSTANCE_BADI_TABLE.
    ENDIF.

    wa_flt_cache-flt_name    = flt_name.
    wa_flt_cache-valid       = sxrt_false.
    wa_flt_cache-method_name = 'CHANGE_VLINE'.

    LOOP at exit_obj_tab ASSIGNING <exit_obj>
        WHERE ACTIVE   = SXRT_TRUE
          AND RELEASED = SXRT_TRUE
          AND NOT obj IS INITIAL.

      CHECK <exit_obj>-imp_class NE old_imp_class.


        MOVE-CORRESPONDING <exit_obj> TO wa_flt_cache.
        wa_flt_cache-valid = sxrt_true.
        INSERT wa_flt_cache INTO TABLE INSTANCE_FLT_CACHE.
        old_imp_class = <exit_obj>-imp_class.

    ENDLOOP.
    IF wa_flt_cache-valid = sxrt_false.
      INSERT wa_flt_cache INTO TABLE INSTANCE_FLT_CACHE.
    ENDIF.
  ENDIF.

  LOOP AT INSTANCE_FLT_CACHE ASSIGNING <flt_cache_line>
       WHERE flt_name    = flt_name
         AND valid       = sxrt_true
         AND method_name = 'CHANGE_VLINE'.


    CALL FUNCTION 'PF_ASTAT_OPEN'
       EXPORTING
           OPENKEY = 'uH{gFRx663hX00002X569m'
           TYP     = 'UE'.

    CASE <flt_cache_line>-imp_switch.
      WHEN 'VSR'.
        DATA: exc        TYPE sfbm_xcptn,                  "#EC NEEDED
              data_ref   TYPE REF TO DATA.

        IF <flt_cache_line>-eo_object is initial.
          CALL METHOD ('CL_FOBU_METHOD_EVALUATION')=>load
               EXPORTING
                  im_class_name     = <flt_cache_line>-imp_class
                  im_interface_name = 'IF_EX_BADI_BOOK99'
                  im_method_name    = 'CHANGE_VLINE'
               RECEIVING
                  re_fobu_method    = <flt_cache_line>-eo_object
               EXCEPTIONS
                  not_found         = 1
                  OTHERS            = 2.
          IF sy-subrc = 2.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.
          CHECK sy-subrc = 0.
        ENDIF.


        CLEAR data_ref.
        GET REFERENCE OF C_POS INTO data_ref.
        CALL METHOD <flt_cache_line>-eo_object->set_parameter(
            im_parmname = 'C_POS'
            im_value    = data_ref ).

        CALL METHOD <flt_cache_line>-eo_object->evaluate
             IMPORTING
                ex_exception    = exc
             EXCEPTIONS
                raise_exception = 1
                OTHERS          = 2.
        IF sy-subrc = 2.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

        ENDIF.
      WHEN OTHERS.
        EXITINTF ?= <flt_cache_line>-OBJ.
        CALL METHOD EXITINTF->CHANGE_VLINE

           CHANGING
             C_POS = C_POS.


    ENDCASE.

    CALL FUNCTION 'PF_ASTAT_CLOSE'
       EXPORTING
           OPENKEY = 'uH{gFRx663hX00002X569m'
           TYP     = 'UE'.
  ENDLOOP.


endmethod.


method IF_EX_BADI_BOOK99~OUTPUT .
  CLASS CL_EXIT_MASTER DEFINITION LOAD.
  DATA: EXIT_OBJ_TAB TYPE SXRT_EXIT_TAB,
        old_imp_class type seoclsname.
  DATA: exitintf TYPE REF TO IF_EX_BADI_BOOK99,
        wa_flt_cache TYPE sxrt_flt_cache_struct,
        flt_name TYPE FILTNAME.




  FIELD-SYMBOLS:
    <exit_obj>       TYPE SXRT_EXIT_TAB_STRUCT,
    <flt_cache_line> TYPE sxrt_flt_cache_struct.

  READ TABLE INSTANCE_FLT_CACHE
         WITH KEY flt_name    = flt_name
                  method_name = 'OUTPUT'
         TRANSPORTING NO FIELDS.
  IF sy-subrc NE 0.
    LOOP AT INSTANCE_BADI_TABLE ASSIGNING <exit_obj>
         WHERE INTER_NAME   = 'IF_EX_BADI_BOOK99'
           AND METHOD_NAME  = 'OUTPUT'.
      APPEND <exit_obj> TO EXIT_OBJ_TAB.
    ENDLOOP.

    IF sy-subrc = 4.
      CALL METHOD CL_EXIT_MASTER=>CREATE_OBJ_BY_INTERFACE_FILTER
         EXPORTING
            CALLER       = me
            INTER_NAME   = 'IF_EX_BADI_BOOK99'
            METHOD_NAME  = 'OUTPUT'

         IMPORTING
            exit_obj_tab = exit_obj_tab.

      APPEND LINES OF exit_obj_tab TO INSTANCE_BADI_TABLE.
    ENDIF.

    wa_flt_cache-flt_name    = flt_name.
    wa_flt_cache-valid       = sxrt_false.
    wa_flt_cache-method_name = 'OUTPUT'.

    LOOP at exit_obj_tab ASSIGNING <exit_obj>
        WHERE ACTIVE   = SXRT_TRUE
          AND RELEASED = SXRT_TRUE
          AND NOT obj IS INITIAL.

      CHECK <exit_obj>-imp_class NE old_imp_class.


        MOVE-CORRESPONDING <exit_obj> TO wa_flt_cache.
        wa_flt_cache-valid = sxrt_true.
        INSERT wa_flt_cache INTO TABLE INSTANCE_FLT_CACHE.
        old_imp_class = <exit_obj>-imp_class.

    ENDLOOP.
    IF wa_flt_cache-valid = sxrt_false.
      INSERT wa_flt_cache INTO TABLE INSTANCE_FLT_CACHE.
    ENDIF.
  ENDIF.

  LOOP AT INSTANCE_FLT_CACHE ASSIGNING <flt_cache_line>
       WHERE flt_name    = flt_name
         AND valid       = sxrt_true
         AND method_name = 'OUTPUT'.


    CALL FUNCTION 'PF_ASTAT_OPEN'
       EXPORTING
           OPENKEY = 'sn{gFRx663hX00002X569m'
           TYP     = 'UE'.

    CASE <flt_cache_line>-imp_switch.
      WHEN 'VSR'.
        DATA: exc        TYPE sfbm_xcptn,                  "#EC NEEDED
              data_ref   TYPE REF TO DATA.

        IF <flt_cache_line>-eo_object is initial.
          CALL METHOD ('CL_FOBU_METHOD_EVALUATION')=>load
               EXPORTING
                  im_class_name     = <flt_cache_line>-imp_class
                  im_interface_name = 'IF_EX_BADI_BOOK99'
                  im_method_name    = 'OUTPUT'
               RECEIVING
                  re_fobu_method    = <flt_cache_line>-eo_object
               EXCEPTIONS
                  not_found         = 1
                  OTHERS            = 2.
          IF sy-subrc = 2.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.
          CHECK sy-subrc = 0.
        ENDIF.


        CLEAR data_ref.
        GET REFERENCE OF I_BOOKING INTO data_ref.
        CALL METHOD <flt_cache_line>-eo_object->set_parameter(
            im_parmname = 'I_BOOKING'
            im_value    = data_ref ).

        CALL METHOD <flt_cache_line>-eo_object->evaluate
             IMPORTING
                ex_exception    = exc
             EXCEPTIONS
                raise_exception = 1
                OTHERS          = 2.
        IF sy-subrc = 2.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

        ENDIF.
      WHEN OTHERS.
        EXITINTF ?= <flt_cache_line>-OBJ.
        CALL METHOD EXITINTF->OUTPUT
           EXPORTING
             I_BOOKING = I_BOOKING.


    ENDCASE.

    CALL FUNCTION 'PF_ASTAT_CLOSE'
       EXPORTING
           OPENKEY = 'sn{gFRx663hX00002X569m'
           TYP     = 'UE'.
  ENDLOOP.


endmethod.
ENDCLASS.
