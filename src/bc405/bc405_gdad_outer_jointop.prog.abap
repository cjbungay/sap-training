*&---------------------------------------------------------------------*
*& Include BC405_GDAD_OUTER_JOINTOP                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
REPORT  SAPBC405_GDAD_OUTER_JOIN.

TYPES: BEGIN OF LINE_TYPE_FLIGHTS,
        CARRID LIKE SCARR-CARRID,
        CARRNAME LIKE SCARR-CARRNAME,
        CONNID LIKE SPFLI-CONNID,
        CITYFROM LIKE SPFLI-CITYFROM,
        CITYTO   LIKE SPFLI-CITYTO,
       END OF LINE_TYPE_FLIGHTS.

DATA: WA_FLIGHTS TYPE LINE_TYPE_FLIGHTS.
DATA: ITAB_FLIGHTS TYPE TABLE OF  LINE_TYPE_FLIGHTS.
