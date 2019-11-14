*&---------------------------------------------------------------------*
*& Report  SAPBC400UDD_DETAIL_LIST                                     *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   Interactive Reporting (line selection in list)                    *
*&---------------------------------------------------------------------*

REPORT  sapbc400udd_detail_list .

DATA: wa_spfli TYPE spfli,
      wa_sflight TYPE sflight.


START-OF-SELECTION.

* Read data for primary list and display
  SELECT carrid connid airpfrom cityfrom airpto cityto deptime arrtime
         FROM spfli
         INTO CORRESPONDING FIELDS OF wa_spfli.

    FORMAT COLOR COL_KEY.
    WRITE: / wa_spfli-carrid ,
             wa_spfli-connid .

    FORMAT COLOR COL_NORMAL.
    WRITE:   wa_spfli-airpfrom ,
             wa_spfli-cityfrom ,
             wa_spfli-airpto ,
             wa_spfli-cityto ,
             wa_spfli-deptime ,
             wa_spfli-arrtime .
*   Hide information
    HIDE: wa_spfli-carrid, wa_spfli-connid.

  ENDSELECT.

* Preparing regular line selection check
* CLEAR wa_spfli.



AT LINE-SELECTION.

  IF sy-lsind = 1.

*   Check if regular line was selected
*   IF NOT wa_spfli IS INITIAL.

      WRITE: text-001 COLOR COL_NORMAL,      " Page header
             wa_spfli-carrid COLOR COL_TOTAL,
             wa_spfli-connid COLOR COL_TOTAL.
      SKIP.
      FORMAT COLOR COL_HEADING.
      WRITE: text-003, text-004, text-005.
      SKIP.
      FORMAT COLOR COL_NORMAL.

*     Select data for secondary list
      SELECT fldate seatsmax seatsocc
             FROM sflight
             INTO CORRESPONDING FIELDS OF wa_sflight
             WHERE  carrid = wa_spfli-carrid
              AND   connid = wa_spfli-connid.
*       Creating secondary list
        WRITE: / wa_sflight-fldate   COLOR COL_KEY    UNDER text-003,
                 wa_sflight-seatsmax COLOR COL_NORMAL UNDER text-004,
                 wa_sflight-seatsocc COLOR COL_NORMAL UNDER text-005.
      ENDSELECT.

*   ENDIF.

  ENDIF.

* Preparing regular line selection check
* CLEAR wa_spfli.
