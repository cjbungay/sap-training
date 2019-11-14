REPORT sapbc480_add_layout MESSAGE-ID bc480.

TYPE-POOLS: vrm.

DATA:
  ok_code LIKE sy-ucomm,
  gs_fplayoutt TYPE fplayoutt,
  gv_author TYPE tadir-author,
  ra_cur TYPE RANGE OF scustom,
  gs_cur LIKE LINE OF ra_cur,

* Dropdown list for sending country on selection-screen must be filled
  field_for_dropdown     TYPE vrm_id,
  gt_values              TYPE vrm_values,
  gs_values              LIKE LINE OF gt_values.


CONSTANTS:
  c_template_form TYPE fpwbformname VALUE 'BC480_LAYOUT_TEST_NEW'.


SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
PARAMETERS:
  pa_form   TYPE fpwbformname MEMORY ID fpwbform MODIF ID sho
            OBLIGATORY MATCHCODE OBJECT hfpwbform.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(80) text-se2.
SELECTION-SCREEN END OF LINE.


* Explanation of the sending country.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(80) text-se4.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(80) text-se5.
SELECTION-SCREEN END OF LINE.

PARAMETERS:
  pa_send TYPE adrc-country OBLIGATORY
  AS LISTBOX VISIBLE LENGTH 40.
SELECTION-SCREEN END OF SCREEN 1100.

*&---------------------------------------------------------------------*
*& Event INITIALIZATION
*&---------------------------------------------------------------------*
IF sy-langu = 'D'.
  pa_send = 'DE'.
ELSE.
  pa_send = 'GB'.
ENDIF.

*&---------------------------------------------------------------------*
*& Event AT SELECTION-SCREEN OUTPUT
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
* Which parameter should have the dropdown list?
  field_for_dropdown  = 'PA_SEND'.

* Fill two-column dropdown list
  REFRESH gt_values.
  gs_values-key  = 'DE'.
  gs_values-text = 'Germany'(sde).
  APPEND gs_values TO gt_values.

  gs_values-key  = 'GB'.
  gs_values-text = 'Great Britain'(sgb).
  APPEND gs_values TO gt_values.

* Pass information to function module
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = field_for_dropdown
      values = gt_values.

*&---------------------------------------------------------------------*
*& Event AT SELECTION-SCREEN ON pa_form
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON pa_form.
  SELECT SINGLE name
    FROM fpcontext
    INTO pa_form
    WHERE name = pa_form.
  IF sy-subrc <> 0.
    MESSAGE e030 WITH pa_form.
*   Form &1 not found
  ENDIF.

  SELECT SINGLE author
    FROM tadir
    INTO gv_author
    WHERE pgmid    = 'R3TR' AND
          object   = 'SFPF' AND
          obj_name = pa_form.
  IF gv_author <> sy-uname.
    MESSAGE e031. "#EC* User-Specific Control Flow
*   You may change only your own objects
  ENDIF.

  CALL FUNCTION 'ENQUEUE_EFPFORM'
    EXPORTING
      mode_fpcontext = 'E'
      name           = pa_form
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  IF sy-subrc <> 0.
    MESSAGE e027 WITH pa_form.
* Form &1 could not be locked
  ENDIF.


  gs_fplayoutt-name = pa_form.
  gs_fplayoutt-state = 'A'.
  gs_fplayoutt-language = sy-langu.

*&---------------------------------------------------------------------*
*& Event AT SELECTION-SCREEN
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN.
  SELECT SINGLE * FROM fplayoutt
    INTO gs_fplayoutt
    WHERE name = pa_form AND
          language = sy-langu.
  IF sy-dbcnt > 0.
    MESSAGE w029 WITH pa_form.
*  ATTENTION! Form &1 has a layout already - it will be overwritten.
  ENDIF.

*&---------------------------------------------------------------------*
*& Event START-OF-SELECTION.
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  CALL SCREEN 100.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'S100'.
ENDMODULE.                 " STATUS_0100  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  init_pic  OUTPUT
*----------------------------------------------------------------------*
*& Explanatory screenshot picture is uploaded.
*& This picture was uploaded to table wwwdata with transaction SMW0.
*----------------------------------------------------------------------*

MODULE init_pic OUTPUT.
  PERFORM load_pic.
ENDMODULE." init_pic  OUTPUT



*&---------------------------------------------------------------------*
*&      Module  exit_command  INPUT
*----------------------------------------------------------------------*
MODULE exit_command INPUT.
  CASE ok_code.
    WHEN 'E' OR 'ENDE' OR 'ECAN'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.                 " exit_command  INPUT


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'ONLI'.
      PERFORM add_layout.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT


*&---------------------------------------------------------------------*
*&      Form  add_layout
*----------------------------------------------------------------------*
FORM add_layout .
  DELETE FROM fplayoutt
    WHERE name = pa_form AND
          language = sy-langu.

