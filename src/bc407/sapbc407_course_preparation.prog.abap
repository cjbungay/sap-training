*&---------------------------------------------------------------------*
*  Report  SAPBC407_COURSE_PREPARATION                                 *
*                                                                      *
*----------------------------------------------------------------------*
*
*  This report should be run prior to BC407 classes.
*  It must be run after
*    - the transport landscape has been set up,
*    - the users have been created, and
*    - ONE common change request has been created.
*  (It is best to run transaction BC_TOOLS_USER to achieve this.)
*
*  This report allows the trainer to do the following:
*  1. Create a pakage for every course participant.
*  2. Copy the template program required for the unit "ABAP statements".
*  3. Enter the name of the ITS into table rseumod so that
*     users can release InfoSet Queries for Web reporting more easily.
*     NOTE: the automatically created name for the ITS server is a
*     suggestion only and can vary between different training systems!
*
*
*  The following entries are mandatory on the selection screen:
*    - the name of the course
*    - the numbers of the groups (usually starting with 00 for the
*      instructor),
*    - the workbench request for the course,
*    - the tarnsport layer.
*
*  This report comes with no warranty whatsoever!
*
*----------------------------------------------------------------------*

REPORT  sapbc407_course_preparation MESSAGE-ID bc407.
TYPE-POOLS: trdev.
CONSTANTS: result TYPE i VALUE 8.
TABLES:
  usr01, e070, tadir, tdevc, tcerele, tcevers, rseumod,     "#EC NEEDED
  sscrfields.
DATA:
  ls_devclass          LIKE trdevclass,
  ls_fields_for_change TYPE trdev_fields_for_change,
  devc_text          TYPE trdevclass-ctext,
  request            TYPE e070-trkorr,                      "#EC NEEDED
*  person_responsible TYPE trdevclass-as4user,
  devclass           TYPE trdevclass-devclass,
  it_usr01           TYPE TABLE OF usr01,
  changed,
  diff               TYPE bc407_suffix,
  idx(2)             TYPE n,
  prog               TYPE rseux-cp_value,
  result_text(80),
  offset             TYPE i,
  std_target_system TYPE tcerele-consys.


*----------------------------------------------------------------------*
* SELECTION_SCREEN
*----------------------------------------------------------------------*
SELECTION-SCREEN COMMENT 1(80) text-co1 MODIF ID com.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN COMMENT 1(80) text-co2 MODIF ID com.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN COMMENT 1(80) text-co3 MODIF ID com.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN COMMENT 1(80) text-co4 MODIF ID com.
SELECTION-SCREEN SKIP.
PARAMETERS:
  pa_cours TYPE bctools_log-course DEFAULT 'BC407' OBLIGATORY.
SELECT-OPTIONS:
  so_count FOR diff NO-EXTENSION DEFAULT 0 TO 18,
  so_user  FOR usr01-bname DEFAULT 'BC407-00' TO 'BC407-18'
  NO-EXTENSION MODIF ID inf.


SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK tms.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(25) text-s01 MODIF ID ch2.
SELECTION-SCREEN POSITION pos_low.
PARAMETERS:
    pa_trkor TYPE bc407_e070-trkorr VISIBLE LENGTH 10 MEMORY ID kol
      OBLIGATORY.
SELECTION-SCREEN POSITION pos_high.
PARAMETERS:
    pa_ktxt TYPE bc407_e070-as4text VISIBLE LENGTH 50 MODIF ID inf.
SELECTION-SCREEN END OF LINE.
PARAMETERS: pa_layer TYPE scompkdtln-pdevclass OBLIGATORY.
SELECTION-SCREEN END OF BLOCK tms.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK action WITH FRAME.

* 1st part: create development class for every course participant
SELECTION-SCREEN BEGIN OF BLOCK devclass WITH FRAME TITLE text-s02.
PARAMETERS:
  pa_chk1 AS CHECKBOX USER-COMMAND check1 DEFAULT 'X'.
SELECT-OPTIONS:
  so_devc  FOR devclass DEFAULT 'ZBC407_00' TO 'ZBC407_18'
    NO-EXTENSION MODIF ID inf.

SELECTION-SCREEN END OF BLOCK devclass.

* 2nd part: copy program template for exercise
SELECTION-SCREEN BEGIN OF BLOCK prog WITH FRAME TITLE text-s03.
PARAMETERS
  pa_chk2 AS CHECKBOX USER-COMMAND check2 DEFAULT 'X'.
PARAMETERS:
  pa_prog TYPE rseux-cp_value DEFAULT 'SAPBC407_DATT_PROGRAM'
    MODIF ID ch2.
