*&---------------------------------------------------------------------*
*& Report  SAPBC405_LDBD_CHECK_SEL                                     *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  Additional selection criteria SPRICE                               *
*&  Check the actual data set                                          *
*&---------------------------------------------------------------------*

REPORT  sapbc405_ldbd_check_sel LINE-SIZE 83 .            .

NODES: spfli, sflight, sbook.
CONSTANTS: line_size TYPE i VALUE 83.
* Additional selections
SELECT-OPTIONS: sdepart FOR spfli-deptime DEFAULT '08000' TO '220000',
                sprice  FOR sflight-price DEFAULT '500' TO '1000'.

GET spfli FIELDS carrid connid cityfrom cityto deptime arrtime.
  NEW-PAGE.
  FORMAT COLOR COL_GROUP INTENSIFIED ON.
  WRITE: / sy-vline, spfli-carrid,
           spfli-connid,
           spfli-cityfrom,
           spfli-cityto,
           spfli-deptime USING EDIT MASK '__:__',
           spfli-arrtime USING EDIT MASK '__:__',
           AT line_size sy-vline.

GET sflight FIELDS fldate price currency.
* check of selection criteria sprice
  CHECK sprice.
  FORMAT COLOR COL_GROUP INTENSIFIED OFF.
  WRITE: sy-vline, 5 sflight-fldate, AT line_size sy-vline.


GET sbook FIELDS bookid customid custtype.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  WRITE: sy-vline, 10 sbook-bookid,
            sbook-customid,
            sbook-custtype,
         AT line_size sy-vline.

GET sflight LATE.
  ULINE.

