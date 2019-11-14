*&---------------------------------------------------------------------*
*& Report SAPBC408CTRD_EASY_DRAG_N_DROP
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408ctrd_easy_drag_n_drop.

* work areas plus internal tables for ALV data
DATA:
  wa_all_bookings TYPE sbook,
  it_all_bookings LIKE TABLE OF wa_all_bookings,

  it_some_bookings TYPE TABLE OF sbook.

* data needed for layout
DATA:
  wa_layout1  TYPE lvc_s_layo,
  wa_layout2  TYPE lvc_s_layo.

DATA:
  ok_code    LIKE sy-ucomm.

DATA:
  cont                TYPE REF TO cl_gui_custom_container,
  easy_splitter_cont  TYPE REF TO cl_gui_easy_splitter_container,
  alv_all_bookings    TYPE REF TO cl_gui_alv_grid,
  alv_some_bookings   TYPE REF TO cl_gui_alv_grid.

* data needed for drag&drop
DATA:
  flav_src   TYPE REF TO cl_dragdrop,
  flav_tar   TYPE REF TO cl_dragdrop,
  handle_src TYPE i,
  handle_tar TYPE i.


SELECT-OPTIONS: so_car FOR wa_all_bookings-carrid MEMORY ID car,
                so_con FOR wa_all_bookings-connid MEMORY ID con,
                so_dat FOR wa_all_bookings-fldate MEMORY ID dat.

************************************************************************
* local class definitions for control event handling
************************************************************************
CLASS lcl_booking DEFINITION.
  PUBLIC SECTION.
    DATA wa_booking TYPE sbook.
ENDCLASS.                    "lcl_booking DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      handle_ondrag
        FOR EVENT ondrag OF cl_gui_alv_grid
        IMPORTING e_row
                  e_dragdropobj,

      handle_ondrop
        FOR EVENT ondrop OF cl_gui_alv_grid
        IMPORTING e_row
                  e_dragdropobj.

ENDCLASS.                    "lcl_event_handler DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD handle_ondrag.
    DATA:
      l_ref_booking TYPE REF TO lcl_booking.

    CREATE OBJECT l_ref_booking.
    READ TABLE it_all_bookings INDEX e_row-index
      INTO l_ref_booking->wa_booking.

    e_dragdropobj->object = l_ref_booking.
  ENDMETHOD.                    "handle_ondrag

  METHOD handle_ondrop.
    DATA:
      l_ref_booking TYPE REF TO lcl_booking,
      grid_title(70).

    l_ref_booking ?= e_dragdropobj->object.

* read all bookings for the dragged customer
    SELECT *
      FROM sbook
      INTO TABLE it_some_bookings
      WHERE customid = l_ref_booking->wa_booking-customid.
    CALL METHOD alv_some_bookings->refresh_table_display.

    grid_title = 'Flights of customer'(h02).                "#EC *
    CONCATENATE grid_title l_ref_booking->wa_booking-customid
      INTO grid_title SEPARATED BY space.
    CALL METHOD alv_some_bookings->set_gridtitle
      EXPORTING
        i_gridtitle = grid_title.

  ENDMETHOD.                    "handle_ondrop

ENDCLASS.                    "lcl_event_handler IMPLEMENTATION


************************************************************************
* ABAP Events
************************************************************************

START-OF-SELECTION.
* define flavors for drag&drop
  CREATE OBJECT: flav_src, flav_tar.

  CALL METHOD flav_src->add
    EXPORTING
      flavor         = 'DEMO'
      dragsrc        = 'X'
      droptarget     = space
      effect_in_ctrl = cl_dragdrop=>none
    EXCEPTIONS
      OTHERS         = 1.
  CALL METHOD flav_tar->add
    EXPORTING
      flavor         = 'DEMO'
      dragsrc        = space
      droptarget     = 'X'
      effect_in_ctrl = cl_dragdrop=>none
    EXCEPTIONS
      OTHERS         = 1.

* get handles for drag&drop flavors
  CALL METHOD flav_src->get_handle
    IMPORTING
      handle = handle_src
    EXCEPTIONS
      OTHERS = 1.

  CALL METHOD flav_tar->get_handle
    IMPORTING
      handle = handle_tar
    EXCEPTIONS
      OTHERS = 1.

* fill the first internal table with the bookings fitting to the
* selection screen.
  SELECT * FROM sbook
    INTO TABLE it_all_bookings
    WHERE carrid IN so_car
    AND   connid IN so_con
    AND   fldate IN so_dat.


* fill the second internal table with all bookings of the first customer
  READ TABLE it_all_bookings
    INTO wa_all_bookings
    INDEX 1.
  SELECT *
    FROM sbook
    INTO TABLE it_some_bookings
    WHERE customid = wa_all_bookings-customid.

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

* create custom control container.
* This container will be used for the easy splitter container
  CREATE OBJECT cont
    EXPORTING
      container_name              = 'CONTROL_AREA'
    EXCEPTIONS
      OTHERS                      = 1.

  IF sy-subrc <> 0.
    MESSAGE a010(bc405_408).
  ENDIF.

  CREATE OBJECT easy_splitter_cont
    EXPORTING
      parent            = cont
    orientation       =
cl_gui_easy_splitter_container=>orientation_horizontal
*    SASH_POSITION     = 50
*    WITH_BORDER       = 1
*    NAME              =
  EXCEPTIONS
    OTHERS            = 1.

  IF sy-subrc <> 0.
    MESSAGE a010(bc405_408).
  ENDIF.

* set up first ALV for all bookings of selection screen
* display it in the left half of the easy splitter container
  CREATE OBJECT alv_all_bookings
    EXPORTING
      i_parent          = easy_splitter_cont->top_left_container
    EXCEPTIONS
      OTHERS            = 1.

  IF sy-subrc <> 0.
    MESSAGE a010(bc405_408).
  ENDIF.
  SET HANDLER lcl_event_handler=>handle_ondrag FOR alv_all_bookings.

  wa_layout1-grid_title = 'Bookings'(h01).                  "#EC *
  wa_layout1-s_dragdrop-row_ddid = handle_src.
  "col_ddid would work as well

  CALL METHOD alv_all_bookings->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SBOOK'
      is_layout        = wa_layout1
    CHANGING
      it_outtab        = it_all_bookings
    EXCEPTIONS
      OTHERS           = 1.
  IF sy-subrc <> 0.
    MESSAGE a012(bc405_408).
  ENDIF.

* set up second ALV for bookings of first customer
* display it in the right half of the easy splitter container
  CREATE OBJECT alv_some_bookings
    EXPORTING
      i_parent          = easy_splitter_cont->bottom_right_container
    EXCEPTIONS
      OTHERS            = 1.
  IF sy-subrc <> 0.
    MESSAGE a012(bc405_408).
  ENDIF.

  SET HANDLER lcl_event_handler=>handle_ondrop FOR alv_some_bookings.

  READ TABLE it_all_bookings
    INTO wa_all_bookings
    INDEX 1.
  wa_layout2-grid_title = 'Flights of customer'(h02). "EC *
  CONCATENATE wa_layout2-grid_title wa_all_bookings-customid
    INTO wa_layout2-grid_title SEPARATED BY space.
  wa_layout2-s_dragdrop-row_ddid = handle_tar.

  CALL METHOD alv_some_bookings->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SBOOK'
      is_layout        = wa_layout2
    CHANGING
      it_outtab        = it_some_bookings
    EXCEPTIONS
      OTHERS           = 1.


ENDMODULE.                 " create_and_transfer  OUTPUT

************************************************************************
*PAI Modules
************************************************************************
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