PARAMETERS:
  pa_tar  TYPE rseux-cp_value DEFAULT 'ZBC407_PROGRAM'
    MODIF ID ch2.
SELECTION-SCREEN END OF BLOCK prog.

* 3rd part: suggest ITS-server for releasing Queries for web reporting
SELECTION-SCREEN BEGIN OF BLOCK its WITH FRAME TITLE text-s05.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS:
  pa_chk3 AS CHECKBOX USER-COMMAND check3 DEFAULT 'X'.
SELECTION-SCREEN COMMENT 3(25) text-s06.
SELECTION-SCREEN POSITION pos_low.
PARAMETERS: pa_its TYPE rseumod-its_name MODIF ID ch3.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK its.
SELECTION-SCREEN END OF BLOCK action.

*----------------------------------------------------------------------*
* INITIALIZATION.
*----------------------------------------------------------------------*
INITIALIZATION.
  SET PF-STATUS 'SEL'.
  CONCATENATE 'IG' sy-sysid '.WDF.SAP.CORP:1080' INTO pa_its.

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
    IF screen-group1 = 'INF' OR screen-group1 = 'COM'.
      screen-input = 0.
      IF screen-group1 = 'COM'.
        screen-intensified = 1.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
    IF screen-group1 = 'CH2' AND pa_chk2 IS INITIAL OR
       screen-group1 = 'CH3' AND pa_chk3 IS INITIAL.
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
*  AT SELECTION-SCREEN ON p_trkorr
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON BLOCK tms.
* Check whether transport layer exists
  SELECT SINGLE translayer
    FROM vtcetral
    INTO pa_layer
    WHERE translayer = pa_layer.
  IF sy-subrc <> 0.
    MESSAGE e006 WITH pa_layer. " Layer does not exist
  ENDIF.

  SELECT SINGLE *
    FROM e070
    WHERE e070~trkorr = pa_trkor.
  IF sy-dbcnt = 0.                 " reuest does not exist
    MESSAGE e001 WITH pa_trkor.
  ELSEIF e070-trstatus <> 'D'.     " request cannot be changed
    MESSAGE e002 WITH pa_trkor.
  ELSEIF e070-korrdev <> 'SYST'.   " request is not a workbench request
    MESSAGE e003 WITH pa_trkor.
  ELSEIF e070-tarsystem <> std_target_system.
    MESSAGE e014 WITH pa_trkor pa_layer.
    "target system of request does not
    " match the target system from the selection-screen
  ELSEIF e070-as4user <> sy-uname. " user is not owner of request
    SELECT SINGLE trkorr
      FROM e070
      INTO request
      WHERE strkorr = pa_trkor AND
            as4user = sy-uname.
    IF sy-subrc <> 0.              " user has no task in request
      MESSAGE e000 WITH pa_trkor.
    ENDIF.
  ENDIF.

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN ON so_count
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON so_count.
  CHECK NOT so_count-high IS INITIAL.
  diff = so_count-high - so_count-low + 1.
  CHECK diff > 99.
  MESSAGE e004.


*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN ON BLOCK prog
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON BLOCK prog.
  CHECK NOT pa_chk2 IS INITIAL AND sscrfields-ucomm <> 'CHECK2'.
  SELECT SINGLE *
    FROM tadir
    WHERE pgmid    = 'R3TR' AND
          object   = 'PROG' AND
          obj_name = pa_prog.
  IF sy-dbcnt <> 1.
    MESSAGE e005 WITH pa_prog.
  ENDIF.

  IF pa_tar(1) <> 'Z' AND pa_tar(1) <> 'Y'.
    MESSAGE e008.
  ENDIF.

  CALL FUNCTION 'RS_PROGRAM_CHECK_NAME'
    EXPORTING
      progname = pa_tar
    EXCEPTIONS
      OTHERS   = 14.

  IF sy-subrc <> 0.
    MESSAGE e009.
  ENDIF.

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
      MESSAGE e015 WITH devclass. " Package exists already
    ENDSELECT.
  ENDIF.

  CHECK sscrfields-ucomm = 'ONLI'.
  IF pa_chk1 IS INITIAL AND pa_chk2 IS INITIAL AND pa_chk3 IS INITIAL.
    MESSAGE e007.
  ENDIF.


