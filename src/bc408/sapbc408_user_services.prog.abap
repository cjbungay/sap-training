*----------------------------------------------------------------------*
*  This report could be run prior to BC408 classes.
*  It must be run after
*    - the transport landscape has been set up,
*    - the users have been created, and
*    - ONE common change request has been created.
*  (It is best to run transaction BC_TOOLS_USER to achieve this.)
*
*  This report allows the trainer to do the following:
*  1. Create a package for every course participant.
*  2. Set a default printer for the participants.
*  3. Set the flag "Print immediately" to off.
*  4. Set ABAP workbench settings, like Pretty Printer
*
*  The following entries are mandatory on the selection screen:
*    - the name of the course
*    - the numbers of the groups (usually starting with 00 for the
*      instructor),
*    - the workbench request for the course
*    - a transport layer that matches the workbench request.
*
*  This report comes with no warranty whatsoever!
*
*----------------------------------------------------------------------*
REPORT  sapbc408_user_services MESSAGE-ID bc470.
TYPE-POOLS: trdev.

TABLES:
  usr01, rseumod, e070, sscrfields.

DATA:
  ls_devclass          LIKE trdevclass,
  ls_fields_for_change TYPE trdev_fields_for_change,
  devc_text            TYPE trdevclass-ctext,
  request              TYPE trkorr,                         "#EC NEEDED
  devclass             TYPE trdevclass-devclass,
  changed,
  diff                 TYPE integer1,
  idx(2)               TYPE n,
  result_text(80),
  it_usr01             TYPE TABLE OF usr01,
  it_rseumod           TYPE TABLE OF rseumod,
  offset               TYPE i.


*----------------------------------------------------------------------*
* SELECTION_SCREEN
*----------------------------------------------------------------------*
PARAMETERS:
  pa_cours TYPE bctools_log-course DEFAULT 'BC408' OBLIGATORY.
SELECT-OPTIONS:
  so_count FOR diff NO-EXTENSION DEFAULT 0 TO 18.
SELECT-OPTIONS:
  so_user  FOR usr01-bname DEFAULT 'BC408-00' TO 'BC408-18'
  NO-EXTENSION MODIF ID inf.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK tms.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(25) text-s01.
SELECTION-SCREEN POSITION pos_low.
PARAMETERS:
    pa_trkor TYPE trkorr VISIBLE LENGTH 10 MEMORY ID kol OBLIGATORY.
SELECTION-SCREEN POSITION pos_high.
PARAMETERS:
    pa_ktxt TYPE as4text VISIBLE LENGTH 50 MODIF ID inf.
SELECTION-SCREEN END OF LINE.
PARAMETERS: pa_layer TYPE scompkdtln-pdevclass OBLIGATORY.
SELECTION-SCREEN END OF BLOCK tms.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK action WITH FRAME.

*----------------------------------------------------------------------*
* 1st part: create package for every course participant
PARAMETERS:
  pa_chk1 AS CHECKBOX DEFAULT 'X' USER-COMMAND devc.
SELECT-OPTIONS:
  so_devc  FOR devclass DEFAULT 'ZBC408_00' TO 'ZBC408_18'
    NO-EXTENSION MODIF ID inf.

SELECTION-SCREEN SKIP.

* 2nd part: printer settings for users
SELECTION-SCREEN BEGIN OF BLOCK prnt WITH FRAME TITLE text-s03.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS:
  pa_chk2 AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN COMMENT 4(20) text-s04.
SELECTION-SCREEN POSITION pos_low.
PARAMETERS:
  pa_prnt TYPE usr01-spld VISIBLE LENGTH 4.
SELECTION-SCREEN END OF LINE.
PARAMETERS:
  pa_immed DEFAULT 'X' AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK prnt.

* 4th part: ABAP workbench settings
SELECTION-SCREEN SKIP.
PARAMETERS: pa_wb AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK action.


*----------------------------------------------------------------------*
* INITIALIZATION.
*----------------------------------------------------------------------*
INITIALIZATION.
* find out instructor's standard printer
  SELECT SINGLE spld
    FROM usr01 INTO pa_prnt.
  IF pa_prnt IS INITIAL.
    pa_prnt = 'P280'.
  ENDIF.

  DATA: std_target_system TYPE tcerele-consys.

* Find out the standard transport layer and target system
  CALL FUNCTION 'TR_GET_TRANSPORT_TARGET'
    EXPORTING
      iv_use_default = 'X'
    IMPORTING
      ev_target      = std_target_system
      ev_layer       = pa_layer.

  IF pa_layer IS INITIAL.
* set the transport layer on the screen.
    CLEAR std_target_system.
    CONCATENATE 'Z' sy-sysid INTO pa_layer.
    SELECT SINGLE translayer
      FROM vtcetral
      INTO pa_layer
      WHERE translayer = pa_layer.
    IF sy-subrc = 0.

      CALL FUNCTION 'TR_GET_TRANSPORT_TARGET'
        EXPORTING
          iv_transport_layer = pa_layer
        IMPORTING
          ev_target          = std_target_system.
    ELSE.
      CLEAR: pa_layer, std_target_system.
    ENDIF.
  ENDIF.

