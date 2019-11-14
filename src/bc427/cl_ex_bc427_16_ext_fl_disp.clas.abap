class CL_EX_BC427_16_EXT_FL_DISP definition
  public
  final
  create public .

*"* public components of class CL_EX_BC427_16_EXT_FL_DISP
*"* do not include other source files here!!!
public section.

  interfaces IF_EX_BC427_16_EXT_FL_DISP .

  constants VERSION type VERSION value 000001. "#EC NOTEXT
  type-pools SXRT .
protected section.
*"* protected components of class CL_EX_BC427_16_EXT_FL_DISP
*"* do not include other source files here!!!
private section.
*"* private components of class CL_EX_BC427_16_EXT_FL_DISP
*"* do not include other source files here!!!

  data INSTANCE_BADI_TABLE type SXRT_EXIT_TAB .
  data INSTANCE_FLT_CACHE type SXRT_FLT_CACHE_TAB .
ENDCLASS.



CLASS CL_EX_BC427_16_EXT_FL_DISP IMPLEMENTATION.


method IF_EX_BC427_16_EXT_FL_DISP~WRITE_ADDITIONAL_COLS.
  CLASS CL_EXIT_MASTER DEFINITION LOAD.
  DATA: EXIT_OBJ_TAB TYPE SXRT_EXIT_TAB.

  DATA: exitintf TYPE REF TO IF_EX_BC427_16_EXT_FL_DISP,
        wa_flt_cache_line TYPE REF TO sxrt_flt_cache_struct,
        flt_name TYPE FILTNAME.


  FIELD-SYMBOLS:
    <exit_obj>       TYPE SXRT_EXIT_TAB_STRUCT,
    <flt_cache_line> TYPE sxrt_flt_cache_struct.

  READ TABLE INSTANCE_FLT_CACHE
         WITH KEY flt_name    = flt_name
                  method_name = 'WRITE_ADDITIONAL_COLS'
         TRANSPORTING NO FIELDS.
  IF sy-subrc NE 0.

    CREATE DATA wa_flt_cache_line TYPE sxrt_flt_cache_struct.
    ASSIGN wa_flt_cache_line->* TO <flt_cache_line>.
    <flt_cache_line>-flt_name    = flt_name.
    <flt_cache_line>-method_name = 'WRITE_ADDITIONAL_COLS'.


      LOOP AT INSTANCE_BADI_TABLE ASSIGNING <exit_obj>
           WHERE METHOD_NAME  = 'WRITE_ADDITIONAL_COLS'.
        APPEND <exit_obj> TO EXIT_OBJ_TAB.
      ENDLOOP.
      IF sy-subrc ne 0.
        CALL METHOD CL_EXIT_MASTER=>CREATE_OBJ_BY_INTERFACE_FILTER
           EXPORTING
              CALLER       = me
              INTER_NAME   = 'IF_EX_BC427_16_EXT_FL_DISP'
              METHOD_NAME  = 'WRITE_ADDITIONAL_COLS'

              delayed_instance_creation    = sxrt_true
           IMPORTING
               exit_obj_tab = exit_obj_tab.

        APPEND LINES OF exit_obj_tab TO INSTANCE_BADI_TABLE.
      ENDIF.

      <flt_cache_line>-valid = sxrt_false.

      LOOP at exit_obj_tab ASSIGNING <exit_obj>
          WHERE ACTIVE   = SXRT_TRUE.

        <flt_cache_line>-valid = sxrt_true.



          <flt_cache_line>-obj =
               CL_EXIT_MASTER=>instantiate_imp_class(
                        CALLER       = me
                        imp_name  = <exit_obj>-imp_name
                        imp_class = <exit_obj>-imp_class ).
          MOVE <exit_obj>-imp_class to <flt_cache_line>-imp_class.
          MOVE <exit_obj>-imp_switch to <flt_cache_line>-imp_switch.
          MOVE <exit_obj>-order_num to <flt_cache_line>-order_num.
          INSERT <flt_cache_line> INTO TABLE INSTANCE_FLT_CACHE.


      ENDLOOP.
      IF <flt_cache_line>-valid = sxrt_false.
        INSERT <flt_cache_line> INTO TABLE INSTANCE_FLT_CACHE.
      ENDIF.
  ENDIF.

  LOOP AT INSTANCE_FLT_CACHE ASSIGNING <flt_cache_line>
       WHERE flt_name    = flt_name
         AND valid       = sxrt_true
         AND method_name = 'WRITE_ADDITIONAL_COLS'.


    CALL FUNCTION 'PF_ASTAT_OPEN'
       EXPORTING
           OPENKEY = 'Hg}qwPkYH2VX00002a92EG'
           TYP     = 'UE'.

    CASE <flt_cache_line>-imp_switch.
      WHEN 'VSR'.
        DATA: exc        TYPE sfbm_xcptn,                  "#EC NEEDED
              data_ref   TYPE REF TO DATA.

        IF <flt_cache_line>-eo_object is initial.
          CALL METHOD ('CL_FOBU_METHOD_EVALUATION')=>load
               EXPORTING
                  im_class_name     = <flt_cache_line>-imp_class
                  im_interface_name = 'IF_EX_BC427_16_EXT_FL_DISP'
                  im_method_name    = 'WRITE_ADDITIONAL_COLS'
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
        GET REFERENCE OF I_WA_SFLIGHT INTO data_ref.
        CALL METHOD <flt_cache_line>-eo_object->set_parameter(
            im_parmname = 'I_WA_SFLIGHT'
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
        CALL METHOD EXITINTF->WRITE_ADDITIONAL_COLS
           EXPORTING
             I_WA_SFLIGHT = I_WA_SFLIGHT.


    ENDCASE.

    CALL FUNCTION 'PF_ASTAT_CLOSE'
       EXPORTING
           OPENKEY = 'Hg}qwPkYH2VX00002a92EG'
           TYP     = 'UE'.
  ENDLOOP.


endmethod.
ENDCLASS.
