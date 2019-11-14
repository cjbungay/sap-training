*&---------------------------------------------------------------------*
*& Report  SAPBC412_INTT_SAP_GRID                                      *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& Copy this program and demonstrate how easy and quick a sophisitcated*
*& report can be generated with EnjoySAP Controls!                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc412_intt_sap_grid MESSAGE-ID bc412.

DATA:
  ok_code LIKE sy-ucomm,

  it_spfli TYPE STANDARD TABLE OF spfli.

* control specific:
...



START-OF-SELECTION.
* retrieve application data:
  SELECT * FROM spfli INTO TABLE it_spfli.



  CALL SCREEN 100.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       process push buttons
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*      ...
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_100'.
  SET TITLEBAR 'TITLE_100'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT
