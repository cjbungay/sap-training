*&---------------------------------------------------------------------*
*& Report  SAPBC408EVED
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408eved.

* allow symbolic names for icons
TYPE-POOLS: col, icon.

* work area plus internal table for ALV data and color information
DATA:
  BEGIN OF wa_sbook.
INCLUDE TYPE sbook.
DATA: phone TYPE scustom-telephone,
cancelled_icon TYPE icon-id,                                "char 4
class_indicator,
it_colfields TYPE lvc_t_scol,
color(4),
END OF wa_sbook,
it_sbook LIKE TABLE OF wa_sbook.

DATA: variant TYPE disvariant.

* data needed for layout
DATA:
  wa_layout  TYPE lvc_s_layo.

* field catalog and its work area
DATA:
  it_fieldcat TYPE lvc_t_fcat,
  wa_fieldcat TYPE lvc_s_fcat.

DATA:
  it_special_groups TYPE lvc_t_sgrp,
  wa_special_group  TYPE lvc_s_sgrp.

DATA:
  ok_code    LIKE sy-ucomm.

DATA: cont   TYPE REF TO cl_gui_custom_container,
      alv    TYPE REF TO cl_gui_alv_grid,

* work area is required in order to fill the internal table
* with the fields/colors
  wa_colfield LIKE LINE OF wa_sbook-it_colfields,

  it_excluded_functions TYPE ui_functions,

  it_sorting_criteria  TYPE lvc_t_sort,
  wa_sorting_criterion TYPE lvc_s_sort.

* structure needed for print setting like group change.
DATA: print_settings TYPE lvc_s_prnt.


SELECT-OPTIONS: so_car FOR wa_sbook-carrid
                       MEMORY ID car DEFAULT 'AA' ,
                so_con FOR wa_sbook-connid MEMORY ID con,
                so_dat FOR wa_sbook-fldate MEMORY ID dat.
PARAMETERS: pa_lv TYPE disvariant-variant.


************************************************************************
*Local class for ALV event handling
************************************************************************
CLASS: lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_doubleclick
                     FOR EVENT double_click OF cl_gui_alv_grid
                     IMPORTING es_row_no,
                   print_top
                     FOR EVENT print_top_of_page OF cl_gui_alv_grid,
                   on_toolbar
                     FOR EVENT toolbar OF cl_gui_alv_grid
                     IMPORTING e_object,
                   on_user_command
                     FOR EVENT user_command OF cl_gui_alv_grid
                     IMPORTING e_ucomm.
ENDCLASS.                    "lcl_handler DEFINITION


*---------------------------------------------------------------------*
CLASS: lcl_handler IMPLEMENTATION.
  METHOD on_doubleclick.
    DATA:
      message_text(70),
      l_form TYPE scustom-form,
      l_name TYPE scustom-name,
      l_city TYPE scustom-city.

    READ TABLE it_sbook INTO wa_sbook INDEX es_row_no-row_id.
    IF sy-subrc NE 0.
      MESSAGE i075(bc405_408).
      EXIT.
    ENDIF.
    DATA: lang(100).
    SELECT SINGLE form name city
      FROM scustom
      INTO (l_form, l_name, l_city)
      WHERE id = wa_sbook-customid.

* build message text
    CONCATENATE l_form l_name l_city
      INTO message_text SEPARATED BY space.

    MESSAGE message_text TYPE 'I'.

  ENDMETHOD.                    "on_doubleclick

  METHOD print_top.
    DATA: pos TYPE i.
    FORMAT COLOR COL_HEADING.
    WRITE: / sy-datum.
    pos = sy-linsz / 2 - 3. " length of pagno: 6 chars
    WRITE AT pos sy-pagno.
    pos = sy-linsz - 11. " length of username: 12 chars
    WRITE: AT pos sy-uname.
    ULINE.
  ENDMETHOD.                    "print_top

************************************************************************
*       Expands toolbar                                                *
************************************************************************
  METHOD on_toolbar.
    DATA l_wa_button TYPE stb_button.

* Separator
    l_wa_button-butn_type = 3.
    INSERT l_wa_button INTO TABLE e_object->mt_toolbar.

