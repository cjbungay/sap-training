*&---------------------------------------------------------------------*
*& Report  SAPBC400WBS_GS_LIST                                         *
*&---------------------------------------------------------------------*

REPORT  sapbc400wbs_gs_list .

DATA  wa_flight TYPE sflight.


SELECT * FROM sflight INTO wa_flight.

  NEW-LINE.
  WRITE:
    wa_flight-carrid,
    wa_flight-connid,
    wa_flight-fldate,
    wa_flight-seatsocc,
    wa_flight-seatsmax.

ENDSELECT.
