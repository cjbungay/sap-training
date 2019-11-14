*&---------------------------------------------------------------------*
*& Report  TAW10_OBJECTT_EVENTS                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  taw10_objectt_events                                        .

INCLUDE TAW10_OBJECTT_LCL_AIRPLANE.
INCLUDE TAW10_OBJECTT_LCL_PASSENG_AIR.
INCLUDE TAW10_OBJECTT_LCL_PASSENGER.

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
