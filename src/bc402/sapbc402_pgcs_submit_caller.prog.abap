*&---------------------------------------------------------------------*
*& Report  SAPBC402_PGCS_SUBMIT_CALLER
*&
*&---------------------------------------------------------------------*
*&
*& This program calls report SAPBC402_PGCS_SUBMIT_CALLED
*& via SUBMIT
*&
*& Result received via ABAP Memory (IMPORT)
*&
*&---------------------------------------------------------------------*
REPORT  sapbc402_pgcs_submit_caller.
*----------------------------------------------------------------------*
TYPES:
    ty_t_sbook   TYPE STANDARD TABLE OF sbook
                      WITH NON-UNIQUE DEFAULT KEY.
*----------------------------------------------------------------------*
DATA:
    it_sbook     TYPE ty_t_sbook,
    wa_sbook     LIKE LINE OF it_sbook,

    fromdate     TYPE sbook-order_date,
    todate       TYPE sbook-order_date.
*----------------------------------------------------------------------*
START-OF-SELECTION.

  fromdate = sy-datum - 180.
  todate   = sy-datum.

  SUBMIT sapbc402_pgcs_submit_called AND RETURN
          WITH pa_cust EQ '0033'
          WITH so_odate BETWEEN fromdate AND todate.

  IMPORT it_sbook TO it_sbook
         FROM MEMORY ID 'BC402_SBOOK'.

  IF sy-subrc <> 0.
    MESSAGE e361(bc402).
  ELSE.
*----------------------------------------------------------------------*
    LOOP AT it_sbook INTO wa_sbook.

      WRITE: /
          wa_sbook-carrid,
          wa_sbook-connid,
          wa_sbook-fldate,
          wa_sbook-bookid,
          wa_sbook-customid,
          wa_sbook-luggweight UNIT wa_sbook-wunit,
          wa_sbook-wunit.

    ENDLOOP.

  ENDIF.
