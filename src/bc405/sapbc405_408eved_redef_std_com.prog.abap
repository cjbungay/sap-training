
*&---------------------------------------------------------------------*
*& Report  SAPBC408EVED_REDEF_STD_COMM
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408eved_redef_std_comm.

DATA: wa_sflight TYPE sflight,
      it_sflight LIKE TABLE OF wa_sflight,
      ok_code TYPE sy-ucomm.

DATA: alv TYPE REF TO cl_gui_alv_grid,
      cont TYPE REF TO cl_gui_custom_container.

DATA: dialogbox TYPE REF TO cl_gui_dialogbox_container,
      alv_book TYPE REF TO cl_gui_alv_grid.

DATA: wa_sbook TYPE sbook,
      it_sbook TYPE TABLE OF sbook.
DATA: row TYPE i.

*---------------------------------------------------------------------*
*       CLASS lcl_handle DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_before_user_command
                     FOR EVENT before_user_command OF cl_gui_alv_grid
                     IMPORTING e_ucomm,
                  on_user_command
                     FOR EVENT user_command OF cl_gui_alv_grid
                     IMPORTING e_ucomm.
ENDCLASS.                    "lcl_handle DEFINITION


*---------------------------------------------------------------------*
*       CLASS lcl_handle IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_handler IMPLEMENTATION.
  METHOD on_before_user_command.
    CASE e_ucomm.
      WHEN cl_gui_alv_grid=>mc_fc_detail.
        CALL METHOD alv->set_user_command
          EXPORTING
            i_ucomm = 'DIS_BOOK'.
    ENDCASE.
  ENDMETHOD.                    "on_before_user_command

  METHOD on_user_command.
    CASE e_ucomm.
      WHEN 'DIS_BOOK'.
        CALL METHOD alv->get_current_cell
          IMPORTING
            e_row = row.

        READ TABLE it_sflight INTO wa_sflight INDEX row.
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
              caption                     = 'Buchungen'
            EXCEPTIONS
              OTHERS                      = 0
              .

          IF sy-subrc <> 0.
            MESSAGE a010(bc405_408).
          ENDIF.

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
    ENDCASE.
  ENDMETHOD.                    "on_doubleclick


ENDCLASS.                    "lcl_handle IMPLEMENTATION


SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_con FOR wa_sflight-connid.

START-OF-SELECTION.
  CALL SCREEN 100.

*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.

ENDMODULE.                 " STATUS_0100  OUTPUT

*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      PERFORM free.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT

*----------------------------------------------------------------------*
MODULE get_data OUTPUT.


  SELECT * FROM sflight
  INTO TABLE it_sflight
  WHERE carrid IN so_car
  AND   connid IN so_con.

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

  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SFLIGHT'
    CHANGING
      it_outtab        = it_sflight
    EXCEPTIONS
      OTHERS           = 1.
  IF sy-subrc <> 0.
    MESSAGE a012(bc405_408).
  ENDIF.

  SET HANDLER: lcl_handler=>on_before_user_command FOR alv,
               lcl_handler=>on_user_command FOR alv.
ENDMODULE.                 " create_objects  OUTPUT

*----------------------------------------------------------------------*
FORM free.
  CALL METHOD: alv->free,
               cont->free.

  FREE: alv,
        cont.
ENDFORM.                    " free


*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT
