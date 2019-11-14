*&-----------------------------------------------------------------*
*& Report  SAPBC401_VEHD_MAIN_G                                    *
*&                                                                 *
*&-----------------------------------------------------------------*
*&       NARROWING CAST                                            *
*&       show polymorphic behaviour - generic programming          *
*&                                                                 *
*&-----------------------------------------------------------------*

REPORT  sapbc401_vehd_main_g.

TYPES: ty_fuel TYPE p DECIMALS 2,
       ty_cargo TYPE p DECIMALS 2.

TYPE-POOLS icon.

INCLUDE sapbc401_vehd_d.

DATA: r_vehicle TYPE REF TO lcl_vehicle,
      r_truck TYPE REF TO lcl_truck,
      r_bus   TYPE REF TO lcl_bus,
      count TYPE i,
      itab TYPE TABLE OF REF TO lcl_vehicle.


START-OF-SELECTION.
*########################

******* display number of vehicles ********************************
  lcl_vehicle=>get_count( IMPORTING re_count = count ).
  WRITE: / 'Zahl der Vehikel'(001), count. ULINE.


******* create truck *****************************************
  CREATE OBJECT r_truck EXPORTING im_make = 'MAN'
                                  im_cargo = 45.
  APPEND r_truck TO itab.                 "this is the NARROWING CAST

******* create truck *****************************************
  CREATE OBJECT r_bus EXPORTING im_make = 'Mercedes'
                                im_passengers = 80.

  APPEND r_bus TO itab.                   "this is the NARROWING CAST


******* polymorphic behaviour ************************************
  LOOP AT itab INTO r_vehicle.
    r_vehicle->display_attributes( ).
  ENDLOOP.

******* display number of vehicles again **************************
  lcl_vehicle=>get_count( IMPORTING re_count = count ).
  WRITE: / 'Zahl der Vehikel'(001), count. ULINE.