* Check whether values were filled into SAP memory
  GET PARAMETER ID:
    'KOL' FIELD pa_trkor.

* Find out a suitable workbench request
  CHECK pa_trkor IS INITIAL.
  CONCATENATE sy-sysid '%' INTO pa_trkor.
  SELECT SINGLE *
    FROM e070
    WHERE trkorr LIKE pa_trkor AND
          as4user = sy-uname AND
          trfunction = 'K' AND " request
          trstatus = 'D' AND   " can be changed
          korrdev = 'SYST' AND    " workbench request
          tarsystem = std_target_system.
  pa_trkor = e070-trkorr.


*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN OUTPUT                                          *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'INF'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

  SELECT SINGLE as4text
    FROM e07t
    INTO pa_ktxt
    WHERE trkorr = pa_trkor AND
            langu = sy-langu.

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_trkor
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_trkor.
  CALL FUNCTION 'TR_F4_REQUESTS'
    EXPORTING
      iv_trfunctions      = 'K'
      iv_trstatus         = 'D'  " not release yet
    IMPORTING
      ev_selected_request = pa_trkor.


*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN ON BLOCK tms
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON BLOCK tms.
* Check whether transport layer exists
  SELECT SINGLE translayer
    FROM vtcetral
    INTO pa_layer
    WHERE translayer = pa_layer.
  IF sy-subrc <> 0.
    MESSAGE e019 WITH pa_layer. " Layer does not exist
  ENDIF.

* Check whether a suitable request has been selected
  SELECT SINGLE *
    FROM e070
    WHERE e070~trkorr = pa_trkor.
  IF sy-dbcnt = 0.                 " request does not exist
    MESSAGE e021 WITH pa_trkor.
  ELSEIF e070-trstatus <> 'D'.     " request cannot be changed
    MESSAGE e022 WITH pa_trkor.
  ELSEIF e070-korrdev <> 'SYST'.   " request is not a workbench request
    MESSAGE e023 WITH pa_trkor.
  ELSEIF e070-tarsystem <> std_target_system.
    MESSAGE e018.                  "target system of request does not
    " match the target system from the selection-screen
  ELSEIF e070-as4user <> sy-uname. " user is not owner of request
    SELECT SINGLE trkorr
      FROM e070
      INTO request
      WHERE strkorr = pa_trkor AND
            as4user = sy-uname.
    IF sy-subrc <> 0.              " user has no task in request
      MESSAGE e020 WITH pa_trkor.
    ENDIF.
  ENDIF.

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN ON so_count
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON so_count.
  CHECK NOT so_count-high IS INITIAL AND so_count-high > 99.
  MESSAGE e024.



*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
  REFRESH so_user.
  PERFORM update_selscreen
    USING so_user-sign so_user-option so_user-low so_user-high
          '-' space.
  APPEND so_user.

  REFRESH so_devc.
  PERFORM update_selscreen
    USING so_devc-sign so_devc-option so_devc-low so_devc-high
          '_' 'X'.
  APPEND so_devc.

  IF pa_chk1 IS NOT INITIAL.
    SELECT devclass
      FROM tdevc
      INTO devclass
      WHERE devclass IN so_devc.
      MESSAGE e017 WITH devclass. " Package exists already
    ENDSELECT.
  ENDIF.

  CHECK sscrfields-ucomm = 'ONLI'.
  IF pa_chk1 IS INITIAL AND pa_chk2 IS INITIAL AND pa_immed IS INITIAL.
    MESSAGE e025. " no action selected
  ENDIF.


*----------------------------------------------------------------------*
*START-OF-SELECTION.
*----------------------------------------------------------------------*
START-OF-SELECTION.
  SELECT *
    FROM usr01
    INTO TABLE it_usr01
    WHERE bname IN so_user.
  IF sy-dbcnt = 0.
    FORMAT COLOR COL_NEGATIVE.
    WRITE: / ' no users found'.
  ENDIF.

  SELECT *
    FROM rseumod
    INTO TABLE it_rseumod
    FOR ALL ENTRIES IN it_usr01
    WHERE uname = it_usr01-bname.

*----------------------------------------------------------------------*
  LOOP AT it_usr01 INTO usr01.
    READ TABLE it_rseumod
      INTO rseumod
      WITH KEY uname = usr01-bname.
    IF sy-subrc <> 0.
      CLEAR rseumod.
      rseumod-uname = usr01-bname.
    ENDIF.

    SKIP.

