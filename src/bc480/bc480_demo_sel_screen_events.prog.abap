*&---------------------------------------------------------------------*
*&  Include           BC480_DEMO_SEL_SCREEN_EVENTS
*&---------------------------------------------------------------------*
**********************************************************************
INITIALIZATION.
* SAP memory parameters
  GET PARAMETER ID 'FPWBFORM' FIELD pa_form.
  IF pa_form IS INITIAL.
    pa_form = 'BC480_FINAL'.
  ENDIF.

  GET PARAMETER ID 'SPOOL_DEV' FIELD pa_prnt.
  IF pa_prnt IS INITIAL.
    SELECT SINGLE spld
    FROM usr01
    INTO pa_prnt
    WHERE bname = sy-uname.

    IF pa_prnt IS INITIAL.
      pa_prnt = 'P280'.
    ENDIF.
  ENDIF.

  GET PARAMETER ID 'ADVANCED_ID' FIELD gv_advanced.         "#EC EXISTS

  GET PARAMETER ID 'ACTIVE_TAB' FIELD tabs-activetab.       "#EC EXISTS
  GET PARAMETER ID 'ACTIVE_DYNNR' FIELD tabs-dynnr.         "#EC EXISTS
  IF tabs-activetab IS INITIAL OR tabs-dynnr IS INITIAL.
    tabs-activetab = 'TAB_PRINTER'.
    tabs-dynnr = '0110'.
  ENDIF.

  GET PARAMETER ID 'PREVIEW' FIELD pa_prev.                 "#EC EXISTS
  IF sy-subrc <> 0. "first call
    pa_prev = 'X'.
  ENDIF.

  GET PARAMETER ID 'SUPPR_PRT_DLG' FIELD pa_nodlg.          "#EC EXISTS
  IF sy-subrc <> 0. "first call
    pa_nodlg = 'X'.
  ENDIF.

  GET PARAMETER ID 'SELECT_BOOKINGS' FIELD pa_db.           "#EC EXISTS
  IF sy-subrc <> 0. "first call
    pa_db = 'X'.
  ENDIF.


  GET PARAMETER ID 'LANGUAGE' FIELD pa_lang.                "#EC EXISTS
  IF sy-subrc <> 0. "first call
    pa_lang = sy-langu.
  ENDIF.

  GET PARAMETER ID 'LND' FIELD pa_cntry.
  IF sy-subrc <> 0. "first call
    CASE sy-langu.
      WHEN 'D'.
        pa_cntry = 'DE'.
      WHEN 'E'.
        pa_cntry = 'US'.
      WHEN 'F'.
        pa_cntry = 'FR'.
      WHEN OTHERS.
        pa_lang = 'E'.
        pa_cntry = 'US'.
    ENDCASE.
  ENDIF.

  GET PARAMETER ID 'SENDER_COUNTRY' FIELD pa_send.          "#EC EXISTS
  IF sy-subrc <> 0. "first call
    CASE sy-langu.
      WHEN 'D'.
        pa_send = 'DE'.
      WHEN 'E'.
        pa_send = 'US'.
      WHEN 'F'.
        pa_send = 'FR'.
      WHEN OTHERS.
        pa_send = 'US'.
    ENDCASE.
  ENDIF.


  GET PARAMETER ID 'GRAPHIC_FROM_UPLOAD' FIELD pa_image.    "#EC EXISTS
  IF sy-subrc <> 0. "first call
    pa_image = 'c:\Windows\Coffee Bean.bmp'.                "#EC NOTEXT
  ENDIF.

  GET PARAMETER ID 'GRAPHIC_FROM_URL' FIELD pa_url.         "#EC EXISTS
  IF sy-subrc <> 0. "first call
    pa_url = c_intranet.
  ENDIF.


  GET PARAMETER ID 'RFC' FIELD pa_rfc.
  IF sy-subrc <> 0. "first call
    pa_rfc = 'ADS'.
  ENDIF.

  GET PARAMETER ID 'ADS' FIELD gv_sundries.                 "#EC EXISTS
  GET PARAMETER ID 'PROC_TYPE' FIELD gv_proc_type.          "#EC EXISTS

  CALL METHOD cl_gui_frontend_services=>get_upload_download_path
    CHANGING
      upload_path   = upl_path
      download_path = downl_path
    EXCEPTIONS
      OTHERS        = 6.
  IF sy-subrc <> 0 OR STRLEN( downl_path ) = 0.
    pa_path = 'C:\'.
  ELSE.
    pa_path = downl_path.

    SEARCH pa_path FOR '/'.
    last_char = STRLEN( pa_path ) - 1.
    IF sy-subrc = 0 AND pa_path+last_char <> '/'.
      CONCATENATE pa_path '/' INTO pa_path.
    ELSEIF pa_path+last_char <> '\'.
      CONCATENATE pa_path '\' INTO pa_path.
    ENDIF.
  ENDIF.


