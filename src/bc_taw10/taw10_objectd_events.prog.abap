*&---------------------------------------------------------------------*
*& Report  TAW10_OBJECTD_EVENTS                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  taw10_objectd_events                                        .

INCLUDE taw10_objectd_lcl_airplane.
INCLUDE taw10_objectd_lcl_passeng_air.
INCLUDE taw10_objectd_lcl_passenger.

DATA: airplane TYPE REF TO lcl_passenger_airplane,
      passenger TYPE REF TO lcl_passenger.


START-OF-SELECTION.

  CREATE OBJECT airplane EXPORTING  im_name      = 'LH Berlin'
                                    im_planetype = '747-400'
                                    im_n_o_seats = 580.
  CREATE OBJECT passenger EXPORTING im_name    = 'Miller'
                                    im_surname = 'Arthur'.


  CALL METHOD passenger->enter_airplane
    EXPORTING
      im_plane = airplane.

  CALL METHOD airplane->take_off.

  CALL METHOD airplane->landing.

  CALL METHOD passenger->exit_airplane
    EXPORTING
      im_plane = airplane.


AT LINE-SELECTION.

  CALL METHOD airplane->take_off.

  CALL METHOD airplane->landing.