* Create button "Display bookings"
    CLEAR l_wa_button.
    l_wa_button-function = 'DISP_CARRIER'.
    l_wa_button-icon = icon_flight.
    l_wa_button-quickinfo =
    'Details zur Fluggesellschaft'(z02).                    "#EC *
    l_wa_button-butn_type = 0.
    INSERT l_wa_button INTO TABLE e_object->mt_toolbar.

  ENDMETHOD.                    "on_toolbar

************************************************************************
*         Handles self-defined user-commands                           *
************************************************************************
  METHOD on_user_command.
    DATA:
      l_row    TYPE i,
      wa_scarr TYPE scarr.

    CASE e_ucomm.
* implementing function "Display carrier detail"
      WHEN 'DISP_CARRIER'.
        CALL METHOD alv->get_current_cell
          IMPORTING
            e_row = l_row.
        READ TABLE it_sbook
          INTO wa_sbook
          INDEX l_row.

        SELECT SINGLE *
          FROM scarr
          INTO wa_scarr
          WHERE carrid = wa_sbook-carrid.
        CHECK sy-subrc = 0.
        MESSAGE wa_scarr-carrname TYPE 'I'.
    ENDCASE.
  ENDMETHOD.                    "on_user_command
ENDCLASS.                    "lcl_handler IMPLEMENTATION




******************************************************************
* at least the report name has to be passed on to the layout field.
INITIALIZATION.
  variant-report = sy-cprog.

******************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.
  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'
    CHANGING
      cs_variant  = variant
    EXCEPTIONS
      OTHERS      = 1.

  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    pa_lv = variant-variant.
  ENDIF.

************************************************************************
START-OF-SELECTION.
  SELECT * FROM sbook
    INTO CORRESPONDING FIELDS OF TABLE it_sbook
    WHERE carrid IN so_car
    AND   connid IN so_con
    AND   fldate IN so_dat.

* mark lines of business customers
  LOOP AT it_sbook
    INTO wa_sbook
    WHERE custtype = 'B'.
    wa_sbook-color = 'C711'.
    MODIFY it_sbook FROM wa_sbook TRANSPORTING color.
  ENDLOOP.

* set indicator for class
  LOOP AT it_sbook
    INTO wa_sbook.
    CASE wa_sbook-class.
      WHEN 'Y'.         "Economy
        wa_sbook-class_indicator = '1'.
      WHEN 'B' OR 'C'.  "Business
        wa_sbook-class_indicator = '2'.
      WHEN 'F'.         "First
        wa_sbook-class_indicator = '3'.
    ENDCASE.
    MODIFY it_sbook FROM wa_sbook TRANSPORTING class_indicator.
  ENDLOOP.

* loop at data table and find the smokers
* set color red for the field 'SMOKER'
  LOOP AT it_sbook INTO wa_sbook
    WHERE smoker = 'X'.
    wa_colfield-fname     = 'SMOKER'.
    wa_colfield-color-col = col_negative.
    wa_colfield-color-int = '1'.
    wa_colfield-color-inv = '0'.
    APPEND wa_colfield TO wa_sbook-it_colfields.
    MODIFY it_sbook FROM wa_sbook TRANSPORTING it_colfields.
  ENDLOOP.

* add additional data for each line
  LOOP AT it_sbook INTO wa_sbook.
    SELECT SINGLE telephone
      FROM scustom
      INTO wa_sbook-phone
      WHERE id = wa_sbook-customid.

    IF wa_sbook-cancelled = 'X'.
      wa_sbook-cancelled_icon = icon_cancel.
    ENDIF.

    MODIFY it_sbook
      FROM wa_sbook
      TRANSPORTING phone cancelled_icon.
  ENDLOOP.

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
MODULE create_objects OUTPUT.
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

* register event handlers
  SET HANDLER: lcl_handler=>on_toolbar FOR alv,
               lcl_handler=>on_user_command FOR alv,
               lcl_handler=>print_top FOR alv,
               lcl_handler=>on_doubleclick FOR alv.

