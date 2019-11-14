*&---------------------------------------------------------------------*
*& Report  SAPBC400CID_CODE_INSPECTOR_2                                *
*&---------------------------------------------------------------------*
*&                                                                     *
*&  Corrected version of SAPBC400CID_CODE_INSPECTOR_1                  *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc400cid_code_inspector_2 .

PARAMETERS pa_carr TYPE s_carr_id.

DATA wa_conn TYPE sdyn_conn.


AUTHORITY-CHECK OBJECT 'S_CARRID'
         ID 'CARRID' FIELD pa_carr
         ID 'ACTVT'  FIELD '03'.

IF sy-subrc NE 0.
  WRITE 'Authority check failed !'(acf).
  EXIT.
ENDIF.


SELECT * FROM bc400_cisd_fli             "Select from a buffered view
         INTO CORRESPONDING FIELDS OF wa_conn
         WHERE carrid = pa_carr.

  WRITE: / wa_conn-carrname, wa_conn-carrid, wa_conn-connid,
           wa_conn-cityfrom, wa_conn-cityto,
           wa_conn-deptime,  wa_conn-arrtime.

ENDSELECT.

IF sy-subrc NE 0.
  WRITE 'No connections found !'(ncf).
ENDIF.
