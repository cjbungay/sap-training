*&---------------------------------------------------------------------*
*& Report  SAPBC400UDD_EXAMPLE_A                                       *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   Calling and creating a screen                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc400udd_example_a                          .

CONSTANTS: actvt_display TYPE activ_auth VALUE '03',
           actvt_change  TYPE activ_auth VALUE '02'.

DATA  wa_spfli LIKE spfli.


START-OF-SELECTION.

  SELECT carrid connid airpfrom cityfrom airpto cityto
         INTO CORRESPONDING FIELDS OF wa_spfli
         FROM spfli.

    AUTHORITY-CHECK OBJECT 'S_CARRID'
          ID 'CARRID' FIELD wa_spfli-carrid
          ID 'ACTVT'  FIELD actvt_display.

    IF sy-subrc = 0.
      WRITE: / wa_spfli-carrid COLOR COL_KEY,
               wa_spfli-connid COLOR COL_KEY,
               wa_spfli-airpfrom COLOR COL_NORMAL,
               wa_spfli-cityfrom COLOR COL_NORMAL,
               wa_spfli-airpto COLOR COL_NORMAL,
               wa_spfli-cityto COLOR COL_NORMAL.
    ENDIF.

*   HIDE: wa_spfli-carrid, wa_spfli-connid.

  ENDSELECT.

  CLEAR wa_spfli.


AT LINE-SELECTION.

  IF sy-lsind = 1.
    AUTHORITY-CHECK OBJECT 'S_CARRID'
          ID 'CARRID' FIELD wa_spfli-carrid
          ID 'ACTVT'  FIELD actvt_change.
    IF sy-subrc = 0.
      CLEAR wa_spfli.
    ENDIF.
  ENDIF.
