REPORT  bc427_02_nbd_sx.

PARAMETERS p_carr TYPE scarr-carrid.

TABLES scarr.

DATA:
  ok_code          TYPE sy-ucomm,
  r_exit           TYPE REF TO bc427_02_sx_badi,
  badi_name        TYPE badi_name,
  current_screen   TYPE scradnum,
  current_prog     TYPE program,
  subscr_area      TYPE subscreen,
  it_filter_values TYPE badi_filter_bindings,
  subscr_number    TYPE scradnum,
  subscr_prog      TYPE program.


START-OF-SELECTION.

  SELECT SINGLE * FROM scarr
    INTO scarr  WHERE  carrid = p_carr.

  IF sy-subrc NE 0.
    WRITE text-cnf. EXIT.
  ENDIF.

  CALL SCREEN 100.



*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET TITLEBAR  'T_100'.
  SET PF-STATUS 'S_100'.
ENDMODULE.                 " STATUS_0100  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'. LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT


*&---------------------------------------------------------------------*
*&      Module  PREPARE_SUBSCR_INCLUSION  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE prepare_subscr_inclusion OUTPUT.

  IF r_exit IS INITIAL.

    TRY.

      GET BADI r_exit.

      CALL BADI r_exit->put_data
        EXPORTING
          im_wa_scarr = scarr.

     CATCH cx_badi_not_implemented.

     CATCH cx_badi_initial_reference.

    ENDTRY.

  ENDIF.

* For type conversion only
  badi_name      = 'BC427_02_SX_BADI'.
  current_screen =  sy-dynnr.
  current_prog   =  sy-cprog.
  subscr_area    = 'SUB'.

  CALL METHOD cl_enh_badi_runtime_functions=>get_prog_and_dynp_for_subscr
    EXPORTING
      badi_name       = badi_name
      calling_dynpro  = current_screen
      calling_program = current_prog
      subscreen_area  = subscr_area
      filter_values   = it_filter_values
    IMPORTING
      called_dynpro   = subscr_number  " returns dummy subscreen, if no
      called_program  = subscr_prog.   " BAdI implementation is activated

ENDMODULE.                 " PREPARE_SUBSCR_INCLUSION  OUTPUT
