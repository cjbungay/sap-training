*&---------------------------------------------------------------------*
*& Report  SAPBC405_SSCD_SELECT_OPTIONS                                *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   Defining selection criteria (SELECT-OPTIONS)
*&       - with default values for an interval                         *
*&---------------------------------------------------------------------*

REPORT  SAPBC405_SSCD_SELECT_OPTIONS .

TABLES: SFLIGHT.

SELECT-OPTIONS: SO_CARR FOR SFLIGHT-CARRID DEFAULT 'AA',
                SO_FLDT FOR SFLIGHT-FLDATE.

PERFORM DATA_OUTPUT_1.

SELECT CARRID CONNID FLDATE PRICE CURRENCY FROM SFLIGHT
  INTO (SFLIGHT-CARRID, SFLIGHT-CONNID, SFLIGHT-FLDATE,
        SFLIGHT-PRICE, SFLIGHT-CURRENCY)
          WHERE CARRID IN SO_CARR
          AND   FLDATE IN SO_FLDT.
  PERFORM DATA_OUTPUT_2.
ENDSELECT.


*---------------------------------------------------------------------*
*       FORM DATA_OUTPUT_1                                            *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM DATA_OUTPUT_1.
  WRITE: / TEXT-001.
  LOOP AT SO_CARR.
    WRITE: / SO_CARR-SIGN,
             SO_CARR-OPTION,
             SO_CARR-LOW,
             SO_CARR-HIGH.
  ENDLOOP.
  SKIP.
  WRITE: / TEXT-002.
  LOOP AT SO_FLDT.
    WRITE: / SO_FLDT-SIGN,
             SO_FLDT-OPTION,
             SO_FLDT-LOW,
             SO_FLDT-HIGH.
  ENDLOOP.

  SKIP 2.
  WRITE: / TEXT-003.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM DATA_OUTPUT_2                                            *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM DATA_OUTPUT_2.
  WRITE: / SFLIGHT-CARRID,
              SFLIGHT-CONNID,
              SFLIGHT-FLDATE,
              (8) SFLIGHT-PRICE CURRENCY SFLIGHT-CURRENCY,
              SFLIGHT-CURRENCY.
ENDFORM.
