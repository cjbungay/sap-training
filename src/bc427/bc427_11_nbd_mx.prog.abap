REPORT  bc427_11_nbd_mx.

PARAMETERS customid TYPE scustom-id.

TABLES scustom.

DATA ok_code TYPE sy-ucomm.
DATA r_exit  TYPE REF TO bc427_11_mx_badi.


START-OF-SELECTION.

  SELECT SINGLE * FROM scustom
    INTO scustom
    WHERE  id = customid.

  IF sy-subrc NE 0.
    WRITE text-cnf. EXIT.
  ENDIF.

  TRY.
    GET BADI r_exit.
   CATCH cx_badi_not_implemented.

  ENDTRY.

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

    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN '+EXT'.
      IF r_exit IS NOT INITIAL.
        CALL BADI r_exit->show_additional_customer_data
          EXPORTING  im_customid = customid.
      ENDIF.

  ENDCASE.

ENDMODULE.                 " USER_COMMAND_0100  INPUT
