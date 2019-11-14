*&---------------------------------------------------------------------*
*& Report  SAPBC407_DATD_LDB_CHECK                                     *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc407_datd_ldb_check       .

* Nodes definition of the logical data base F1S
NODES: spfli, sflight.

* Program selections
SELECT-OPTIONS: so_plt FOR sflight-planetype.

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
  CHECK so_plt.

  WRITE: sflight-fldate,
         sflight-planetype,
         sflight-seatsmax,
         sflight-seatsocc.
