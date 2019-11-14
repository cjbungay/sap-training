class CL_EX_BC_TAW12_CS_02 definition
  public
  final
  create public .

*"* public components of class CL_EX_BC_TAW12_CS_02
*"* do not include other source files here!!!
public section.

  interfaces IF_EX_BC_TAW12_CS_02 .

  class-data DYNPRO_INSTANCE type ref to IF_EX_BC_TAW12_CS_02 read-only
.
  constants VERSION type VERSION value 000001. "#EC NOTEXT

  class-methods GET_INSTANCE_FOR_SUBSCREEN
    returning
      value(INSTANCE) type ref to IF_EX_BC_TAW12_CS_02 .
  class-methods SET_INSTANCE_FOR_SUBSCREEN
    importing
      value(INSTANCE) type ref to IF_EX_BC_TAW12_CS_02 .
  type-pools SXRT .
protected section.
*"* protected components of class CL_EX_BC_TAW12_CS_02
*"* do not include other source files here!!!
private section.
*"* private components of class CL_EX_BC_TAW12_CS_02
*"* do not include other source files here!!!

  type-pools SXRT .
  data INSTANCE_BADI_TABLE type SXRT_EXIT_TAB .
  data INSTANCE_FLT_CACHE type SXRT_FLT_CACHE_TAB .
ENDCLASS.



CLASS CL_EX_BC_TAW12_CS_02 IMPLEMENTATION.


method GET_INSTANCE_FOR_SUBSCREEN .
  instance = CL_EX_BC_TAW12_CS_02=>DYNPRO_INSTANCE.
endmethod.


