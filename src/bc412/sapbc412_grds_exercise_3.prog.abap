*&---------------------------------------------------------------------*
*& Report  SAPBC412_GRDS_EXERCISE_3                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& Model solution for the third exercise of unit 'SAP Grid Control'    *
*& of classroom training BC412.                                        *
*& The program displays SPFLI and corresponding SFLIGHT data as an     *
*& interacive list.                                                    *
*&                                                                     *
*& The SFLIGHT list is displayed in an SAP Grid Control on a           *
*& dialogbox container. The secondary list (SFLIGHT) is created,       *
*& if the user double-clicks a line in the basic list.                 *
*&---------------------------------------------------------------------*

REPORT  sapbc412_grds_exercise_3 MESSAGE-ID bc412.

DATA:
    ok_code       TYPE sy-ucomm,
    copy_ok_code  LIKE ok_code,

    ref_container TYPE REF TO cl_gui_docking_container,
    ref_alv       TYPE REF TO cl_gui_alv_grid,

    ref_box       TYPE REF TO cl_gui_dialogbox_container,
    ref_box_alv   TYPE REF TO cl_gui_alv_grid,

    it_spfli      TYPE TABLE OF spfli,
    it_sflight    TYPE TABLE OF sflight,

    it_popup      TYPE TABLE OF sflight,

    wa_spfli      LIKE LINE OF it_spfli,
    wa_sflight    LIKE LINE OF it_sflight.

SELECT-OPTIONS:
  so_carr FOR wa_spfli-carrid.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_double_click FOR EVENT double_click OF cl_gui_alv_grid
                      IMPORTING e_row.

ENDCLASS.

*-----------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*-----------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_double_click.
*   find out selected line (double click)
    READ TABLE it_spfli INTO wa_spfli INDEX e_row-index.
    IF sy-subrc NE 0.
      MESSAGE i075(bc412).  " <-- internal error
      EXIT.
    ENDIF.

*   copy corresponding flight data to it_popup
    CLEAR it_popup.

    LOOP AT it_sflight INTO wa_sflight
         WHERE carrid = wa_spfli-carrid
         AND   connid = wa_spfli-connid.
      APPEND wa_sflight TO it_popup.
    ENDLOOP.

    IF ref_box IS INITIAL.

*   create dialog box container
      CREATE OBJECT ref_box
         EXPORTING
           width                       = 800
           height                      = 200
           top                         = 120
           left                        = 120
           caption                     = text-002
         EXCEPTIONS
           others                      = 1.

      IF sy-subrc <> 0.
        MESSAGE a010(bc412).
      ENDIF.

    ENDIF.

    IF ref_box_alv IS INITIAL.

*   create avl grid object and link to dialogbox container
      CREATE OBJECT ref_box_alv
        EXPORTING
          i_parent          = ref_box
         EXCEPTIONS
           others            = 1.

      IF sy-subrc <> 0.
        MESSAGE a045(bc412).
      ENDIF.

*   send popup data to new alv object
      CALL METHOD ref_box_alv->set_table_for_first_display
         EXPORTING
           i_structure_name              = 'SFLIGHT'
         CHANGING
           it_outtab                     = it_popup
*        IT_FIELDCATALOG               =
*        IT_SORT                       =
*        IT_FILTER                     =
         EXCEPTIONS
           OTHERS                        = 1.

      IF sy-subrc <> 0.
        MESSAGE a012(bc412).
      ENDIF.

    ELSE.                              " do only refresh alv contents

      CALL METHOD ref_box_alv->refresh_table_display.

    ENDIF.
  ENDMETHOD.
ENDCLASS.





START-OF-SELECTION.

  SELECT * FROM  spfli INTO TABLE it_spfli WHERE carrid IN so_carr
           ORDER BY CARRID connid.
  IF sy-subrc NE 0.
    MESSAGE a061.
  ENDIF.

  SELECT * FROM sflight INTO TABLE it_sflight WHERE carrid IN so_carr
           ORDER BY CARRID connid FLDATE.
  IF sy-subrc NE 0.
    MESSAGE a062.
  ENDIF.


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

    CREATE OBJECT ref_container
       EXPORTING
*        SIDE                        = DOCK_AT_LEFT
         extension                   = 2000
       EXCEPTIONS
         others                      = 1.

    IF sy-subrc <> 0.
      MESSAGE a010(bc412).
    ENDIF.

    CREATE OBJECT ref_alv
      EXPORTING
        i_parent          = ref_container
*        I_APPL_EVENTS     = space
       EXCEPTIONS
         others            = 1.

    IF sy-subrc <> 0.
      MESSAGE a045.
    ENDIF.

    CALL METHOD ref_alv->set_table_for_first_display
       EXPORTING
         i_structure_name              = 'SPFLI'
*        IS_VARIANT                    =
*        I_SAVE                        =
*        I_DEFAULT                     = 'X'
*        IS_LAYOUT                     =
*        IS_PRINT                      =
*        IT_SPECIAL_GROUPS             =
*        IT_TOOLBAR_EXCLUDING          =
       CHANGING
         it_outtab                     = it_spfli
*        IT_FIELDCATALOG               =
*        IT_SORT                       =
*        IT_FILTER                     =
       EXCEPTIONS
         OTHERS                        = 1.

    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

*   event handling --> only ABAP Objects part,
*         CFW registration is performed by ALV proxy object
    SET HANDLER lcl_event_handler=>on_double_click FOR ref_alv.


  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT
