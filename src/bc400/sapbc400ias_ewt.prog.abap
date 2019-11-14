*&---------------------------------------------------------------------*
*& Report  SAPBC400IAS_EWT                                             *
*&---------------------------------------------------------------------*

REPORT  sapbc400ias_ewt .

DATA  gdt_spfli TYPE sbc400_t_spfli.

DATA  ok_code LIKE sy-ucomm.

DATA: container_r TYPE REF TO cl_gui_custom_container,
      grid_r      TYPE REF TO cl_gui_alv_grid.


START-OF-SELECTION.

*   fill internal table
    SELECT * FROM spfli
             INTO TABLE gdt_spfli.
*            WHERE ...

  CALL SCREEN 100.



*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      SET SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_100'.
* SET TITLEBAR 'xxx'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  CREATE_CONTROL  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE create_control OUTPUT.

  IF container_r IS INITIAL.
    CREATE OBJECT container_r
           EXPORTING container_name = 'CONTAINER_1'.

    CREATE OBJECT grid_r
            EXPORTING  i_parent =  container_r.

    CALL METHOD grid_r->set_table_for_first_display
      EXPORTING
        i_structure_name = 'SPFLI'
      CHANGING
        it_outtab        = gdt_spfli.
  ELSE.
    CALL METHOD grid_r->refresh_table_display
      EXPORTING
        i_soft_refresh = 'X'.
  ENDIF.

ENDMODULE.                             " CREATE_CONTROL  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT
