*&---------------------------------------------------------------------*
*& Report  SAPBC401_VEHD_MAIN_I                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&       WIDENING  CAST                                                *
*&       what is the dynamic type of r_vehicle ?                       *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc401_vehd_main_i.

TYPES: ty_fuel TYPE p DECIMALS 2,
       ty_cargo TYPE p DECIMALS 2.

TYPE-POOLS icon.
INCLUDE sapbc401_vehd_e.

DATA: r_vehicle TYPE REF TO lcl_vehicle,
      r_truck TYPE REF TO lcl_truck,
      r_bus   TYPE REF TO lcl_bus,
      count TYPE i,
      cargo TYPE ty_cargo,
      itab TYPE TABLE OF REF TO lcl_vehicle.


START-OF-SELECTION.
*########################

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

******* WIDENING CAST --> CATCH ERROR ***********************
  TRY.
      r_truck ?= r_vehicle.
      cargo = r_truck->get_cargo( ).
      WRITE: / ' Cargo = ', cargo.
    CATCH cx_sy_move_cast_error.
      WRITE: / 'ERROR CX_SY_MOVE_CAST_ERROR happened'.
  ENDTRY.
