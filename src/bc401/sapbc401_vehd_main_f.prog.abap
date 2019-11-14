*&---------------------------------------------------------------------*
*& Report  SAPBC401_VEHD_MAIN_F                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&       subclasses are instantiated                                   *
*&       display_attributes( ) is called                               *
*&---------------------------------------------------------------------*

REPORT  sapbc401_vehd_main_f.

TYPES: ty_fuel TYPE p DECIMALS 2,
       ty_cargo TYPE p DECIMALS 2.
TYPE-POOLS icon.

INCLUDE sapbc401_vehd_d.

DATA: r_vehicle TYPE REF TO lcl_vehicle,
      r_truck TYPE REF TO lcl_truck,
      r_bus   TYPE REF TO lcl_bus,
      count TYPE i.

START-OF-SELECTION.
*########################

******* display number of vehicles *************************************
  lcl_vehicle=>get_count( IMPORTING re_count = count ).
  WRITE: / 'Zahl der Vehikel'(001), count. ULINE.


******* create truck *****************************************
  CREATE OBJECT r_truck EXPORTING im_make = 'MAN'
                                  im_cargo = 45.

  r_truck->display_attributes( ).

******* create truck *****************************************
  CREATE OBJECT r_bus EXPORTING im_make = 'Mercedes'
                                im_passengers = 80.

  r_bus->display_attributes( ).


******* display number of vehicles again *******************************
  lcl_vehicle=>get_count( IMPORTING re_count = count ).
  WRITE: / 'Zahl der Vehikel'(001), count. ULINE.