*----------------------------------------------------------------------*
*START-OF-SELECTION.
*----------------------------------------------------------------------*
START-OF-SELECTION.
  SET PF-STATUS space.

  SELECT *
    FROM usr01
    INTO TABLE it_usr01
    WHERE bname IN so_user.

  IF sy-dbcnt = 0.
    FORMAT COLOR COL_NEGATIVE.
    WRITE: / ' no users found'.

  ELSE.

    LOOP AT it_usr01 INTO usr01.
      SELECT SINGLE *
        FROM rseumod
        WHERE uname IN so_user.

      WRITE: / usr01-bname.


      CLEAR devclass.
      offset = strlen( usr01-bname ).
      offset = offset - 2.
      CONCATENATE 'Z' pa_cours '_' usr01-bname+offset INTO devclass.
      CONCATENATE pa_cours text-i06 usr01-bname+offset INTO devc_text
        SEPARATED BY space.

* 1st part: packages for course participants
      IF NOT pa_chk1 IS INITIAL.

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

        CONCATENATE text-pac devclass
          INTO result_text SEPARATED BY space.
        CONCATENATE result_text ':' INTO result_text.
        CASE sy-subrc.
          WHEN 0.
            IF changed = 'X'.
              CONCATENATE result_text text-cre
                INTO result_text SEPARATED BY space.
              rseumod-devclass = devclass.
            ENDIF.
          WHEN OTHERS.
            CONCATENATE result_text text-crf
              INTO result_text SEPARATED BY space.
        ENDCASE.
        WRITE: AT /result result_text.
      ENDIF.

*----------------------------------------------------------------------*
* 2nd part: copy template program
      IF NOT pa_chk2 IS INITIAL.
        CLEAR prog.
        CONCATENATE pa_tar(37) '_' usr01-bname+offset INTO prog.

        CONCATENATE text-prg prog
          INTO result_text SEPARATED BY space.
        CONCATENATE result_text ':' INTO result_text.

* Make sure the target program does not exist already
        SELECT SINGLE *
          FROM tadir
          WHERE pgmid    = 'R3TR' AND
                object   = 'PROG' AND
                obj_name = prog.
        IF sy-dbcnt = 1.
          CONCATENATE result_text text-exi
            " 'Program exists already.'
            INTO result_text SEPARATED BY space.
          WRITE: AT /result result_text COLOR COL_NEGATIVE.
        ELSE.

* check package exists and has the same target system as
* the workbench request.

          SELECT SINGLE *
            FROM tdevc
            WHERE devclass = devclass.
          IF sy-dbcnt <> 1.
            CONCATENATE result_text text-e03
              " 'No appropriate package exists.'
              INTO result_text SEPARATED BY space.
            WRITE: AT /result result_text COLOR COL_NEGATIVE.

          ELSE.
* find out which TMS version is active
            SELECT SINGLE *
              FROM tcevers
              WHERE active = 'A'.

* find out the target system of the transport layer
* of the package
            SELECT SINGLE *
            FROM tcerele WHERE
              translayer = tdevc-pdevclass AND
              version = tcevers-version.
            IF tcerele-consys <> e070-tarsystem.
              CONCATENATE result_text text-e04
                " 'Different consolidation systems'
                INTO result_text SEPARATED BY space.
              WRITE: AT /result result_text COLOR COL_NEGATIVE.

            ELSE.
* copy program
              CALL FUNCTION 'RS_COPY_PROGRAM'
                EXPORTING
                 corrnumber                = pa_trkor
                 devclass                  = devclass
                 program                   = prog
                 source_program            = pa_prog
                 suppress_popup            = 'X'
                 with_cua                  = 'X'
*             with_documentation        = ' '
                 with_dynpro               = 'X'
*        WITH_INCLUDES             = ' '
                 with_textpool             = 'X'
               IMPORTING
                 devclass                  = devclass
                 program                   = prog
               EXCEPTIONS
                 enqueue_lock              = 1
                 object_not_found          = 2
                 permission_failure        = 3
                 reject_copy               = 4
                 OTHERS                    = 5
                        .
              CASE sy-subrc.
                WHEN 0.
                  CONCATENATE result_text text-cre
                    INTO result_text SEPARATED BY space.
                  WRITE: AT /result result_text.
                WHEN OTHERS.
                  CONCATENATE result_text text-crf INTO result_text.
                  " 'could not be created.'
                  WRITE: AT /result result_text COLOR COL_NEGATIVE.
              ENDCASE.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

* 3rd part: enter a suggestion for the ITS server into table rseumod
      IF NOT pa_chk3 IS INITIAL.
        rseumod-its_name = pa_its.
        MODIFY rseumod.

        IF sy-dbcnt = 1.
          CONCATENATE text-its pa_its
            INTO result_text SEPARATED BY space.
          WRITE: AT /result result_text.
        ELSE.
          result_text = text-itn.
          " 'No ITS suggestion possible'
          WRITE: AT /result result_text COLOR COL_NEGATIVE.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

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
