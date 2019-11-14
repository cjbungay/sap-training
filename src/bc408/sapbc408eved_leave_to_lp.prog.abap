*&---------------------------------------------------------------------*
*& Report  SAPBC408EVED_LEAVE_TO_LP                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408eved_leave_to_lp                                    .
DATA: wa_sflight TYPE sflight,
      it_sflight LIKE TABLE OF wa_sflight,
      ok_code TYPE sy-ucomm,
      wa_sbook TYPE sbook,
      it_sbook TYPE TABLE OF sbook.

DATA: alv TYPE REF TO cl_gui_alv_grid,
      cont TYPE REF TO cl_gui_custom_container.

DATA: dialogbox TYPE REF TO cl_gui_dialogbox_container,
      alv_book TYPE REF TO cl_gui_alv_grid.

DATA: my_variant TYPE disvariant.

DATA: leave_to_list.
SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_con FOR wa_sflight-connid.
SELECTION-SCREEN SKIP.
PARAMETERS: pa_lv TYPE slis_vari.

*---------------------------------------------------------------------*
CLASS: lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_doubleclick
                     FOR EVENT double_click OF cl_gui_alv_grid
                     IMPORTING e_row.
ENDCLASS.                    "lcl_handler DEFINITION

*---------------------------------------------------------------------*
CLASS: lcl_handler IMPLEMENTATION.
  METHOD on_doubleclick.
    READ TABLE it_sflight INTO wa_sflight INDEX e_row-index.
    IF sy-subrc NE 0.
      MESSAGE i075(bc408).
      EXIT.
    ENDIF.

    SELECT * FROM sbook INTO wa_sbook
      WHERE carrid = wa_sflight-carrid
        AND connid = wa_sflight-connid
        AND fldate = wa_sflight-fldate.


      WRITE: / wa_sbook-bookid,
               wa_sbook-customid,
               wa_sbook-custtype,
               wa_sbook-smoker,
               wa_sbook-luggweight UNIT wa_sbook-wunit,
               wa_sbook-wunit,
               wa_sbook-class,
               wa_sbook-order_date,
               wa_sbook-cancelled.
    ENDSELECT.

    LEAVE TO LIST-PROCESSING.
    SET PF-STATUS space.
    SET TITLEBAR space.

  ENDMETHOD.                    "on_doubleclick
ENDCLASS.                    "lcl_handler IMPLEMENTATION


*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.
  PERFORM get_layout_variant CHANGING pa_lv.

*&---------------------------------------------------------------------*
START-OF-SELECTION.
  CALL SCREEN 100.

*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.

ENDMODULE.                 " STATUS_0100  OUTPUT

*----------------------------------------------------------------------*
module clear_ok_code output.
  clear ok_code.
endmodule.                 " clear_ok_code  OUTPUT

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
    MESSAGE a010(bc408).
  ENDIF.

  CREATE OBJECT alv
    EXPORTING
      i_parent          = cont
      i_appl_events     = 'X'
    EXCEPTIONS
      OTHERS            = 1
      .
  IF sy-subrc <> 0.
    MESSAGE a010(bc408).
  ENDIF.

  SET HANDLER lcl_handler=>on_doubleclick  FOR alv.
ENDMODULE.                 " create_objects  OUTPUT

*----------------------------------------------------------------------*
MODULE transfer_data OUTPUT.

  my_variant-report = sy-cprog.
  IF NOT pa_lv IS INITIAL.
    my_variant-variant = pa_lv.
  ENDIF.

  CALL METHOD alv->set_table_for_first_display
    EXPORTING
*    I_BYPASSING_BUFFER            =
*    I_BUFFER_ACTIVE               =
*    I_CONSISTENCY_CHECK           =
      i_structure_name              = 'SFLIGHT'
    is_variant                    = my_variant
    i_save                        = 'A'
*    I_DEFAULT                     = 'X'
*    IS_LAYOUT                     =
*    IS_PRINT                      =
*    IT_SPECIAL_GROUPS             =
*    IT_TOOLBAR_EXCLUDING          =
*    IT_HYPERLINK                  =
*    IT_ALV_GRAPHICS               =
    CHANGING
      it_outtab                     = it_sflight
*    IT_FIELDCATALOG               =
*    IT_SORT                       =
*    IT_FILTER                     =
    EXCEPTIONS
*    INVALID_PARAMETER_COMBINATION = 1
*    PROGRAM_ERROR                 = 2
*    TOO_MANY_LINES                = 3
      OTHERS                        = 1
          .
  IF sy-subrc <> 0.
    MESSAGE a012(bc408).
  ENDIF.

ENDMODULE.                 " transfer_data  OUTPUT

*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      PERFORM free.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT

*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'EXIT' OR 'CANC'.
      PERFORM free. " here and there
      LEAVE TO SCREEN 0.

  ENDCASE.
ENDMODULE.                 " exit  INPUT

*----------------------------------------------------------------------*
FORM free.
  CALL METHOD: alv->free,
               cont->free.

  FREE: alv,
        cont.
ENDFORM.                    " free

*----------------------------------------------------------------------*
FORM get_layout_variant CHANGING p_pa_lv TYPE slis_vari.

  DATA: l_disvariant TYPE disvariant.

  l_disvariant-report = sy-cprog.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'
      i_tabname   = '1'
    CHANGING
      cs_variant  = l_disvariant
    EXCEPTIONS
      OTHERS      = 1.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  p_pa_lv = l_disvariant-variant.
ENDFORM.                    " get_layout_variant
