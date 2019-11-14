*&---------------------------------------------------------------------*
*& Report SAPBC405_LDBD_SIMPLE_EXAMPLE                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   Simple program using the logical database F1S                   *
*&---------------------------------------------------------------------*

REPORT  sapbc405_ldbd_simple_example LINE-SIZE 83.

NODES: spfli, sflight.
DATA: seatsfree LIKE sflight-seatsocc.
CONSTANTS: line_size TYPE i VALUE 83.
* Processing of SPFLI records
GET spfli FIELDS carrid connid cityfrom cityto.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE: / sy-vline, spfli-cityfrom,
           spfli-cityto, AT line_size sy-vline.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  WRITE: / sy-vline, 5 spfli-carrid, spfli-connid,
           AT line_size sy-vline.

* Processing of SFLIGHT records
GET sflight FIELDS fldate price currency  seatsmax seatsocc.
  seatsfree = sflight-seatsmax - sflight-seatsocc.
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  WRITE: / sy-vline, 10 sflight-fldate,
           sflight-price CURRENCY sflight-currency, sflight-currency,
           seatsfree, sflight-seatsocc, sflight-seatsmax,
           AT line_size sy-vline.

* All SFLIGHT records belonging to one SPFLI record are processed
GET spfli LATE.
  ULINE.