* Which parameter should have the dropdown list?
  field_for_dropdown  = 'PA_URL'.

* Fill two-column dropdown list
  gs_values-key  = c_intranet.
  gs_values-text = 'Image from intranet'(se7).
  APPEND gs_values TO gt_values.

  gs_values-key  = c_internet.
  gs_values-text = 'Image from Internet'(se8).
  APPEND gs_values TO gt_values.

* Pass information to function module
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = field_for_dropdown
      values = gt_values.


*find four customers in four different countries.
  ra_cus1_line-sign = 'I'.
  ra_cus1_line-option = 'EQ'.

  SELECT SINGLE id
    FROM scustom
    INTO ra_cus1_line-low
    WHERE country = 'DE'.                                   "#EC *
  APPEND ra_cus1_line TO ra_cus1.

  SELECT SINGLE id
    FROM scustom
    INTO ra_cus1_line-low
    WHERE country = 'FR'.                                   "#EC *
  APPEND ra_cus1_line TO ra_cus1.

  SELECT SINGLE id
    FROM scustom
    INTO ra_cus1_line-low
    WHERE country = 'US'.                                   "#EC *
  APPEND ra_cus1_line TO ra_cus1.

  SELECT SINGLE id
    FROM scustom
    INTO ra_cus1_line-low
    WHERE country = 'GB'.                                   "#EC *
  APPEND ra_cus1_line TO ra_cus1.


* set text of pushbutton
  IF gv_advanced = 'X'.
    push01 = 'No advanced functions'(noa).
  ELSE.
    push01 = 'Advanced functions'(adv).
  ENDIF.

* set texts of tab strips
  data_src = 'Data source'(se1).
  langcntr = 'Language/Country'(se2).
  process  = 'Processing settings'(se3).
  sundries = 'Sundries'(se4).

**********************************************************************
* dynamic screen modifications
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF gv_advanced = space AND
      screen-group1 <> 'SHO' AND screen-group1 <> 'CUS'.
      screen-active = 0.
    ENDIF.

    IF gv_max = space AND
      ( screen-group1 = 'MIN' ).
      screen-active = 0.
    ENDIF.

    IF pa_cnfix = ' ' AND screen-group1 = 'LAN'.
      screen-active = 0.
    ENDIF.

    IF pa_four = 'X' AND screen-group1 = 'CUS'.
      screen-input = 0.
    ENDIF.

    IF pa_no_db IS INITIAL AND screen-group1 = 'NUM' .
      screen-active = 0.
    ENDIF.

* Spool processing?
    IF pa_spool IS INITIAL AND screen-group1 = 'PRN'.
      screen-active = 0.
    ENDIF.

    IF pa_gui IS INITIAL AND screen-group1 = 'PAT' OR
      pa_mail IS INITIAL AND screen-group1 = 'MAI' OR
      pa_fax  IS INITIAL AND screen-group1 = 'FAX'.
      screen-input = 0.
    ENDIF.

* Authorization to change ADS?
*    IF screen-group1 = 'ADS'.
*      AUTHORITY-CHECK OBJECT 'S_ADMI_FCD'
*               ID 'S_ADMI_FCD' FIELD 'NADM'.
*      IF sy-subrc <> 0.
*        screen-active = 0.
*      ENDIF.
*      AUTHORITY-CHECK OBJECT 'S_TCODE'
*               ID 'TCD' FIELD 'SM59'.
*      IF sy-subrc <> 0.
*        screen-active = 0.
*      ENDIF.
*    ENDIF.

    IF screen-name = 'SUNDRIES' AND gv_sundries IS INITIAL.
      screen-active = 0.
    ENDIF.

* deactivate tab with processing details
    IF screen-name = 'PROCESS' AND gv_proc_type IS INITIAL.
      screen-active = 0.
    ENDIF.

    MODIFY SCREEN.

  ENDLOOP.


**********************************************************************
AT SELECTION-SCREEN ON pa_form.
  SELECT SINGLE name
    FROM fpcontext
    INTO pa_form
    WHERE name = pa_form AND
          state = 'A'.
  CHECK sy-subrc <> 0.
  MESSAGE e004 WITH pa_form.
*   No active form &1 available


