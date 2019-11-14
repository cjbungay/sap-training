*&---------------------------------------------------------------------*
*&  Include           TAW10_OBJECTD_LCL_PASSENGER                      *
*&---------------------------------------------------------------------*
*       CLASS lcl_passenger DEFINITION                                 *
*----------------------------------------------------------------------*
CLASS lcl_passenger DEFINITION.

  PUBLIC SECTION.

    METHODS: constructor IMPORTING im_name      TYPE string
                                   im_surname   TYPE string,
*            Subscribe for event touched_down of plane im_plane
             enter_airplane IMPORTING
                            im_plane TYPE REF TO lcl_passenger_airplane,
*            Unsubscribe for event touched_down of plane im_plane
             exit_airplane  IMPORTING
                            im_plane TYPE REF TO lcl_passenger_airplane,
*            Event handler method for event touched_down
             on_touched_down FOR EVENT touched_down OF lcl_airplane.

  PRIVATE SECTION.

    DATA: name    TYPE string,
          surname TYPE string.

ENDCLASS.                    "lcl_passenger DEFINITION


*---------------------------------------------------------------------*
*       CLASS lcl_passenger IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_passenger IMPLEMENTATION.

  METHOD constructor.
    name    = im_name.
    surname = im_surname.
  ENDMETHOD.                    "constructor

  METHOD enter_airplane.
*   Subscribe for event touched_down of plane im_plane
    SET HANDLER on_touched_down FOR im_plane.
    WRITE: / surname, name, 'besteigt das Flugzeug'(ent).
  ENDMETHOD.                    "enter_airplane

  METHOD exit_airplane.
*   Unsubscribe for event touched_down of plane im_plane
    SET HANDLER on_touched_down FOR im_plane ACTIVATION space.
    WRITE: / surname, name, 'verläßt das Flugzeug'(lea).
  ENDMETHOD.                    "exit_airplane

  METHOD on_touched_down.
    FORMAT COLOR COL_NEGATIVE.
    WRITE: / surname, name, 'klatscht in die Hände'(clh).
    FORMAT RESET.
  ENDMETHOD.                    "on_touched_down

ENDCLASS.                    "lcl_passenger IMPLEMENTATION
