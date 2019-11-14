*&---------------------------------------------------------------------*
*& Report  SAPBC412_GRDS_EXERCISE_1                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& Model solution for the first exercise of unit 'SAP Grid Control'    *
*& of classroom training BC412.                                        *
*& The program displays SPFLI data using an SAP Grid Control.          *
*&---------------------------------------------------------------------*

REPORT  sapbc412_grds_exercise_1 MESSAGE-ID bc412.

DATA:
    ok_code       TYPE sy-ucomm,
    copy_ok_code  LIKE ok_code,

    ref_container TYPE REF TO cl_gui_docking_container,
    ref_alv       TYPE REF TO cl_gui_alv_grid,

    it_spfli      TYPE TABLE OF spfli,
    it_sflight    TYPE TABLE OF sflight,

    wa_spfli      LIKE LINE OF it_spfli,
    wa_sflight    LIKE LINE OF it_sflight.

SELECT-OPTIONS:
  so_carr FOR wa_spfli-carrid.




START-OF-SELECTION.

  SELECT * FROM  spfli INTO TABLE it_spfli WHERE carrid IN so_carr
           ORDER BY CARRID connid.
  IF sy-subrc NE 0.
    MESSAGE a061(bc412).
  ENDIF.

*  SELECT * FROM sflight INTO TABLE it_sflight WHERE carrid IN so_carr
*           ORDER BY carrid connid fldate.
*  IF sy-subrc NE 0.
*    MESSAGE a062(bc412).
*  ENDIF.


  CALL SCREEN 100.

*&-----------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&-----------------------------------------------------------------*
*       GUI settings
*------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'SCREEN_0100'.
  SET TITLEBAR 'SCREEN_0100'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&-----------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&-----------------------------------------------------------------*
*       implementation of GUI functions
*------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  copy_ok_code = ok_code.
  CLEAR ok_code.

  CASE copy_ok_code.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&-----------------------------------------------------------------*
*&      Module  INIT_CONTROL_PROCESSING  OUTPUT
*&-----------------------------------------------------------------*
*       control related processing
*------------------------------------------------------------------*
MODULE init_control_processing OUTPUT.
  IF ref_container IS INITIAL.
*   create container object

    CREATE OBJECT ref_container
       EXPORTING
*        SIDE                        = DOCK_AT_LEFT
         extension                   = 2000
       EXCEPTIONS
         others                      = 1.

    IF sy-subrc <> 0.
      MESSAGE a010(bc412).
    ENDIF.

*   create alv grid object and link to container

    CREATE OBJECT ref_alv
      EXPORTING
        i_parent          = ref_container
*        I_APPL_EVENTS     = space
       EXCEPTIONS
         others            = 1.

    IF sy-subrc <> 0.
      MESSAGE a045(bc412).
    ENDIF.

*   send basic list to alv grid control

    CALL METHOD ref_alv->set_table_for_first_display
       EXPORTING
*        I_BUFFER_ACTIVE               =
         i_structure_name              = 'SPFLI'
*        IS_VARIANT                    =
*        I_SAVE                        =
*        I_DEFAULT                     = 'X'
*        IS_LAYOUT                     =
*        IS_PRINT                      =
*        IT_SPECIAL_GROUPS             =
*        IT_TOOLBAR_EXCLUDING          =
*        IT_HYPERLINK                  =
*        IT_ALV_GRAPHICS               =
      CHANGING
        it_outtab                     = it_spfli
*        IT_FIELDCATALOG               =
*        IT_SORT                       =
*        IT_FILTER                     =
       EXCEPTIONS
         OTHERS                        = 4
            .

    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT
