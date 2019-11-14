*&---------------------------------------------------------------------*
*& Report  SAPBC400TSD_SUB_FIELDS                                      *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  Specify subfields using offset and length                          *
*&---------------------------------------------------------------------*

REPORT  sapbc400tsd_sub_fields.

PARAMETERS date LIKE sy-datum DEFAULT sy-datum.

WRITE: / 'Year :  ', date(4),
       / 'Month : ', date+4(2),
       / 'Day :   ', date+6(2).
