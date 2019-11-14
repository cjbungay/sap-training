*&---------------------------------------------------------------------*
*& Report  SAPBC400CID_CODE_INSPECTOR_1                                *
*&---------------------------------------------------------------------*
*&                                                                     *
*&  This program contains some bad programming techniques              *
*&  that should be found by the CODE INSPECTOR .                       *
*&                                                                     *
*&---------------------------------------------------------------------*

* Is this ok ?
REPORT  my_program.

* Selection text ?
PARAMETERS pa_carr TYPE s_carr_id.

DATA wa_conn TYPE sdyn_conn.


* What is missing here ?
AUTHORITY-CHECK OBJECT 'S_CARRID'
         ID 'CARRID' FIELD pa_carr
         ID 'ACTVT'  FIELD '03'.


SELECT * FROM spfli
         INTO CORRESPONDING FIELDS OF wa_conn
         WHERE  carrid = pa_carr.
* Performance ?
  SELECT SINGLE carrname FROM scarr
                         INTO wa_conn-carrname
                         WHERE  carrid = wa_conn-carrid.

  WRITE: / wa_conn-carrname, wa_conn-carrid, wa_conn-connid,
           wa_conn-cityfrom, wa_conn-cityto,
           wa_conn-deptime,  wa_conn-arrtime.

ENDSELECT.


* Is this ok ?
BREAK-POINT.

IF sy-subrc NE 0.
* Translation ?
  WRITE 'No connections found !'.
ENDIF.