* select template layout
  SELECT SINGLE layout
    FROM fplayoutt
    INTO gs_fplayoutt-layout
    WHERE name = c_template_form AND
          state = 'A' AND
          language = sy-langu.
  IF sy-subrc <> 0.
    SELECT SINGLE layout
      FROM fplayoutt
      INTO gs_fplayoutt-layout
      WHERE name = c_template_form AND
            state = 'A' AND
            language = 'D'.
    IF sy-subrc <> 0.
      MESSAGE e028 WITH c_template_form.
* Template form &1 not found
    ENDIF.
  ENDIF.

  MODIFY fplayoutt FROM gs_fplayoutt.


  CALL FUNCTION 'DEQUEUE_EFPFORM'
    EXPORTING
      mode_fpcontext = 'E'
      name           = pa_form.

  TRY.
      CALL METHOD cl_fp_wb_form=>activate
        EXPORTING
          i_name = pa_form.
    CATCH cx_root.                                       "#EC CATCH_ALL
      MESSAGE e032.
*   Automatic generation failed.
  ENDTRY.

  gs_cur-sign = 'I'.
  gs_cur-option = 'EQ'.
  gs_cur-low = 1.  " German customer
  APPEND gs_cur TO ra_cur.

  gs_cur-low = 5. " UK customer
  APPEND gs_cur TO ra_cur.

* Call test report that will process form
  SUBMIT sapbc480_demo                                   "#EC CI_SUBMIT
          WITH pa_form = pa_form
          WITH pa_send = pa_send
        WITH pa_lang = sy-langu
          WITH pa_nodlg = 'X'
          WITH pa_nopdf = space
          WITH pa_prev  = 'X'
*        with pa_rfc ...
        WITH so_cusid IN ra_cur
AND RETURN.


* now delete newly created form layout again
  DELETE FROM fplayoutt
    WHERE name = pa_form AND
          language = sy-langu.

  IF sy-dbcnt > 0.
    MESSAGE i033 WITH pa_form.
*   The layout of form &1 has been deleted again
  ENDIF.
ENDFORM.                    " add_layout


*&---------------------------------------------------------------------*
*&      Form  load_pic
*&---------------------------------------------------------------------*
FORM load_pic .
  DATA:
    lv_container     TYPE REF TO cl_gui_custom_container,
    lv_pic           TYPE REF TO cl_gui_picture,
    lv_url(255),
    query_table      TYPE TABLE OF w3query,
    query_table_line TYPE w3query,
    html_table       TYPE TABLE OF w3html,
    return_code      TYPE w3param-ret_code,
    content_type     TYPE w3param-cont_type,
    content_length   TYPE w3param-cont_len,
    pic_data         TYPE TABLE OF w3mime,
    pic_size         TYPE i.

  IF lv_container IS INITIAL.
    CREATE OBJECT lv_container
           EXPORTING  container_name = 'PIC_CONT'
           EXCEPTIONS OTHERS         = 1.
    CREATE OBJECT lv_pic
           EXPORTING  parent = lv_container
           EXCEPTIONS OTHERS = 1.
    IF sy-subrc NE 0.
      EXIT.
    ENDIF.
  ENDIF.

  query_table_line-name  = '_OBJECT_ID'.                    "#EC NOTEXT
  CASE sy-langu.
    WHEN 'D'.
      query_table_line-value = 'BC480_SP01_MULTI_PDF_DE'.   "#EC NOTEXT
    WHEN 'F'.
      query_table_line-value = 'BC480_SP01_MULTI_PDF_FR'.   "#EC NOTEXT
    WHEN OTHERS.
      query_table_line-value = 'BC480_SP01_MULTI_PDF_EN'.   "#EC NOTEXT
  ENDCASE.
  APPEND query_table_line TO query_table.

  CALL FUNCTION 'WWW_GET_MIME_OBJECT'
    TABLES
      query_string   = query_table
      html           = html_table
      mime           = pic_data
    CHANGING
      return_code    = return_code
      content_type   = content_type
      content_length = content_length
    EXCEPTIONS
      OTHERS         = 4.
  IF sy-subrc = 0.
    pic_size = content_length.
  ENDIF.

  CALL FUNCTION 'DP_CREATE_URL'
    EXPORTING
      type     = 'image'
      subtype  = cndp_sap_tab_unknown
      size     = pic_size
      lifetime = cndp_lifetime_transaction
    TABLES
      data     = pic_data
    CHANGING
      url      = lv_url
    EXCEPTIONS
      OTHERS   = 1.

  CALL METHOD lv_pic->load_picture_from_url
    EXPORTING
      url    = lv_url
    EXCEPTIONS
      OTHERS = 1.
ENDFORM.                    " load_pic
