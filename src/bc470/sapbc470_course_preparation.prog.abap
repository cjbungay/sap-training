*&---------------------------------------------------------------------*
*& Report  SAPBC470_COURSE_PREPARATION
*
* This report should be run prior to BC470 classes.
* It does the following:
* 1. It adds FLy & Smile as a new travel agency to STRAVELAG and
*    sets field AGENCYNUM for all entries of table SBOOK to the number
*    belonging to Fly & Smile. (This might take a while!).
* 2. It deletes old dunning data from table MHNK.
* 3. It repairs incomplete addresses from table SCUSTOM (like US
*    addresses without State).
* 4. It makes sure the two SAPscript texts needed for the course
*    are available in the training client.
*&---------------------------------------------------------------------*

REPORT  sapbc470_course_preparation.

DATA:
  wa_agency  TYPE stravelag,
  help       TYPE string,
  protocol   TYPE TABLE OF abaplist,
  tabname    TYPE dd02l-tabname.



PARAMETERS:
  p_trav  AS CHECKBOX DEFAULT 'X',
  p_dunn  AS CHECKBOX DEFAULT 'X',
  p_scust AS CHECKBOX DEFAULT 'X',
  p_text  AS CHECKBOX DEFAULT 'X'.

* 1: travel agency Fly & Smile
* First part: STRAVELAG
* (Old versions of the flight data generator did not create a Fly &
* Smile travel agency.)
IF p_trav = 'X'.
  SELECT SINGLE *                                           "#EC *
    FROM stravelag
    INTO wa_agency
   WHERE name = 'Fly & Smile'.                              "#EC NOTEXT

  IF sy-subrc NE 0.
    SELECT MAX( agencynum )                             "#EC CI_NOWHERE
      FROM stravelag
      INTO wa_agency-agencynum.
    wa_agency-agencynum = wa_agency-agencynum + 1.
  ENDIF.

  wa_agency-name       = 'Fly & Smile'.                     "#EC NOTEXT
  wa_agency-street     = 'Zeppelinstr. 17'.                 "#EC NOTEXT
  wa_agency-postbox    = '16 05 29'.
  wa_agency-postcode   = '60318'.
  wa_agency-city       = 'Frankfurt'.                       "#EC NOTEXT
  wa_agency-country    = 'DE'.
*wa_agency-region     = '06'.
  wa_agency-telephone  = '069-99-0'.
  wa_agency-url        = 'http://www.fly-and-smile.sap'.
  wa_agency-langu      = 'D'.

  MODIFY stravelag FROM wa_agency.
  IF sy-subrc = 0.
    WRITE: / 'New entry for Fly & Smile added to STRAVELAG:',"#EC NOTEXT
     wa_agency-agencynum.
  ELSE.
    WRITE: /'Updating STRAVELAG failed'.                    "#EC NOTEXT
    EXIT.
  ENDIF.



* Second part: SBOOK
  UPDATE sbook                                          "#EC CI_NOWHERE
    SET agencynum = wa_agency-agencynum.

  IF sy-subrc = 0.
    MOVE sy-dbcnt TO help.
    WRITE: / 'Field AGENCYNUM for all', help,               "#EC NOTEXT
      'entries of table SBOOK was set to',                  "#EC NOTEXT
       wa_agency-agencynum.
  ELSE.
    WRITE: / 'Updating SBOOK failed'.                       "#EC NOTEXT
  ENDIF.
ENDIF.



* 2: Dunning
* check whether the dunning table exists
IF p_dunn = 'X'.
  SELECT SINGLE tabname                                     "#EC *
    FROM dd02l
    INTO tabname
    WHERE tabname = 'MHNK' AND
          as4local = 'A'.
  IF sy-dbcnt = 1.
    DELETE FROM (tabname)
      WHERE applk EQ space.
    IF sy-subrc = 0.
      MOVE sy-dbcnt TO help.
      WRITE: /, / help, 'entries deleted from table MHNK.'. "#EC NOTEXT
    ENDIF.
  ELSE.
    WRITE: / 'Dunning table MHNK does not exist'.           "#EC NOTEXT
  ENDIF.
ENDIF.



