*&---------------------------------------------------------------------*
*& Report  SAPBC400UDS_DYNPRO_1                                        *
*&---------------------------------------------------------------------*

REPORT  sapbc400uds_dynpro_1.

CONSTANTS actvt_display TYPE activ_auth VALUE '03'.

PARAMETERS pa_anum TYPE sbook-agencynum.

* workarea for SELECT
DATA wa_sbook TYPE sbook.



START-OF-SELECTION.

  SELECT carrid connid fldate bookid
         FROM sbook
         INTO CORRESPONDING FIELDS OF wa_sbook
           WHERE agencynum = pa_anum.

    AUTHORITY-CHECK OBJECT 'S_CARRID'
        ID 'CARRID' FIELD wa_sbook-carrid
        ID 'ACTVT'  FIELD actvt_display.

    IF sy-subrc = 0.
      WRITE: / wa_sbook-carrid COLOR col_key,
               wa_sbook-connid COLOR col_key,
               wa_sbook-fldate COLOR col_key,
               wa_sbook-bookid COLOR col_key.
    ENDIF.

  ENDSELECT.



AT LINE-SELECTION.

  CALL SCREEN 100.
