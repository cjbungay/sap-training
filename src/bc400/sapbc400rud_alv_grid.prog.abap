*&---------------------------------------------------------------------*
*& Report  SAPBC400RUD_ALV_GRID                                        *
*&---------------------------------------------------------------------*

REPORT  sapbc400rud_alv_grid .

TABLES sbc400_carrier.

TYPES  itab_type TYPE STANDARD TABLE OF spfli
                 WITH KEY mandt carrid connid.

DATA  itab TYPE itab_type.
.
DATA: container_ref TYPE REF TO cl_gui_custom_container,

      grid TYPE REF TO cl_gui_alv_grid.

DATA  ok_code TYPE sy-ucomm.



START-OF-SELECTION.

* SELECT * FROM spfli INTO TABLE itab.

  CALL SCREEN 100.



*&---------------------------------------------------------------------*
*&      Module  CREATE_CONTROL  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE create_control OUTPUT.
  IF container_ref IS INITIAL.
    CREATE OBJECT container_ref
           EXPORTING container_name = 'CONTAINER_1'.
    CREATE OBJECT grid
           EXPORTING i_parent = container_ref.

    CALL METHOD grid->set_table_for_first_display
      EXPORTING
        i_structure_name = 'SPFLI'
      CHANGING
        it_outtab        = itab.
  ELSE.
    SELECT * FROM spfli INTO TABLE itab
             WHERE carrid = sbc400_carrier-carrid.
    CALL METHOD grid->refresh_table_display
      EXPORTING
        i_soft_refresh = 'X'.
  ENDIF.
ENDMODULE.                             " CREATE_CONTROL  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE PROGRAM.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  CLEAR_OK_CODE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " CLEAR_OK_CODE  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_100'.
* SET TITLEBAR 'xxx'.
ENDMODULE.                 " STATUS_0100  OUTPUT