* 3: Customer addresses
* make sure every US address has at least a dummy region
IF p_scust = 'X'.
  UPDATE scustom                                        "#EC CI_NOFIELD
    SET region = 'XX'
    WHERE country EQ 'US' AND region NOT LIKE '__'.
  IF sy-subrc = 0.
    MOVE sy-dbcnt TO help.
    WRITE: /, / 'Region XX entered', help,                  "#EC NOTEXT
    'times into table SCUSTOM.'.                            "#EC NOTEXT
  ENDIF.

* convert wrong country entries EN into GB
*(Old versions of the flight data generator created some false entries.)
  UPDATE scustom                                        "#EC CI_NOFIELD
    SET country = 'GB'
    WHERE country = 'EN'.
  IF sy-subrc = 0.
    MOVE sy-dbcnt TO help.
    WRITE: / 'Country EN in table SCUSTOM changed to GB',   "#EC NOTEXT
      help, 'times.'.                                       "#EC NOTEXT
  ENDIF.


* make sure German, French, Swiss, Austrian, and British addresses
* don't have a region
  UPDATE scustom                                        "#EC CI_NOFIELD
    SET region = space
    WHERE country EQ 'DE' OR
          country EQ 'AT' OR
          country EQ 'CH' OR
          country EQ 'FR' OR
          country EQ 'GB'.
  IF sy-subrc = 0.
    MOVE sy-dbcnt TO help.
    WRITE: / 'Region deleted', help,                        "#EC NOTEXT
             'times from table SCUSTOM.'.                   "#EC NOTEXT
  ENDIF.

* make sure every address has at least a dummy post code
  UPDATE scustom                                        "#EC CI_NOFIELD
   SET postcode = '12345'                                   "#EC NOTEXT
    WHERE postcode = space.
  IF sy-subrc = 0.
    MOVE sy-dbcnt TO help.
    WRITE: / 'Postcode 12345 entered', help,                "#EC NOTEXT
      'times into table SCUSTOM.'.                          "#EC NOTEXT
  ENDIF.
ENDIF.



* 4.
* Make sure the two SAPscript texts needed for BC470 are available in
* the training client. They are always available in the master client
* (800).
* This is a precaution for the case that new clients are created that
* do not have them.
IF p_text = 'X'.
  IF sy-mandt NE '800'.
    SKIP 1.

    PERFORM copy_sapscript_text
      USING 'BC470_FLY_AND_SMILE' 'TEXT' 'ADRS'.

    PERFORM copy_sapscript_text
      USING 'SF_ADRS_SENDER' 'TEXT' 'ADRS'.

  ENDIF. "  IF sy-mandt NE '800'.
ENDIF.


*&--------------------------------------------------------------------*
FORM copy_sapscript_text
  USING p_text TYPE thead-tdname
        p_object TYPE thead-tdobject
        p_textid TYPE thead-tdid.

  SUBMIT rstxtcpy
*    VIA SELECTION-SCREEN
    EXPORTING LIST TO MEMORY
    WITH quelname    = p_text
    WITH objekt      = p_object
    WITH textid      = p_textid
    WITH sprache     = '*'
    WITH quelmand    = '800'
    WITH zielname    = space
    WITH protokol    = 'X'
    WITH dial        = space
    WITH overwrit    = space
    WITH comit100    = space
    WITH packages    = space
    AND RETURN.

* Read protocol of copy process from memory
  CALL FUNCTION 'LIST_FROM_MEMORY'
    TABLES
      listobject = protocol
    EXCEPTIONS
      not_found  = 1
      OTHERS     = 2.
  IF sy-subrc <> 0.
    WRITE: 'No protocol for copying the standard texts available'.
                                                            "#EC NOTEXT
  ENDIF.

* Display protocol
  CALL FUNCTION 'WRITE_LIST'
    TABLES
      listobject = protocol
    EXCEPTIONS
      empty_list = 1
      OTHERS     = 2.
  IF sy-subrc <> 0.
    WRITE: / 'No protocol for copying the standard texts available'.
                                                            "#EC NOTEXT
  ENDIF.
ENDFORM.                    "copy_sapscript_text
