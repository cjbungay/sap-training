*&---------------------------------------------------------------------*
*& Report  SAPBC400RUD_LOGICAL_DATABASE                                *
*&---------------------------------------------------------------------*
*&                                                                     *
*&   Reading database tables using a logical database                  *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc400rud_logical_database .

* Workarea for receiving data from the logical database
NODES: spfli, sflight.


START-OF-SELECTION.
  WRITE 'Connections & Flights' COLOR 3.
  skip.


GET spfli FIELDS carrid connid.
  WRITE: / 'GET SPFLI' COLOR 1,
         14 spfli-carrid, spfli-connid .


GET sflight FIELDS fldate.
  WRITE: /3 'GET SFLIGHT' COLOR 2,
         18 sflight-fldate.


GET spfli LATE.
  WRITE: / 'GET SPFLI LATE' COLOR 1.
  skip.


END-OF-SELECTION.
  WRITE: / 'END-OF-SELECTION' COLOR 3.
