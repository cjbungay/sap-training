*&---------------------------------------------------------------------*
*& Report  SAPBC405_SSCD_F4                                            *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

INCLUDE bc405_sscd_f4top.
INCLUDE bc405_sscd_f4o01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR scust-low.
* Possible entries for the selection field SCUST-LOW
  PERFORM value_help.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR scust-high.
* Possible entries for the selection field scust-high
  PERFORM value_help.

GET spfli FIELDS carrid connid cityfrom cityto deptime arrtime fltime.
* Processing of SPFLI records, edition
  NEW-PAGE.
  FORMAT COLOR COL_GROUP INTENSIFIED.
  WRITE: / spfli-carrid,
           spfli-connid,
           spfli-cityfrom,
           spfli-cityto,
           spfli-deptime,
           spfli-arrtime,
           spfli-fltime, AT pos_linsz space.

GET sflight FIELDS fldate price currency.
* Processing of SFLIGHT records, edition
  FORMAT COLOR COL_GROUP INTENSIFIED OFF.
  WRITE: /5 sflight-fldate,
            sflight-price CURRENCY sflight-currency,
            sflight-currency, AT pos_linsz space.

GET sbook FIELDS bookid customid custtype.
* Processing of SBOOK records, check of selection criteria SCUST
  CHECK scust.
  FORMAT COLOR COL_NORMAL.
  WRITE: /5 sbook-bookid,
            sbook-customid,
            sbook-custtype, AT pos_linsz space.

*&---------------------------------------------------------------------*
*&      Form  VALUE_HELP
*----------------------------------------------------------------------*
FORM value_help.
* Possible entries for the selection field SCUST-LOW
  GET CURSOR FIELD dynprofield.
  CALL SCREEN 100
       STARTING AT 15 10
       ENDING   AT 65 20.
ENDFORM.                    "VALUE_HELP

AT LINE-SELECTION.
* Line selection on dynpro with possible entries
  IF dynprofield = 'SCUST-LOW'.
* Value request on SCUSTOM-LOW
    scust-low = id.
  ELSEIF dynprofield = 'SCUST-HIGH'.
* Value request on SCUSTOM-HIGH
    scust-high = id.
  ENDIF.
* Return to selection screen
  SET SCREEN 0.
  LEAVE SCREEN.
