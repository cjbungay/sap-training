*&---------------------------------------------------------------------*
*& Report         SAPBC405_CALT_1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*


INCLUDE bc405_calt_1_alv620top.
*INCLUDE bc405_calt_1top                         .    " global Data

************************************************************************
*Local class for ALV event handling
************************************************************************
CLASS: lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_toolbar
                     FOR EVENT toolbar OF cl_gui_alv_grid
                     IMPORTING e_object,
                   on_user_command
                     FOR EVENT user_command OF cl_gui_alv_grid
                     IMPORTING e_ucomm.
ENDCLASS.                    "lcl_handler DEFINITION


*---------------------------------------------------------------------*
CLASS: lcl_handler IMPLEMENTATION.
************************************************************************
*       Expands toolbar                                                *
************************************************************************
  METHOD on_toolbar.
    DATA l_wa_button TYPE stb_button.

* Separator
    l_wa_button-butn_type = 3.
    INSERT l_wa_button INTO TABLE e_object->mt_toolbar.

* Create button "Modify bookings"
    CLEAR l_wa_button.
    l_wa_button-function = 'MAINTAIN'.
    l_wa_button-icon = icon_change.
    l_wa_button-quickinfo = 'Maintain connection'(z01).     "#EC *
    l_wa_button-butn_type = 0.
    INSERT l_wa_button INTO TABLE e_object->mt_toolbar.

* Create button "Display bookings"
    CLEAR l_wa_button.
    l_wa_button-function = 'MULTI_ROWS'.
    l_wa_button-icon = icon_flight.
    l_wa_button-quickinfo =
    'Flights of several connections'(z02).                  "#EC *
    l_wa_button-butn_type = 0.
    INSERT l_wa_button INTO TABLE e_object->mt_toolbar.

  ENDMETHOD.                    "on_toolbar

************************************************************************
*         Handles self-defined user-commands                           *
************************************************************************
  METHOD on_user_command.
    CASE e_ucomm.
* replace messages with program calls !
      WHEN 'MAINTAIN'.
        MESSAGE 'test1' TYPE 'I'.
      WHEN 'MULTI_ROWS'.
        MESSAGE 'test2' TYPE 'I'.
    ENDCASE.
  ENDMETHOD.                    "on_user_command
ENDCLASS.                    "lcl_handler IMPLEMENTATION


START-OF-SELECTION.
* retrieve data
  SELECT *
    FROM spfli
    INTO TABLE it_spfli
    WHERE carrid IN so_car
      AND connid IN so_con.

  CHECK sy-subrc EQ 0.

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
MODULE create_and_transfer OUTPUT.
  CHECK cont IS INITIAL.
  CREATE OBJECT cont
    EXPORTING
      container_name              = 'MY_CONTROL_AREA'
    EXCEPTIONS
      OTHERS                      = 1.

  IF sy-subrc <> 0.
    MESSAGE a010(bc405_408).
  ENDIF.

  CREATE OBJECT alv
    EXPORTING
      i_parent          = cont
    EXCEPTIONS
      OTHERS            = 1.

  IF sy-subrc <> 0.
    MESSAGE a010(bc405_408).
  ENDIF.

  SET HANDLER:
    lcl_handler=>on_toolbar FOR alv,
    lcl_handler=>on_user_command FOR alv.

  wa_layout-sel_mode = 'A'.

  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SPFLI'
      is_layout        = wa_layout
    CHANGING
      it_outtab        = it_spfli
    EXCEPTIONS
      OTHERS           = 1.

  IF sy-subrc <> 0.
    MESSAGE a012(bc405_408).
  ENDIF.

ENDMODULE.                 " create_and_transfer  OUTPUT

************************************************************************
*PAI modules
************************************************************************
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      PERFORM free.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT


************************************************************************
*Form routines
************************************************************************
FORM free.
  CALL METHOD: alv->free,
               cont->free.
  FREE: alv,
        cont.
ENDFORM.                    " free
