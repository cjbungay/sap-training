*&---------------------------------------------------------------------*
*& Report  SAPBC412_INTS_SAP_GRID                                      *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& This program displays flight connection data (table SPFLI)          *
*& using an instance of the SAP Grid Control.                          *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc412_ints_sap_grid MESSAGE-ID bc412.

DATA:
  ok_code LIKE sy-ucomm,

  it_spfli TYPE STANDARD TABLE OF spfli,

* control specific:
  ref_container TYPE REF TO cl_gui_custom_container,
  ref_alv       TYPE REF TO cl_gui_alv_grid.



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

*&---------------------------------------------------------------------*
*&      Module  init_control_processing_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_control_processing_0100 OUTPUT.
  IF ref_container IS INITIAL.

    CREATE OBJECT ref_container
      EXPORTING
        container_name              = 'CCA1'
      EXCEPTIONS
        others                      = 1.
    IF sy-subrc <> 0.
      MESSAGE a011.
    ENDIF.

    CREATE OBJECT ref_alv
      EXPORTING
        i_parent          = ref_container
      EXCEPTIONS
        others            = 1.
    IF sy-subrc <> 0.
      MESSAGE a045.
    ENDIF.

    CALL METHOD ref_alv->set_table_for_first_display
      EXPORTING
        i_structure_name              = 'SPFLI'
      CHANGING
        it_outtab                     = it_spfli
      EXCEPTIONS
        OTHERS                        = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

  ENDIF.
ENDMODULE.                 " init_control_processing_0100  OUTPUT
