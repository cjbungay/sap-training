*&---------------------------------------------------------------------*
*& Report  SAPBC401_VEHD_MAIN_E                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   instantiates 3 vehicles and inserts them into internal table      *
*&   some methods are called showing how to imp. and exp. parameters   *
*&   call functional method ; call private method inside class         *
*&---------------------------------------------------------------------*

REPORT  sapbc401_vehd_main_e.

TYPES: ty_fuel TYPE p DECIMALS 2.

TYPE-POOLS icon.

INCLUDE sapbc401_vehd_c.

DATA: r_vehicle TYPE REF TO lcl_vehicle,
      vehicle_list TYPE TABLE OF REF TO lcl_vehicle,
      count TYPE i,
      make_name TYPE string,
      fuel TYPE ty_fuel.


START-OF-SELECTION.
*########################

******* display number of vehicles *************************************
  lcl_vehicle=>get_count( IMPORTING re_count = count ).
  WRITE: / 'Zahl der Autos:'(001), count. ULINE.


******* create first vehicle *****************************************
  CREATE OBJECT r_vehicle EXPORTING im_make = 'VW'.

***** just show the usage of private method INIT_MAKE ******************
  r_vehicle->set_make( ' ' ).

  APPEND r_vehicle TO vehicle_list.

******* create second vehicle *****************************************
  CREATE OBJECT r_vehicle EXPORTING im_make = 'Mercedes'.

  APPEND r_vehicle TO vehicle_list.

******* create third vehicle *****************************************
  CREATE OBJECT r_vehicle EXPORTING im_make = 'Ford'.

  APPEND r_vehicle TO vehicle_list.

******* show all vehicles *****************************************
  LOOP AT vehicle_list INTO r_vehicle.
    r_vehicle->display_attributes( ).
  ENDLOOP.

******* display number of vehicles again********************************
  lcl_vehicle=>get_count( IMPORTING re_count = count ).
  WRITE: / 'Zahl der Autos: '(001), count. ULINE.

******* call functional method *************************************
  fuel = r_vehicle->get_average_fuel( im_distance = 500 im_fuel = 50 ).
  WRITE: / 'Average Fuel = ', fuel.
