*&---------------------------------------------------------------------*
*& Report  TAW10_BASICS_CALL_FUNCTION                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  taw10_basics_call_function                                  .


DATA:          it_planelist TYPE taw10_typs_planetab.
FIELD-SYMBOLS:  <plane> TYPE LINE OF taw10_typs_planetab.

PARAMETERS: pa_carr  TYPE sflight-carrid OBLIGATORY,
            pa_occ   TYPE sflight-seatsocc,
            pa_paysu TYPE sflight-paymentsum,
            pa_curr  TYPE sflight-currency DEFAULT 'EUR'.


AT SELECTION-SCREEN.

  CALL FUNCTION 'TAW10_BASICS_CREATE_PLANELIST'
    EXPORTING
      ip_seatsocc   = pa_occ
      ip_carrid     = pa_carr
      ip_paymentsum = pa_paysu
      ip_currency   = pa_curr
    IMPORTING
      ep_planelist  = it_planelist
    EXCEPTIONS
      no_planes     = 1
      OTHERS        = 2.

  CASE sy-subrc.

    WHEN 1.
      MESSAGE e040(taw10) WITH pa_carr.

    WHEN 2.
      MESSAGE e041(taw10).

  ENDCASE.


START-OF-SELECTION.

  LOOP AT it_planelist ASSIGNING <plane>.

    WRITE: / <plane>-planetype,
             <plane>-seatsmax,
             <plane>-avg_price CURRENCY <plane>-currency,
             <plane>-currency.

  ENDLOOP.
