*&---------------------------------------------------------------------*
*& Report  SAPBC405_SSCD_VARIANTS                                      *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   Defining two selection-screens: screen 1000 and screen 1100       *
*&    - default values  (INITIALIZATION)                               *
*&    - check selection criteria (AT SELECTION-SCREEN)                 *
*&   One variant for both selection-screens                            *
*&---------------------------------------------------------------------*

INCLUDE BC405_SSCD_VARIANTSTOP.


NODES: spfli, sflight, sbook.

* Additional parameter on the selection-screen of F1S
SELECTION-SCREEN BEGIN OF BLOCK zusatz1 WITH FRAME TITLE text-00a.
PARAMETERS: pa_add AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK zusatz1.
* Definition of the selection-screen 1100

SELECTION-SCREEN: BEGIN OF SCREEN 1100.
SELECTION-SCREEN BEGIN OF BLOCK zusatz2 WITH FRAME TITLE text-00a.
PARAMETERS: pa_mark1 AS CHECKBOX,
            pa_mark2 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK zusatz2.
SELECTION-SCREEN:  END OF SCREEN 1100.

* Initialization both selection-screens.
INITIALIZATION.
  MOVE:   'DL' TO carrid-low,
          'I' TO carrid-sign,
          'EQ' TO carrid-option.
  APPEND carrid.

  MOVE:   'X' TO pa_mark2.

* Check if any box is marked on screen 1100
AT SELECTION-SCREEN.
  CASE sy-dynnr.
    WHEN '1100'.
      IF ( pa_mark1 IS INITIAL  AND  pa_mark2 IS INITIAL ).
        MESSAGE e032(bc405).
      ENDIF.
  ENDCASE.

* Get data from logical database F1s
GET spfli FIELDS carrid connid.

GET sflight FIELDS fldate.

GET sbook FIELDS bookid customid agencynum.
  MOVE-CORRESPONDING sbook TO wa_itab.
  APPEND wa_itab TO itab.


END-OF-SELECTION.
  IF pa_add = mark.
    CALL SELECTION-SCREEN 1100.
    CHECK sy-subrc = 0.
    PERFORM data_output_standard.

    IF pa_mark1 = mark.
      NEW-PAGE NO-HEADING.
      WRITE: text-s02 COLOR COL_HEADING. SKIP.
      SELECT id name form custtype FROM scustom
      INTO wa_custom  FOR ALL ENTRIES IN itab
      WHERE  id = itab-customid.
        PERFORM data_output_custom.
      ENDSELECT.
    ENDIF.

    IF pa_mark2 = mark.
      NEW-PAGE NO-HEADING.
      WRITE: text-s03 COLOR COL_HEADING. SKIP.
      SELECT agencynum name url FROM stravelag
      INTO wa_travelag FOR ALL ENTRIES IN itab
      WHERE  agencynum = itab-agencynum.
        PERFORM data_output_travel.
      ENDSELECT.
    ENDIF.

  ELSE.
    PERFORM data_output_standard.
  ENDIF.
*---------------------------------------------------------------------*
*       FORMS DATA_OUTPUT                                              *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM data_output_custom.
  DATA len TYPE i.

  len =  strlen(  wa_custom-form ).

  WRITE:  / wa_custom-id COLOR COL_KEY,
         AT 20(len) wa_custom-form, wa_custom-name,
            60      wa_custom-custtype.
  ULINE.
ENDFORM.


*---------------------------------------------------------------------*
*       FORM DATA_OUTPUT_TRAVEL                                       *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM data_output_travel.
  DATA len TYPE i.

  len =  strlen(  wa_travelag-url ).
  WRITE: / wa_travelag-agencynum COLOR COL_KEY,
           wa_travelag-name,
         AT (len) wa_travelag-url HOTSPOT COLOR COL_GROUP.

ENDFORM.                               " DATA_OUTPUT_TRAVEL

*---------------------------------------------------------------------*
*       FORM DATA_OUTPUT_STANDARD                                     *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM data_output_standard.
  LOOP AT itab INTO wa_itab.
    ON CHANGE OF wa_itab-carrid.
      WRITE: / wa_itab-carrid, wa_itab-connid.
    ENDON.
    ON CHANGE OF wa_itab-fldate.
      WRITE:  /10 wa_itab-fldate.
    ENDON.
    WRITE:   /20 wa_itab-bookid, wa_itab-customid, wa_itab-agencynum.
  ENDLOOP.
ENDFORM.
