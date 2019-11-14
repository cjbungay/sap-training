*&---------------------------------------------------------------------*
*& Report  SAPBC401_VEHD_MAIN_D                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   instantiates 3 vehicles and inserts them into internal table      *
*&   some methods are called showing how to imp. and exp. parameters   *
*&   introduce the constructor                                         *
*&---------------------------------------------------------------------*

REPORT  sapbc401_vehd_main_d.

TYPE-POOLS icon.

INCLUDE sapbc401_vehd_b.


DATA: r_vehicle TYPE REF TO lcl_vehicle,
      vehicle_list TYPE TABLE OF REF TO lcl_vehicle,
      count TYPE i,
      make_name TYPE string.


START-OF-SELECTION.
*########################

  lcl_vehicle=>get_count( IMPORTING re_count = count ).
  WRITE: / 'Zahl der Autos: '(001), count. ULINE.

  CREATE OBJECT r_vehicle EXPORTING im_make = 'VW'.

  APPEND r_vehicle TO vehicle_list.

  CREATE OBJECT r_vehicle EXPORTING im_make = 'Mercedes'.

  APPEND r_vehicle TO vehicle_list.


  CREATE OBJECT r_vehicle EXPORTING im_make = 'Ford'.

  APPEND r_vehicle TO vehicle_list.

  LOOP AT vehicle_list INTO r_vehicle.
    r_vehicle->display_attributes( ).
  ENDLOOP.

  lcl_vehicle=>get_count( IMPORTING re_count = count ).
  WRITE: / 'Zahl der Autos: '(001), count. ULINE.
