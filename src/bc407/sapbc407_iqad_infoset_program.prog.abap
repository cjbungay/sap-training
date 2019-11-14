*&---------------------------------------------------------------------*
*& Report  SAPBC407_IQAD_INFOSET_PROGRAM                               *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc407_iqad_infoset_program.

TABLES sflight.

SELECT-OPTIONS: so_mandt FOR sflight-mandt,
                so_car FOR sflight-carrid.

* <Query_head>

SELECT * FROM sflight CLIENT SPECIFIED
 WHERE  mandt IN so_mandt
   AND  carrid IN so_car.

* <Query_body>.
ENDSELECT.
