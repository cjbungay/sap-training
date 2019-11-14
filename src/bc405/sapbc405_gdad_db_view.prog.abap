*&---------------------------------------------------------------------*
*& Report  SAPBC405_GDAD_DB_VIEW                                       *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  Data selection using a database view from the hierarchical tables  *
*&                 scarr (alias a)                                     *
*&                 spfli (alias b)                                     *
*&                 sflight (alias c)                                   *
*&---------------------------------------------------------------------*

INCLUDE BC405_GDAD_DB_VIEWTOP.
INCLUDE BC405_GDAD_DB_VIEWF01.


START-OF-SELECTION.
 SELECT CARRID CARRNAME CONNID CITYFROM CITYTO FLDATE SEATSMAX SEATSOCC
  INTO TABLE ITAB_FLIGHTS
   FROM SV_FLIGHTS
    WHERE CITYFROM IN SO_CITYF
    AND   CITYTO   IN SO_CITYT
    AND   SEATSOCC < SV_FLIGHTS~SEATSMAX
   ORDER BY CARRID CONNID FLDATE.

PERFORM DATA_OUTPUT.
