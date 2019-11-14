*&---------------------------------------------------------------------*
*& Report  SAPBC400UDD_LIST                                            *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   Creating a colored list                                           *
*&---------------------------------------------------------------------*

REPORT  sapbc400udd_list .

DATA  wa_spfli TYPE spfli.


START-OF-SELECTION.

  SELECT carrid connid airpfrom cityfrom airpto cityto deptime arrtime
         INTO CORRESPONDING FIELDS OF wa_spfli
         FROM spfli.

    WRITE: / wa_spfli-carrid COLOR COL_KEY,
             wa_spfli-connid COLOR COL_KEY,
             wa_spfli-airpfrom COLOR COL_NORMAL,
             wa_spfli-cityfrom COLOR COL_NORMAL,
             wa_spfli-airpto COLOR COL_NORMAL,
             wa_spfli-cityto COLOR COL_NORMAL,
             wa_spfli-deptime COLOR COL_NORMAL,
             wa_spfli-arrtime COLOR COL_NORMAL.

  ENDSELECT.

  SKIP 2.
  WRITE: / text-001 COLOR COL_TOTAL,
        35 sy-datum COLOR COL_TOTAL,
         / text-002 COLOR COL_TOTAL,
        35 sy-uname COLOR COL_TOTAL.