* 1st part: create package for course particpants
    IF NOT pa_chk1 IS INITIAL.

      CLEAR devclass.
      offset = strlen( usr01-bname ).
      offset = offset - 2.
      CONCATENATE 'Z' pa_cours '_' usr01-bname+offset INTO devclass.
      CONCATENATE pa_cours text-i06 usr01-bname+offset INTO devc_text
        SEPARATED BY space.
      CLEAR changed.

      ls_devclass-devclass  = devclass.

      ls_devclass-pdevclass = pa_layer.
      ls_fields_for_change-pdevclass = 'X'.

      ls_devclass-ctext              = devc_text.
      ls_fields_for_change-ctext     = 'X'.

      ls_devclass-as4user            = usr01-bname.
      ls_fields_for_change-as4user   = 'X'.

      ls_devclass-dlvunit            = 'HOME'.
      ls_fields_for_change-dlvunit   = 'X'.

      CALL FUNCTION 'TRINT_MODIFY_DEVCLASS'
           EXPORTING
                iv_action             = 'CREA'
                iv_dialog             = space
                is_devclass           = ls_devclass
                is_fields_for_change  = ls_fields_for_change
                iv_request            = pa_trkor
           IMPORTING
*            es_devclass           = es_devclass
                ev_something_changed  = changed
                ev_request            = request
           EXCEPTIONS
                no_authorization      = 1
                invalid_devclass      = 2
                invalid_action        = 3
                enqueue_failed        = 4
                db_access_error       = 5
                system_not_configured = 6
                OTHERS                = 7.

      CASE sy-subrc.
        WHEN 0.
          IF changed = 'X'.
            CLEAR result_text.
            CONCATENATE devclass text-i02
              " 'Package created for user'
              INTO result_text.
            CONCATENATE result_text usr01-bname
              INTO result_text SEPARATED BY space.
            WRITE: / result_text.
            rseumod-devclass = devclass.
          ENDIF.
        WHEN 3.
          CLEAR result_text.
          CONCATENATE devclass text-e02
            " 'Package already exists.'
            INTO result_text.
          WRITE: / result_text COLOR COL_NEGATIVE.
        WHEN OTHERS.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDCASE.
    ENDIF.



*----------------------------------------------------------------------*
* 2nd part: set default printer for course participants
    IF NOT pa_chk2 IS INITIAL.
      usr01-spld = pa_prnt.

      result_text = text-i03.
      " 'Setting default printer'
      CONCATENATE result_text usr01-bname INTO result_text
        SEPARATED BY space.
      WRITE: / result_text.

    ENDIF.

*----------------------------------------------------------------------*
* 3rd part: disallow immediate printing for course participants
    IF NOT pa_immed IS INITIAL. " disallow immediate printing
      usr01-spdb = 'H'.

      result_text = text-i04.
      " 'Immediate printout disabled'
      CONCATENATE result_text usr01-bname INTO result_text
        SEPARATED BY space.
      WRITE: / result_text.
    ENDIF.

    MODIFY usr01.

*----------------------------------------------------------------------*
* 4th part: ABAP workbench settings
    rseumod-tasknr    = pa_trkor. "request
    rseumod-style     = 'X'.
    rseumod-lowercase = 'G'. "capitalize keywords
    rseumod-motif     = 'X'. "graphical screen painter
    rseumod-devclass  = devclass.
    rseumod-pcmode    = 'X'.
    MODIFY rseumod.
      result_text = text-i05.
      " 'Workbench settings saved for user
      CONCATENATE result_text usr01-bname INTO result_text
        SEPARATED BY space.
      WRITE: / result_text.

  ENDLOOP.

*&--------------------------------------------------------------------*
FORM update_low USING l_low p_separator.
*  REFRESH sel_opt.
  WRITE: so_count-low TO idx.
  IF so_count-low < 10.
    SHIFT idx RIGHT.
    TRANSLATE idx USING ' 0'.
  ENDIF.
  CONCATENATE pa_cours p_separator idx INTO l_low.
ENDFORM.                    "update_low
*&--------------------------------------------------------------------*

FORM update_high USING p_high p_separator.
  WRITE: so_count-high TO idx.
  IF so_count-high IS INITIAL.
    CLEAR p_high.
  ELSE.
    IF so_count-high < 10.
      SHIFT idx RIGHT.
      TRANSLATE idx USING ' 0'.
    ENDIF.
    CONCATENATE pa_cours p_separator idx INTO p_high.
  ENDIF.
ENDFORM.                    "update_high


*&--------------------------------------------------------------------*
FORM update_selscreen
  USING p_sign LIKE so_devc-sign
        p_option LIKE so_devc-option
        p_low
        p_high
        p_separator
        p_z.

  p_sign = 'I'.
  PERFORM update_low USING p_low p_separator.
  IF p_z = 'X'. CONCATENATE 'Z' p_low INTO p_low. ENDIF.
  PERFORM update_high USING p_high p_separator.
  IF p_high IS INITIAL.
    p_option = 'EQ'.
  ELSE.
    p_option = 'BT'.
    IF p_z = 'X'. CONCATENATE 'Z' p_high INTO p_high. ENDIF.
  ENDIF.
ENDFORM.                    "update_selscreen