**********************************************************************
AT SELECTION-SCREEN ON BLOCK country.
  CHECK pa_cnfix = 'X'.
  CASE sy-ucomm.
   WHEN 'ONLI' OR 'ADVANCED' OR 'TAB_DATA_SOURCE' OR 'TAB_LANG_COUNTRY'
     OR 'TAB_PROCESS' OR 'TAB_SUNDRIES'.
      IF pa_lang IS INITIAL.
        MESSAGE e007.
*   Enter language
      ENDIF.
      IF pa_cntry IS INITIAL.
        MESSAGE e008.
*   Enter country
      ENDIF.

      SELECT SINGLE *
        FROM t005
        INTO gs_land
        WHERE land1 = pa_cntry.
      IF sy-dbcnt = 0.
        MESSAGE e038 WITH pa_cntry.
*   Country &1 does not exist.
      ELSEIF gs_land-spras <> pa_lang.
        MESSAGE e037 WITH pa_lang pa_cntry.
*   Language &1 is not spoken in country &2.
      ENDIF.
  ENDCASE.


**********************************************************************
AT SELECTION-SCREEN ON BLOCK number_of_bookings.
  CHECK pa_db IS INITIAL.
  CASE sy-ucomm.
   WHEN 'ONLI' OR 'ADVANCED' OR 'TAB_DATA_SOURCE' OR 'TAB_LANG_COUNTRY'
     OR 'TAB_PRINTER' OR 'TAB_SUNDRIES'.
      IF pa_numb IS INITIAL.
        MESSAGE e009.
*   Enter number of bookings'

      ENDIF.
  ENDCASE.

**********************************************************************
AT SELECTION-SCREEN ON BLOCK preview.
  IF pa_prev = 'X' AND pa_nopdf = 'X'.
    MESSAGE w011.
*   Preview needs PDF. Flag "No PDF" will be ignored.
  ENDIF.

**********************************************************************
AT SELECTION-SCREEN ON BLOCK download_details.
  IF pa_gui IS NOT INITIAL AND old_radio_button = 'PA_GUI'.
    IF pa_path IS INITIAL.
      MESSAGE e010.
*   Enter download path
    ENDIF.

    downl_path = pa_path.
    CALL METHOD cl_gui_frontend_services=>directory_exist
      EXPORTING
        directory = downl_path
      RECEIVING
        result    = file_exists
      EXCEPTIONS
        OTHERS    = 5.

    IF file_exists IS INITIAL.
      MESSAGE e012.
*   Invalid download path
    ENDIF.
  ENDIF.

  CASE 'X'.
    WHEN pa_spool.
      old_radio_button = 'PA_SPOOL'.
    WHEN pa_gui.
      old_radio_button = 'PA_GUI'.
    WHEN pa_mail.
      old_radio_button = 'PA_MAIL'.
  ENDCASE.

AT SELECTION-SCREEN ON pa_image.
* This event will be fired even if the subscreen is hidden ->
* Make sure flag gv_max is set before checking that an entry
* in pa_image is correct.
  CHECK gv_max IS NOT INITIAL.
  IF pa_image IS NOT INITIAL.
    image_upload_filename = pa_image.
    CALL METHOD cl_gui_frontend_services=>file_exist
      EXPORTING
        file   = image_upload_filename
      RECEIVING
        result = file_exists
      EXCEPTIONS
        OTHERS = 5.
    IF file_exists IS INITIAL.
      MESSAGE e013.
*   File for image does not exist
    ENDIF.

* evaluate file type
* FIND ALL OCCURRENCES OF '.' IN image_upload_filename MATCH OFFSET dot.
    PERFORM find_last_substring
                USING
                   image_upload_filename
                   '.'
                CHANGING
                   dot.

    dot = dot + 1.
    gv_mime_type = pa_image+dot.
    TRANSLATE gv_mime_type TO UPPER CASE.
    CASE gv_mime_type.
      WHEN 'BMP' OR 'PNG'.
        gv_mime_type = 'image/bmp'.
      WHEN 'GIF'.
        gv_mime_type = 'image/gif'.
      WHEN 'JPG' OR 'JPEG'.
        gv_mime_type = 'image/jpeg'.
      WHEN 'TIF' OR 'TIFF'.
        gv_mime_type = 'image/tif'.
      WHEN OTHERS.
        MESSAGE e014.
*   Invalid MIME type
    ENDCASE.
  ENDIF.

AT SELECTION-SCREEN ON pa_rfc.
* This event will be fired even if the subscreen is hidden ->
* Make sure flag gv_sundries is set before checking that an entry
* in pa_rfc is correct.
  CHECK gv_sundries IS NOT INITIAL.
  SELECT SINGLE rfcdest
    FROM rfcdes
    INTO pa_rfc
    WHERE rfcdest = pa_rfc AND
          rfctype = 'G'.
  IF sy-dbcnt <> 1.
    MESSAGE e015.
