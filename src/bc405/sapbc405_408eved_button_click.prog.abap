*&---------------------------------------------------------------------*
*& Report  SAPBC408EVED_BUTTON_CLICK
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408eved_button_click    .


* work area for ALV data
DATA:
  BEGIN OF wa_sflight.
        INCLUDE STRUCTURE sflight.
DATA:    display_bookings(10), " field that can be display as pushbutton
    ct TYPE lvc_t_styl, " internal table for buttons
  END OF wa_sflight,

  it_sflight LIKE TABLE OF wa_sflight.

DATA:
  ok_code TYPE sy-ucomm.

DATA:
  wa_sbook TYPE sbook,
  it_sbook TYPE TABLE OF sbook.

DATA:
  alv TYPE REF TO cl_gui_alv_grid,
  cont TYPE REF TO cl_gui_custom_container.

* data needed for layout
DATA:
  wa_layout TYPE lvc_s_layo.

DATA: wa_ct TYPE lvc_s_styl.

* field catalog
DATA:
  it_field_cat TYPE lvc_t_fcat,
  wa_field_cat LIKE LINE OF it_field_cat.

DATA: dialogbox TYPE REF TO cl_gui_dialogbox_container,
      alv_book TYPE REF TO cl_gui_alv_grid.



SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_con FOR wa_sflight-connid.


*---------------------------------------------------------------------*
CLASS: lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_button_click
                     FOR EVENT button_click OF cl_gui_alv_grid
                     IMPORTING es_row_no,
                   on_close
                     FOR EVENT close OF cl_gui_dialogbox_container
                     IMPORTING sender.
ENDCLASS.                    "lcl_handler DEFINITION


*---------------------------------------------------------------------*
CLASS: lcl_handler IMPLEMENTATION.
  METHOD on_button_click.
    READ TABLE it_sflight INTO wa_sflight INDEX es_row_no-row_id.

    IF sy-subrc NE 0.
      MESSAGE i075(bc405_408).
      EXIT.
    ENDIF.

    SELECT * FROM sbook INTO TABLE it_sbook
      WHERE carrid = wa_sflight-carrid
        AND connid = wa_sflight-connid
        AND fldate = wa_sflight-fldate.


    IF dialogbox IS INITIAL.
      CREATE OBJECT dialogbox
        EXPORTING
          width                       = 800
          height                      = 200
          top                         = 120
          left                        = 120
          caption                     = 'Bookings'(boo)
        EXCEPTIONS
          OTHERS                      = 0
          .

      IF sy-subrc <> 0.
        MESSAGE a010(bc405_408).
      ENDIF.

      SET HANDLER lcl_handler=>on_close FOR dialogbox.

      CREATE OBJECT alv_book
        EXPORTING
          i_parent          = dialogbox
        EXCEPTIONS
          OTHERS            = 1
          .
      IF sy-subrc <> 0.
        MESSAGE a010(bc405_408).
      ENDIF.



      CALL METHOD alv_book->set_table_for_first_display
        EXPORTING
          i_structure_name = 'SBOOK'
        CHANGING
          it_outtab        = it_sbook
        EXCEPTIONS
          OTHERS           = 1.

      IF sy-subrc <> 0.
        MESSAGE a012(bc405_408).
      ENDIF.

    ELSE.  " IF dialogbox IS INITIAL
      CALL METHOD alv_book->refresh_table_display
        EXCEPTIONS
          OTHERS = 1.

      IF sy-subrc <> 0.
        MESSAGE a010(bc405_408).
      ENDIF.
    ENDIF.
  ENDMETHOD.                    "on_button_click


  METHOD on_close.
    CALL METHOD sender->free.
    FREE: alv_book,
          dialogbox.
  ENDMETHOD.                    "on_close
ENDCLASS.                    "lcl_handler IMPLEMENTATION


*&---------------------------------------------------------------------*
START-OF-SELECTION.
  CALL SCREEN 100.

*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.

ENDMODULE.                 " STATUS_0100  OUTPUT


*---------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT

*----------------------------------------------------------------------*
MODULE get_data OUTPUT.
  SELECT * FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE it_sflight
    WHERE carrid IN so_car
    AND   connid IN so_con.

* show button for flights in the future
* Druckknopf setzen für Flüge in der Zukunft
  wa_ct-fieldname = 'DISPLAY_BOOKINGS'.
  wa_ct-style = cl_gui_alv_grid=>mc_style_button.
  APPEND wa_ct TO wa_sflight-ct.
  wa_sflight-display_bookings = 'Bookings'(t11).

  MODIFY it_sflight
    FROM wa_sflight
    TRANSPORTING ct display_bookings
    WHERE fldate > sy-datum.

ENDMODULE.                 " get_data  OUTPUT

*----------------------------------------------------------------------*
MODULE create_objects OUTPUT.
  CHECK cont IS INITIAL.
  CREATE OBJECT cont
    EXPORTING
      container_name              = 'MY_CONTROL_AREA'
    EXCEPTIONS
      OTHERS                      = 1
      .
  IF sy-subrc <> 0.
    MESSAGE a010(bc405_408).
  ENDIF.

  CREATE OBJECT alv
    EXPORTING
      i_parent          = cont
    EXCEPTIONS
      OTHERS            = 1
      .
  IF sy-subrc <> 0.
    MESSAGE a010(bc405_408).
  ENDIF.


* define layout
  wa_layout-grid_title = 'Flüge'(h01).

* The internal table CT contains the information about all those
* fields that should be displayed as pushbuttons.
  wa_layout-stylefname = 'CT'.

* fill field catalog
  CLEAR wa_field_cat.
  wa_field_cat-fieldname = 'DISPLAY_BOOKINGS'.
  wa_field_cat-col_pos = 1.
  wa_field_cat-coltext = 'Displ. Book.?'(h11).
  APPEND wa_field_cat TO it_field_cat.


  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SFLIGHT'
      is_layout        = wa_layout
    CHANGING
      it_outtab        = it_sflight
      it_fieldcatalog  = it_field_cat
    EXCEPTIONS
      OTHERS           = 1.
  IF sy-subrc <> 0.
    MESSAGE a012(bc405_408).
  ENDIF.

* register event that is triggered when pushbutton is clicked
  SET HANDLER lcl_handler=>on_button_click  FOR alv.
ENDMODULE.                 " create_objects  OUTPUT

*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'..
      PERFORM free.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT

*----------------------------------------------------------------------*
FORM free.
  CALL METHOD: alv->free,
               cont->free.

  FREE: alv,
        cont.
ENDFORM.                    " free
