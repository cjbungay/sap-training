*&---------------------------------------------------------------------*
*& Report  SAPBC425_TEMPLATE                                           *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc425_template             .

DATA:
    wa_spfli TYPE spfli,
    it_spfli TYPE TABLE OF spfli WITH KEY carrid connid.


SELECTION-SCREEN BEGIN OF BLOCK carrier WITH FRAME TITLE text-car.
SELECT-OPTIONS: so_carr FOR wa_spfli-carrid.
SELECTION-SCREEN END   OF BLOCK carrier.



*&---------------------------------------------------------------------*
*&   Event START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  SELECT *
      FROM spfli
      INTO CORRESPONDING FIELDS OF TABLE it_spfli
      WHERE carrid IN so_carr.
*&---------------------------------------------------------------------*
*&   Event END-OF-SELECTION
*&---------------------------------------------------------------------*
END-OF-SELECTION.

  LOOP AT it_spfli INTO wa_spfli.

    WRITE: / wa_spfli-carrid,
             wa_spfli-connid,
             wa_spfli-countryfr,
             wa_spfli-cityfrom,
             wa_spfli-countryto,
             wa_spfli-cityto,
             wa_spfli-deptime,
             wa_spfli-arrtime.

    HIDE:    wa_spfli-carrid,
             wa_spfli-connid.

  ENDLOOP.