*   Enter valid RFC destination for Adobe document services
  ENDIF.

**********************************************************************
AT SELECTION-SCREEN.
  CASE sy-ucomm.
    WHEN 'ADS'.
      gv_sundries = 'X'.
      SET PARAMETER ID 'ADS' FIELD gv_sundries.             "#EC EXISTS
    WHEN 'NOADS'.
      gv_sundries = ' '.
      SET PARAMETER ID 'ADS' FIELD gv_sundries.             "#EC EXISTS
      IF tabs-activetab = 'TAB_SUNDRIES'.
        tabs-activetab = 'TAB_DATA_SOURCE'.
        tabs-dynnr = '0110'.
      ENDIF.
    WHEN 'MAX'.
      gv_max = 'X'.
    WHEN 'PROC'.
      gv_proc_type = 'X'.
      SET PARAMETER ID 'PROC_TYPE' FIELD gv_proc_type.      "#EC EXISTS
    WHEN 'NOPROC'.
      pa_spool = 'X'.
      gv_proc_type = ' '.
      SET PARAMETER ID 'PROC_TYPE' FIELD gv_proc_type.      "#EC EXISTS
      IF tabs-activetab = 'TAB_PROCESS'.
        tabs-activetab = 'TAB_DATA_SOURCE'.
        tabs-dynnr = '0110'.
      ENDIF.
  ENDCASE.

  CASE sy-dynnr.
    WHEN '0120'.
      SELECT SINGLE language
        FROM fplayoutt
        INTO   gs_values-key
        WHERE name = pa_form AND
              state = 'A' AND
              language = pa_lang.
      IF sy-dbcnt <> 1.
        MESSAGE w036 WITH pa_form pa_lang.
* form &1 is not available in language &2
      ENDIF.


    WHEN 1000.
      IF sy-ucomm = 'ADVANCED'.
        IF gv_advanced = 'X'.
          CLEAR gv_advanced.
          push01 = 'Advanced functions'(adv).
        ELSE.
          gv_advanced = 'X'.
          push01 = 'No advanced functions'(noa).
        ENDIF.
        SET PARAMETER ID 'ADVANCED_ID' FIELD gv_advanced.   "#EC EXISTS
      ENDIF.

      SET PARAMETER ID 'ACTIVE_TAB' FIELD tabs-activetab.   "#EC EXISTS
      SET PARAMETER ID 'ACTIVE_DYNNR' FIELD tabs-dynnr.     "#EC EXISTS

    WHEN OTHERS.
      IF sy-ucomm = 'TOGGLE_CUSTOMERS'.
        ra_cus2[] = so_cusid[].
        so_cusid[] = ra_cus1[].
        ra_cus1[] = ra_cus2[].
        ra_cus2[] = so_cusid[].
      ENDIF.

  ENDCASE.
  SET PARAMETER ID 'PREVIEW' FIELD pa_prev.                 "#EC EXISTS
  SET PARAMETER ID 'SUPPR_PRT_DLG' FIELD pa_nodlg.          "#EC EXISTS
  SET PARAMETER ID 'SELECT_BOOKINGS' FIELD pa_db.           "#EC EXISTS
  SET PARAMETER ID 'SENDER_COUNTRY' FIELD pa_send.          "#EC EXISTS
  SET PARAMETER ID 'LANGUAGE' FIELD pa_lang.                "#EC EXISTS



**********************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_path.
  gv_window_text = 'Select download directory'(dow).
  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title         = gv_window_text
    CHANGING
      selected_folder      = downl_path
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  pa_path = downl_path.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_image.
  DATA:
    gt_files TYPE filetable,
    gv_rc TYPE i,
    window_title TYPE string.

  image_upload_filename = pa_image.

  CONCATENATE
    'Image Files|*.BMP;*.GIF;*.PNG;*.JPG;*.JPEG;*.TIF|'     "#EC NOTEXT
    'All files (*.*)|*.*|'                                  "#EC NOTEXT
    INTO gv_file_filter.

  window_title = 'Choose graphic file'(cho)..
  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title      = window_title
      default_filename  = image_upload_filename
      initial_directory = 'C:\'
      multiselection    = space
      file_filter       = gv_file_filter
    CHANGING
      file_table        = gt_files
      rc                = gv_rc
    EXCEPTIONS
      OTHERS            = 5.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  READ TABLE gt_files INDEX gv_rc INTO pa_image.
