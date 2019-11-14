*&---------------------------------------------------------------------*
*& Report  SAPBC407_DATD_PROGRAM                                       *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  This is an executable program with a very simple structure         *
*&  but typical report tasks:                                          *
*&     Data definition                                                 *
*&     Selection Screen definition                                     *
*&     Data retrieval                                                  *
*&     Data ouput.                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc407_datd_program.

***********************************
* Data definition
***********************************
DATA: free_seats TYPE sflight-seatsocc,
      wa_sflight TYPE sflight.

***********************************
* Selection screen definition
***********************************
SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_fld FOR wa_sflight-fldate.


***********************************
* Data retrieval and output
***********************************
START-OF-SELECTION.


  SELECT * FROM sflight INTO wa_sflight
    WHERE carrid IN so_car
      AND fldate IN so_fld.

* Assign a value to free_seats
free_seats = wa_sflight-seatsmax - wa_sflight-seatsocc.

    WRITE: / wa_sflight-carrid,
             wa_sflight-connid,
             wa_sflight-fldate,
             wa_sflight-seatsmax,
             wa_sflight-seatsocc,
             free_seats.

  ENDSELECT.
