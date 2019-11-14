*&---------------------------------------------------------------------*
*& Report  SAPBC405_SSCD_CALL_SEL_SCREEN                               *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   Defining two selection-screens: screen 1000 and screen 1100       *
*&    - default values  (INITIALIZATION)                               *
*&    - check selection criteria (AT SELECTION-SCREEN)                 *
*&---------------------------------------------------------------------*

INCLUDE BC405_SSCD_CALL_SEL_SCREENTOP.

NODES: spfli, sflight, sbook.

* Additional parameter on the selection-screen of F1S
SELECTION-SCREEN BEGIN OF BLOCK add1 WITH FRAME TITLE text-00a.
PARAMETERS: pa_add AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK add1.

* Definition of the selection-screen 1100
SELECTION-SCREEN: BEGIN OF SCREEN 1100.
SELECTION-SCREEN BEGIN OF BLOCK details WITH FRAME TITLE text-00a.
PARAMETERS: pa_cus AS CHECKBOX,
            pa_agy AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK details.
SELECTION-SCREEN:  END OF SCREEN 1100.

* Initialization both selection-screens.
INITIALIZATION.
  MOVE:   'DL' TO carrid-low,
          'I' TO carrid-sign,
          'EQ' TO carrid-option.
  APPEND carrid.


* Second Selection Screen needed?
AT SELECTION-SCREEN ON pa_add.
  IF pa_add = mark.
* Call selection screen as popup and check the return code:
* return code <> 0, if the user pushes the cancel button
    CALL SELECTION-SCREEN 1100 STARTING AT 5 5 ENDING AT 50 10.
    IF sy-subrc <> 0.
      LEAVE TO  SCREEN 1000.
    ENDIF.
  ENDIF.

* Check, if any checkbox is marked on screen 1100
AT SELECTION-SCREEN ON BLOCK details.
  IF ( pa_cus IS INITIAL  AND  pa_agy IS INITIAL ).
    MESSAGE e032(bc405).
  ENDIF.

* Get data from logical database F1S
GET spfli FIELDS carrid connid.
  NEW-PAGE.
  FORMAT COLOR COL_KEY INTENSIFIED ON.
  WRITE: sy-vline, spfli-carrid, spfli-connid,AT line_size sy-vline.

GET sflight FIELDS fldate.
  FORMAT COLOR COL_KEY INTENSIFIED OFF.
  WRITE: sy-vline, 5 sflight-fldate,AT line_size sy-vline.
  .

GET sbook FIELDS bookid customid agencynum.
  FORMAT COLOR COL_NORMAL.
  WRITE: sy-vline, 10 sbook-bookid, sbook-customid, sbook-agencynum.
  IF pa_cus EQ mark.
    READ TABLE itab_custom
      WITH KEY id = sbook-customid INTO wa_custom.
    IF sy-subrc <> 0.
      SELECT SINGLE id name form custtype FROM scustom
        INTO wa_custom
        WHERE  id = sbook-customid.
      APPEND wa_custom TO itab_custom.
    ENDIF.
    WRITE: wa_custom-form, wa_custom-name.
  ENDIF.

  IF pa_agy EQ mark.
    READ TABLE itab_agency
    WITH KEY agencynum = sbook-agencynum INTO  wa_agency.
    IF sy-subrc <> 0.
      SELECT SINGLE agencynum name url FROM stravelag
         INTO wa_agency
         WHERE  agencynum = sbook-agencynum.
      APPEND wa_agency TO itab_agency.
    ENDIF.
    FORMAT COLOR COL_GROUP INTENSIFIED OFF HOTSPOT ON.
    WRITE:  wa_agency-name,
           (50) wa_agency-url .
  ENDIF.
  WRITE: AT line_size sy-vline.

END-OF-SELECTION.
  ULINE.
