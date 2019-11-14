*&---------------------------------------------------------------------*
*& Report  SAPBC408VARD
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408vard.

* work area plus internal table for ALV data
DATA:
  wa_sbook TYPE sbook,
  it_sbook LIKE TABLE OF wa_sbook.

DATA:
  ok_code    LIKE sy-ucomm.

DATA: cont   TYPE REF TO cl_gui_custom_container,
      alv    TYPE REF TO cl_gui_alv_grid.

DATA: variant TYPE disvariant.

SELECT-OPTIONS: so_car FOR wa_sbook-carrid MEMORY ID car,
                so_con FOR wa_sbook-connid MEMORY ID con,
                so_dat FOR wa_sbook-fldate MEMORY ID dat.
PARAMETERS: pa_lv TYPE disvariant-variant.


******************************************************************
* at least the report name has to be passed on to the layout field.
INITIALIZATION.
  variant-report = sy-cprog.

******************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.
  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'
    CHANGING
      cs_variant  = variant
    EXCEPTIONS
      OTHERS      = 1.

  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    pa_lv = variant-variant.
  ENDIF.

*****************************************************************
START-OF-SELECTION.
  SELECT * FROM sbook
    INTO CORRESPONDING FIELDS OF TABLE it_sbook
    WHERE carrid IN so_car
    AND   connid IN so_con
    AND   fldate IN so_dat.

  CALL SCREEN 100.

************************************************************************
*PBO modules
************************************************************************
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT

*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.
ENDMODULE.                 " STATUS_0100  OUTPUT

*----------------------------------------------------------------------*
MODULE create_objects OUTPUT.
  CHECK cont IS INITIAL.
  CREATE OBJECT cont
    EXPORTING
      container_name              = 'MY_CONTROL_AREA'
    EXCEPTIONS
      OTHERS                      = 1.

  IF sy-subrc <> 0 AND sy-batch IS INITIAL.
    MESSAGE a010(bc408).
  ENDIF.

  CREATE OBJECT alv
    EXPORTING
      i_parent          = cont
    EXCEPTIONS
      OTHERS            = 1.

  IF sy-subrc <> 0 AND sy-batch IS INITIAL.
    MESSAGE a010(bc408).
  ENDIF.



  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SBOOK'
      is_variant       = variant
      i_save           = 'A'
    CHANGING
      it_outtab        = it_sbook
    EXCEPTIONS
      OTHERS           = 1.
  IF sy-subrc <> 0.
    MESSAGE a012(bc408).
  ENDIF.

ENDMODULE.                 " create_objects  OUTPUT

************************************************************************
*PAI Modules
************************************************************************
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      CALL METHOD: alv->free, cont->free.
      FREE: alv, cont.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