*set layout
  wa_layout-grid_title = 'ALV demo'(t01).
  wa_layout-zebra      = 'X'.
  wa_layout-cwidth_opt = 'X'.
  wa_layout-sel_mode   = 'A'.
  wa_layout-info_fname = 'COLOR'.

* exception lights
  wa_layout-excp_fname = 'CLASS_INDICATOR'.

* internal table with the fields/colors to the layout structure
  wa_layout-ctab_fname = 'IT_COLFIELDS'.

* exclude functions from toolbar
  APPEND cl_gui_alv_grid=>mc_fc_print_back TO it_excluded_functions.
  APPEND cl_gui_alv_grid=>mc_fc_detail     TO it_excluded_functions.
  APPEND cl_gui_alv_grid=>mc_fc_filter     TO it_excluded_functions.
  APPEND cl_gui_alv_grid=>mc_mb_sum        TO it_excluded_functions.

* determine sorting order for first display
  wa_sorting_criterion-fieldname = 'ORDER_DATE'.
*  wa_sorting_criterion-down = 'X'.
*  wa_sorting_criterion-up = space.
*  wa_sorting_criterion-spos = 1.
  APPEND wa_sorting_criterion TO it_sorting_criteria.

  CLEAR wa_sorting_criterion.
  wa_sorting_criterion-fieldname = 'CUSTOMID'.
  wa_sorting_criterion-up = 'X'.
*  wa_sorting_criterion-spos = 2.
  APPEND wa_sorting_criterion TO it_sorting_criteria.

* define special groups for selection window
  wa_special_group-sp_group = 'FLIG'.
  wa_special_group-text = 'Flight information'(fli).
  APPEND wa_special_group TO it_special_groups.

  wa_special_group-sp_group = 'BOOK'.
  wa_special_group-text = 'Bookings information'(boo).
  APPEND wa_special_group TO it_special_groups.


* define field catalog
  wa_fieldcat-fieldname = 'PHONE'.
  wa_fieldcat-ref_field = 'TELEPHONE'.
  wa_fieldcat-ref_table = 'SCUSTOM'.
  wa_fieldcat-col_pos   = 25.
  APPEND wa_fieldcat TO it_fieldcat.

  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname = 'CANCELLED_ICON'.
  wa_fieldcat-icon = 'X'.
  wa_fieldcat-coltext = 'Storniert'(h05).
  wa_fieldcat-col_pos   = 21.
  APPEND wa_fieldcat TO it_fieldcat.

  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname = 'CANCELLED'.
  wa_fieldcat-no_out   = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.

* The following lines do not change the appearance of the columns,
* but add them to the special fields catalog
  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname = 'CARRID'.
  wa_fieldcat-sp_group = 'FLIG'.
  APPEND wa_fieldcat TO it_fieldcat.

  wa_fieldcat-fieldname = 'CONNID'.
  wa_fieldcat-sp_group = 'FLIG'.
  APPEND wa_fieldcat TO it_fieldcat.

  wa_fieldcat-fieldname = 'FLDATE'.
  wa_fieldcat-sp_group = 'FLIG'.
  APPEND wa_fieldcat TO it_fieldcat.

  wa_fieldcat-fieldname = 'BOOKID'.
  wa_fieldcat-sp_group = 'BOOK'.
  APPEND wa_fieldcat TO it_fieldcat.

* make group change indicators possible
  print_settings-grpchgedit = 'X'.

  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name     = 'SBOOK'
      is_variant           = variant
      i_save               = 'A'
      is_layout            = wa_layout
      it_toolbar_excluding = it_excluded_functions
      it_special_groups    = it_special_groups
      is_print             = print_settings
    CHANGING
      it_outtab            = it_sbook
      it_sort              = it_sorting_criteria
      it_fieldcatalog      = it_fieldcat
    EXCEPTIONS
      OTHERS               = 1.
  IF sy-subrc <> 0.
    MESSAGE a012(bc405_408).
  ENDIF.

ENDMODULE.                 " create_objects  OUTPUT

************************************************************************
*PAI Modules
************************************************************************
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
*      CALL METHOD: alv->free, cont->free.
*      FREE: alv, cont.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
