*&---------------------------------------------------------------------*
*& Report  SAPBC412_GRDS_EXERCISE_4                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& Model solution for the fourth exercise of unit 'SAP Grid Control'   *
*& of classroom training BC412.                                        *
*& The program displays SPFLI data using an SAP Grid Control.          *
*&                                                                     *
*& The toolbar functions can be excluded except the button for         *
*& including them again. ;-)                                           *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc412_grds_exercise_4 MESSAGE-ID bc412.

TYPE-POOLS icon.

DATA:
    ok_code       TYPE sy-ucomm,
    copy_ok_code  LIKE ok_code,
    alv_ok_code   LIKE ok_code VALUE 'INCLUDE',

    ref_container TYPE REF TO cl_gui_docking_container,
    ref_alv       TYPE REF TO cl_gui_alv_grid,

    it_spfli      TYPE TABLE OF spfli,
    it_sflight    TYPE TABLE OF sflight,

    wa_spfli      LIKE LINE OF it_spfli,
    wa_sflight    LIKE LINE OF it_sflight.

SELECT-OPTIONS:
  so_carr FOR wa_spfli-carrid.



*-----------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*-----------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_toolbar      FOR EVENT toolbar OF cl_gui_alv_grid
                      IMPORTING e_object,
*     -------------------------------------------------------------
      on_user_command FOR EVENT user_command OF cl_gui_alv_grid
                      IMPORTING e_ucomm.
ENDCLASS.


*-----------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*-----------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_toolbar.
    DATA l_wa_button TYPE stb_button.

    CASE alv_ok_code.
      WHEN 'INCLUDE'.
        l_wa_button-function  = 'EXCLUDE'.
        l_wa_button-icon      = icon_pdir_foreward_switch.
        l_wa_button-quickinfo = text-ecl.
      WHEN 'EXCLUDE'.
        CLEAR e_object->mt_toolbar.
        l_wa_button-function  = 'INCLUDE'.
        l_wa_button-icon      = icon_pdir_back_switch.
        l_wa_button-quickinfo = text-icl.
    ENDCASE.

    l_wa_button-butn_type = 0.
    INSERT l_wa_button INTO TABLE e_object->mt_toolbar.

  ENDMETHOD.

* -------------------------------------------------------------------
  METHOD on_user_command.
    CASE e_ucomm.
      WHEN 'EXCLUDE' OR 'INCLUDE'.
        alv_ok_code = e_ucomm.
        CALL METHOD ref_alv->set_toolbar_interactive.
    ENDCASE.
  ENDMETHOD.


ENDCLASS.




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

    SET HANDLER:
      lcl_event_handler=>on_toolbar      FOR ref_alv,
      lcl_event_handler=>on_user_command FOR ref_alv.

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