method IF_EX_BC_TAW12_CS_02~GET_KEY_DATA .
  CLASS CL_EXIT_MASTER DEFINITION LOAD.
  DATA: EXIT_OBJ_TAB TYPE SXRT_EXIT_TAB,
        old_imp_class type seoclsname.
  DATA: exitintf TYPE REF TO IF_EX_BC_TAW12_CS_02,
        wa_flt_cache TYPE sxrt_flt_cache_struct,
        flt_name TYPE FILTNAME.




  FIELD-SYMBOLS:
    <exit_obj>       TYPE SXRT_EXIT_TAB_STRUCT,
    <flt_cache_line> TYPE sxrt_flt_cache_struct.

  READ TABLE INSTANCE_FLT_CACHE
         WITH KEY flt_name    = flt_name
                  method_name = 'GET_KEY_DATA'
         TRANSPORTING NO FIELDS.
  IF sy-subrc NE 0.
    LOOP AT INSTANCE_BADI_TABLE ASSIGNING <exit_obj>
         WHERE INTER_NAME   = 'IF_EX_BC_TAW12_CS_02'
           AND METHOD_NAME  = 'GET_KEY_DATA'.
      APPEND <exit_obj> TO EXIT_OBJ_TAB.
    ENDLOOP.

    IF sy-subrc = 4.
      CALL METHOD CL_EXIT_MASTER=>CREATE_OBJ_BY_INTERFACE_FILTER
         EXPORTING
            CALLER       = me
            INTER_NAME   = 'IF_EX_BC_TAW12_CS_02'
            METHOD_NAME  = 'GET_KEY_DATA'

         IMPORTING
            exit_obj_tab = exit_obj_tab.

      APPEND LINES OF exit_obj_tab TO INSTANCE_BADI_TABLE.
    ENDIF.

    wa_flt_cache-flt_name    = flt_name.
    wa_flt_cache-valid       = sxrt_false.
    wa_flt_cache-method_name = 'GET_KEY_DATA'.

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
         AND method_name = 'GET_KEY_DATA'.


    CALL FUNCTION 'PF_ASTAT_OPEN'
       EXPORTING
           OPENKEY = 'WAZsFPPImoxX00002X569m'
           TYP     = 'UE'.

    CASE <flt_cache_line>-imp_switch.
      WHEN 'VSR'.
        DATA: exc        TYPE sfbm_xcptn,                  "#EC NEEDED
              data_ref   TYPE REF TO DATA.

        IF <flt_cache_line>-eo_object is initial.
          CALL METHOD ('CL_FOBU_METHOD_EVALUATION')=>load
               EXPORTING
                  im_class_name     = <flt_cache_line>-imp_class
                  im_interface_name = 'IF_EX_BC_TAW12_CS_02'
                  im_method_name    = 'GET_KEY_DATA'
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
        GET REFERENCE OF E_CARRID INTO data_ref.
        CALL METHOD <flt_cache_line>-eo_object->set_parameter(
            im_parmname = 'E_CARRID'
            im_value    = data_ref ).

        CLEAR data_ref.
        GET REFERENCE OF E_CONNID INTO data_ref.
        CALL METHOD <flt_cache_line>-eo_object->set_parameter(
            im_parmname = 'E_CONNID'
            im_value    = data_ref ).

        CLEAR data_ref.
        GET REFERENCE OF E_FLDATE INTO data_ref.
        CALL METHOD <flt_cache_line>-eo_object->set_parameter(
            im_parmname = 'E_FLDATE'
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
        CALL METHOD EXITINTF->GET_KEY_DATA

           IMPORTING
             E_CARRID = E_CARRID
             E_CONNID = E_CONNID
             E_FLDATE = E_FLDATE.


    ENDCASE.

    CALL FUNCTION 'PF_ASTAT_CLOSE'
       EXPORTING
           OPENKEY = 'WAZsFPPImoxX00002X569m'
           TYP     = 'UE'.
  ENDLOOP.


endmethod.


method IF_EX_BC_TAW12_CS_02~GET_MODUS .
  CLASS CL_EXIT_MASTER DEFINITION LOAD.
  DATA: EXIT_OBJ_TAB TYPE SXRT_EXIT_TAB,
        old_imp_class type seoclsname.
  DATA: exitintf TYPE REF TO IF_EX_BC_TAW12_CS_02,
        wa_flt_cache TYPE sxrt_flt_cache_struct,
        flt_name TYPE FILTNAME.




  FIELD-SYMBOLS:
    <exit_obj>       TYPE SXRT_EXIT_TAB_STRUCT,
    <flt_cache_line> TYPE sxrt_flt_cache_struct.

  READ TABLE INSTANCE_FLT_CACHE
         WITH KEY flt_name    = flt_name
                  method_name = 'GET_MODUS'
         TRANSPORTING NO FIELDS.
  IF sy-subrc NE 0.
    LOOP AT INSTANCE_BADI_TABLE ASSIGNING <exit_obj>
         WHERE INTER_NAME   = 'IF_EX_BC_TAW12_CS_02'
           AND METHOD_NAME  = 'GET_MODUS'.
      APPEND <exit_obj> TO EXIT_OBJ_TAB.
    ENDLOOP.

    IF sy-subrc = 4.
      CALL METHOD CL_EXIT_MASTER=>CREATE_OBJ_BY_INTERFACE_FILTER
         EXPORTING
            CALLER       = me
            INTER_NAME   = 'IF_EX_BC_TAW12_CS_02'
            METHOD_NAME  = 'GET_MODUS'

         IMPORTING
            exit_obj_tab = exit_obj_tab.

      APPEND LINES OF exit_obj_tab TO INSTANCE_BADI_TABLE.
    ENDIF.

    wa_flt_cache-flt_name    = flt_name.
    wa_flt_cache-valid       = sxrt_false.
    wa_flt_cache-method_name = 'GET_MODUS'.

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
         AND method_name = 'GET_MODUS'.


    CALL FUNCTION 'PF_ASTAT_OPEN'
       EXPORTING
           OPENKEY = 'cAZsFPPImoxX00002X569m'
           TYP     = 'UE'.

    CASE <flt_cache_line>-imp_switch.
      WHEN 'VSR'.
        DATA: exc        TYPE sfbm_xcptn,                  "#EC NEEDED
              data_ref   TYPE REF TO DATA.

        IF <flt_cache_line>-eo_object is initial.
          CALL METHOD ('CL_FOBU_METHOD_EVALUATION')=>load
               EXPORTING
                  im_class_name     = <flt_cache_line>-imp_class
                  im_interface_name = 'IF_EX_BC_TAW12_CS_02'
                  im_method_name    = 'GET_MODUS'
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
        GET REFERENCE OF E_MODE INTO data_ref.
        CALL METHOD <flt_cache_line>-eo_object->set_parameter(
            im_parmname = 'E_MODE'
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
        CALL METHOD EXITINTF->GET_MODUS

           IMPORTING
             E_MODE = E_MODE.


    ENDCASE.

    CALL FUNCTION 'PF_ASTAT_CLOSE'
       EXPORTING
           OPENKEY = 'cAZsFPPImoxX00002X569m'
           TYP     = 'UE'.
  ENDLOOP.


endmethod.


method IF_EX_BC_TAW12_CS_02~GET_TAB_NAME .
  CLASS CL_EXIT_MASTER DEFINITION LOAD.
  DATA: EXIT_OBJ_TAB TYPE SXRT_EXIT_TAB,
        old_imp_class type seoclsname.
  DATA: exitintf TYPE REF TO IF_EX_BC_TAW12_CS_02,
        wa_flt_cache TYPE sxrt_flt_cache_struct,
        flt_name TYPE FILTNAME.




  FIELD-SYMBOLS:
    <exit_obj>       TYPE SXRT_EXIT_TAB_STRUCT,
    <flt_cache_line> TYPE sxrt_flt_cache_struct.

  READ TABLE INSTANCE_FLT_CACHE
         WITH KEY flt_name    = flt_name
                  method_name = 'GET_TAB_NAME'
         TRANSPORTING NO FIELDS.
  IF sy-subrc NE 0.
    LOOP AT INSTANCE_BADI_TABLE ASSIGNING <exit_obj>
         WHERE INTER_NAME   = 'IF_EX_BC_TAW12_CS_02'
           AND METHOD_NAME  = 'GET_TAB_NAME'.
      APPEND <exit_obj> TO EXIT_OBJ_TAB.
    ENDLOOP.

    IF sy-subrc = 4.
      CALL METHOD CL_EXIT_MASTER=>CREATE_OBJ_BY_INTERFACE_FILTER
         EXPORTING
            CALLER       = me
            INTER_NAME   = 'IF_EX_BC_TAW12_CS_02'
            METHOD_NAME  = 'GET_TAB_NAME'

         IMPORTING
            exit_obj_tab = exit_obj_tab.

      APPEND LINES OF exit_obj_tab TO INSTANCE_BADI_TABLE.
    ENDIF.

    wa_flt_cache-flt_name    = flt_name.
    wa_flt_cache-valid       = sxrt_false.
    wa_flt_cache-method_name = 'GET_TAB_NAME'.

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
         AND method_name = 'GET_TAB_NAME'.


    CALL FUNCTION 'PF_ASTAT_OPEN'
       EXPORTING
           OPENKEY = 'XgZsFPPImoxX00002X569m'
           TYP     = 'UE'.

    CASE <flt_cache_line>-imp_switch.
      WHEN 'VSR'.
        DATA: exc        TYPE sfbm_xcptn,                  "#EC NEEDED
              data_ref   TYPE REF TO DATA.

        IF <flt_cache_line>-eo_object is initial.
          CALL METHOD ('CL_FOBU_METHOD_EVALUATION')=>load
               EXPORTING
                  im_class_name     = <flt_cache_line>-imp_class
                  im_interface_name = 'IF_EX_BC_TAW12_CS_02'
                  im_method_name    = 'GET_TAB_NAME'
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
        GET REFERENCE OF TABNAME INTO data_ref.
        CALL METHOD <flt_cache_line>-eo_object->set_parameter(
            im_parmname = 'TABNAME'
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
        CALL METHOD EXITINTF->GET_TAB_NAME

           IMPORTING
             TABNAME = TABNAME.


    ENDCASE.

    CALL FUNCTION 'PF_ASTAT_CLOSE'
       EXPORTING
           OPENKEY = 'XgZsFPPImoxX00002X569m'
           TYP     = 'UE'.
  ENDLOOP.


endmethod.


method IF_EX_BC_TAW12_CS_02~PROCESS_FCODE .
  CLASS CL_EXIT_MASTER DEFINITION LOAD.
  DATA: EXIT_OBJ_TAB TYPE SXRT_EXIT_TAB,
        old_imp_class type seoclsname.
  DATA: exitintf TYPE REF TO IF_EX_BC_TAW12_CS_02,
        wa_flt_cache TYPE sxrt_flt_cache_struct,
        flt_name TYPE FILTNAME.




  FIELD-SYMBOLS:
    <exit_obj>       TYPE SXRT_EXIT_TAB_STRUCT,
    <flt_cache_line> TYPE sxrt_flt_cache_struct.

  READ TABLE INSTANCE_FLT_CACHE
         WITH KEY flt_name    = flt_name
                  method_name = 'PROCESS_FCODE'
         TRANSPORTING NO FIELDS.
  IF sy-subrc NE 0.
    LOOP AT INSTANCE_BADI_TABLE ASSIGNING <exit_obj>
         WHERE INTER_NAME   = 'IF_EX_BC_TAW12_CS_02'
           AND METHOD_NAME  = 'PROCESS_FCODE'.
      APPEND <exit_obj> TO EXIT_OBJ_TAB.
    ENDLOOP.

    IF sy-subrc = 4.
      CALL METHOD CL_EXIT_MASTER=>CREATE_OBJ_BY_INTERFACE_FILTER
         EXPORTING
            CALLER       = me
            INTER_NAME   = 'IF_EX_BC_TAW12_CS_02'
            METHOD_NAME  = 'PROCESS_FCODE'

         IMPORTING
            exit_obj_tab = exit_obj_tab.

      APPEND LINES OF exit_obj_tab TO INSTANCE_BADI_TABLE.
    ENDIF.

    wa_flt_cache-flt_name    = flt_name.
    wa_flt_cache-valid       = sxrt_false.
    wa_flt_cache-method_name = 'PROCESS_FCODE'.

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
         AND method_name = 'PROCESS_FCODE'.


    CALL FUNCTION 'PF_ASTAT_OPEN'
       EXPORTING
           OPENKEY = 'ZAZsFPPImoxX00002X569m'
           TYP     = 'UE'.

    CASE <flt_cache_line>-imp_switch.
      WHEN 'VSR'.
        DATA: exc        TYPE sfbm_xcptn,                  "#EC NEEDED
              data_ref   TYPE REF TO DATA.

        IF <flt_cache_line>-eo_object is initial.
          CALL METHOD ('CL_FOBU_METHOD_EVALUATION')=>load
               EXPORTING
                  im_class_name     = <flt_cache_line>-imp_class
                  im_interface_name = 'IF_EX_BC_TAW12_CS_02'
                  im_method_name    = 'PROCESS_FCODE'
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
        GET REFERENCE OF FCODE INTO data_ref.
        CALL METHOD <flt_cache_line>-eo_object->set_parameter(
            im_parmname = 'FCODE'
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
        CALL METHOD EXITINTF->PROCESS_FCODE
           EXPORTING
             FCODE = FCODE.


    ENDCASE.

    CALL FUNCTION 'PF_ASTAT_CLOSE'
       EXPORTING
           OPENKEY = 'ZAZsFPPImoxX00002X569m'
           TYP     = 'UE'.
  ENDLOOP.


endmethod.


method IF_EX_BC_TAW12_CS_02~PUT_KEY_DATA .
  CLASS CL_EXIT_MASTER DEFINITION LOAD.
  DATA: EXIT_OBJ_TAB TYPE SXRT_EXIT_TAB,
        old_imp_class type seoclsname.
  DATA: exitintf TYPE REF TO IF_EX_BC_TAW12_CS_02,
        wa_flt_cache TYPE sxrt_flt_cache_struct,
        flt_name TYPE FILTNAME.




  FIELD-SYMBOLS:
    <exit_obj>       TYPE SXRT_EXIT_TAB_STRUCT,
    <flt_cache_line> TYPE sxrt_flt_cache_struct.

  READ TABLE INSTANCE_FLT_CACHE
         WITH KEY flt_name    = flt_name
                  method_name = 'PUT_KEY_DATA'
         TRANSPORTING NO FIELDS.
  IF sy-subrc NE 0.
    LOOP AT INSTANCE_BADI_TABLE ASSIGNING <exit_obj>
         WHERE INTER_NAME   = 'IF_EX_BC_TAW12_CS_02'
           AND METHOD_NAME  = 'PUT_KEY_DATA'.
      APPEND <exit_obj> TO EXIT_OBJ_TAB.
    ENDLOOP.

    IF sy-subrc = 4.
      CALL METHOD CL_EXIT_MASTER=>CREATE_OBJ_BY_INTERFACE_FILTER
         EXPORTING
            CALLER       = me
            INTER_NAME   = 'IF_EX_BC_TAW12_CS_02'
            METHOD_NAME  = 'PUT_KEY_DATA'

         IMPORTING
            exit_obj_tab = exit_obj_tab.

      APPEND LINES OF exit_obj_tab TO INSTANCE_BADI_TABLE.
    ENDIF.

    wa_flt_cache-flt_name    = flt_name.
    wa_flt_cache-valid       = sxrt_false.
    wa_flt_cache-method_name = 'PUT_KEY_DATA'.

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
         AND method_name = 'PUT_KEY_DATA'.


    CALL FUNCTION 'PF_ASTAT_OPEN'
       EXPORTING
           OPENKEY = 'UgZsFPPImoxX00002X569m'
           TYP     = 'UE'.

    CASE <flt_cache_line>-imp_switch.
      WHEN 'VSR'.
        DATA: exc        TYPE sfbm_xcptn,                  "#EC NEEDED
              data_ref   TYPE REF TO DATA.

        IF <flt_cache_line>-eo_object is initial.
          CALL METHOD ('CL_FOBU_METHOD_EVALUATION')=>load
               EXPORTING
                  im_class_name     = <flt_cache_line>-imp_class
                  im_interface_name = 'IF_EX_BC_TAW12_CS_02'
                  im_method_name    = 'PUT_KEY_DATA'
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
        GET REFERENCE OF I_CARRID INTO data_ref.
        CALL METHOD <flt_cache_line>-eo_object->set_parameter(
            im_parmname = 'I_CARRID'
            im_value    = data_ref ).

        CLEAR data_ref.
        GET REFERENCE OF I_CONNID INTO data_ref.
        CALL METHOD <flt_cache_line>-eo_object->set_parameter(
            im_parmname = 'I_CONNID'
            im_value    = data_ref ).

        CLEAR data_ref.
        GET REFERENCE OF I_FLDATE INTO data_ref.
        CALL METHOD <flt_cache_line>-eo_object->set_parameter(
            im_parmname = 'I_FLDATE'
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
        CALL METHOD EXITINTF->PUT_KEY_DATA
           EXPORTING
             I_CARRID = I_CARRID
             I_CONNID = I_CONNID
             I_FLDATE = I_FLDATE.


    ENDCASE.

    CALL FUNCTION 'PF_ASTAT_CLOSE'
       EXPORTING
           OPENKEY = 'UgZsFPPImoxX00002X569m'
           TYP     = 'UE'.
  ENDLOOP.


endmethod.


method IF_EX_BC_TAW12_CS_02~PUT_MODUS .
  CLASS CL_EXIT_MASTER DEFINITION LOAD.
  DATA: EXIT_OBJ_TAB TYPE SXRT_EXIT_TAB,
        old_imp_class type seoclsname.
  DATA: exitintf TYPE REF TO IF_EX_BC_TAW12_CS_02,
        wa_flt_cache TYPE sxrt_flt_cache_struct,
        flt_name TYPE FILTNAME.




  FIELD-SYMBOLS:
    <exit_obj>       TYPE SXRT_EXIT_TAB_STRUCT,
    <flt_cache_line> TYPE sxrt_flt_cache_struct.

  READ TABLE INSTANCE_FLT_CACHE
         WITH KEY flt_name    = flt_name
                  method_name = 'PUT_MODUS'
         TRANSPORTING NO FIELDS.
  IF sy-subrc NE 0.
    LOOP AT INSTANCE_BADI_TABLE ASSIGNING <exit_obj>
         WHERE INTER_NAME   = 'IF_EX_BC_TAW12_CS_02'
           AND METHOD_NAME  = 'PUT_MODUS'.
      APPEND <exit_obj> TO EXIT_OBJ_TAB.
    ENDLOOP.

    IF sy-subrc = 4.
      CALL METHOD CL_EXIT_MASTER=>CREATE_OBJ_BY_INTERFACE_FILTER
         EXPORTING
            CALLER       = me
            INTER_NAME   = 'IF_EX_BC_TAW12_CS_02'
            METHOD_NAME  = 'PUT_MODUS'

         IMPORTING
            exit_obj_tab = exit_obj_tab.

      APPEND LINES OF exit_obj_tab TO INSTANCE_BADI_TABLE.
    ENDIF.

    wa_flt_cache-flt_name    = flt_name.
    wa_flt_cache-valid       = sxrt_false.
    wa_flt_cache-method_name = 'PUT_MODUS'.

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
         AND method_name = 'PUT_MODUS'.


    CALL FUNCTION 'PF_ASTAT_OPEN'
       EXPORTING
           OPENKEY = 'TAZsFPPImoxX00002X569m'
           TYP     = 'UE'.

    CASE <flt_cache_line>-imp_switch.
      WHEN 'VSR'.
        DATA: exc        TYPE sfbm_xcptn,                  "#EC NEEDED
              data_ref   TYPE REF TO DATA.

        IF <flt_cache_line>-eo_object is initial.
          CALL METHOD ('CL_FOBU_METHOD_EVALUATION')=>load
               EXPORTING
                  im_class_name     = <flt_cache_line>-imp_class
                  im_interface_name = 'IF_EX_BC_TAW12_CS_02'
                  im_method_name    = 'PUT_MODUS'
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
        GET REFERENCE OF I_MODE INTO data_ref.
        CALL METHOD <flt_cache_line>-eo_object->set_parameter(
            im_parmname = 'I_MODE'
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
        CALL METHOD EXITINTF->PUT_MODUS
           EXPORTING
             I_MODE = I_MODE.


    ENDCASE.

    CALL FUNCTION 'PF_ASTAT_CLOSE'
       EXPORTING
           OPENKEY = 'TAZsFPPImoxX00002X569m'
           TYP     = 'UE'.
  ENDLOOP.


endmethod.


method IF_EX_BC_TAW12_CS_02~SAVE .
  CLASS CL_EXIT_MASTER DEFINITION LOAD.
  DATA: EXIT_OBJ_TAB TYPE SXRT_EXIT_TAB,
        old_imp_class type seoclsname.
  DATA: exitintf TYPE REF TO IF_EX_BC_TAW12_CS_02,
        wa_flt_cache TYPE sxrt_flt_cache_struct,
        flt_name TYPE FILTNAME.




  FIELD-SYMBOLS:
    <exit_obj>       TYPE SXRT_EXIT_TAB_STRUCT,
    <flt_cache_line> TYPE sxrt_flt_cache_struct.

  READ TABLE INSTANCE_FLT_CACHE
         WITH KEY flt_name    = flt_name
                  method_name = 'SAVE'
         TRANSPORTING NO FIELDS.
  IF sy-subrc NE 0.
    LOOP AT INSTANCE_BADI_TABLE ASSIGNING <exit_obj>
         WHERE INTER_NAME   = 'IF_EX_BC_TAW12_CS_02'
           AND METHOD_NAME  = 'SAVE'.
      APPEND <exit_obj> TO EXIT_OBJ_TAB.
    ENDLOOP.

    IF sy-subrc = 4.
      CALL METHOD CL_EXIT_MASTER=>CREATE_OBJ_BY_INTERFACE_FILTER
         EXPORTING
            CALLER       = me
            INTER_NAME   = 'IF_EX_BC_TAW12_CS_02'
            METHOD_NAME  = 'SAVE'

         IMPORTING
            exit_obj_tab = exit_obj_tab.

      APPEND LINES OF exit_obj_tab TO INSTANCE_BADI_TABLE.
    ENDIF.

    wa_flt_cache-flt_name    = flt_name.
    wa_flt_cache-valid       = sxrt_false.
    wa_flt_cache-method_name = 'SAVE'.

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
         AND method_name = 'SAVE'.


    CALL FUNCTION 'PF_ASTAT_OPEN'
       EXPORTING
           OPENKEY = 'agZsFPPImoxX00002X569m'
           TYP     = 'UE'.

    CASE <flt_cache_line>-imp_switch.
      WHEN 'VSR'.
        DATA: exc        TYPE sfbm_xcptn,                  "#EC NEEDED
              data_ref   TYPE REF TO DATA.

        IF <flt_cache_line>-eo_object is initial.
          CALL METHOD ('CL_FOBU_METHOD_EVALUATION')=>load
               EXPORTING
                  im_class_name     = <flt_cache_line>-imp_class
                  im_interface_name = 'IF_EX_BC_TAW12_CS_02'
                  im_method_name    = 'SAVE'
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
        GET REFERENCE OF I_BOOKID INTO data_ref.
        CALL METHOD <flt_cache_line>-eo_object->set_parameter(
            im_parmname = 'I_BOOKID'
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
        CALL METHOD EXITINTF->SAVE
           EXPORTING
             I_BOOKID = I_BOOKID.


    ENDCASE.

    CALL FUNCTION 'PF_ASTAT_CLOSE'
       EXPORTING
           OPENKEY = 'agZsFPPImoxX00002X569m'
           TYP     = 'UE'.
  ENDLOOP.


endmethod.


method SET_INSTANCE_FOR_SUBSCREEN .
CL_EX_BC_TAW12_CS_02=>DYNPRO_INSTANCE = instance.
endmethod.
ENDCLASS.
