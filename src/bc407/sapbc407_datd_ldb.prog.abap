*&---------------------------------------------------------------------*
*& Report  SAPBC407_DATD_LDB                                           *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc407_datd_ldb.

* Nodes definition of the logical data base F1S
NODES: spfli, sflight.
DATA: free_seats       TYPE sflight-seatsocc,
      sum              LIKE free_seats,
      sum_total        LIKE free_seats.


* Get records of table SPFLI
GET spfli.
  WRITE: spfli-carrid,
         spfli-connid,
         spfli-countryfr,
         spfli-cityfrom,
         spfli-airpfrom,
         spfli-countryto,
         spfli-cityto,
         spfli-airpto.


* Get records of table SFLIGHT
GET sflight.
  free_seats = sflight-seatsmax - sflight-seatsocc.
  WRITE: sflight-fldate,
         sflight-planetype,
         sflight-seatsmax,
         sflight-seatsocc,
         free_seats.

  sum = sum + free_seats.


* LATE event of SPFLI
GET spfli LATE.
  WRITE: 'Total free seats'(001), sum UNDER free_seats.
  ULINE.
  sum_total = sum_total + sum.
  CLEAR sum.


* Event after logical database has been evaluated
END-OF-SELECTION.
  ULINE.
  WRITE: / 'Total free seats'(001), sum_total UNDER sum.
