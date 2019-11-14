*&---------------------------------------------------------------------*
*& Report  SAPBC401_CLST_MAIN_B                                        *
*&                   --> This is a TEMPLATE for an exercise of BC401!  *
*&---------------------------------------------------------------------*
*&    Template program with event processing of ALV-GRID double-click; *
*&    airplanetypes are shown in ALV-GRID-CONTROL                      *
*&---------------------------------------------------------------------*

REPORT  sapbc401_clst_main_b.

TYPE-POOLS icon.

DATA: r_container TYPE REF TO cl_gui_custom_container,
      r_alv_grid TYPE REF TO cl_gui_alv_grid.
DATA: it_planetypes TYPE ty_planetypes.
DATA: ok_code TYPE sy-ucomm.

INCLUDE sapbc401_vehd_j.
INCLUDE SAPBC401_CLST_B.

DATA: r_vehicle TYPE REF TO lcl_vehicle,
      r_truck TYPE REF TO lcl_truck,
      r_bus   TYPE REF TO lcl_bus,
      r_passenger TYPE REF TO lcl_passenger_plane,
      r_cargo TYPE REF TO lcl_cargo_plane,
      r_carrier TYPE REF TO lcl_carrier,
      r_rental TYPE REF TO lcl_rental,
      r_agency TYPE REF TO lcl_travel_agency,
      r_hotel TYPE REF TO cl_hotel,
      r_plane TYPE REF TO lcl_airplane.

AT USER-COMMAND.
*####################
  CASE sy-ucomm.
    WHEN 'PLANETYPES'.
      CALL SCREEN '0100'.
  ENDCASE.

START-OF-SELECTION.
*########################
  SET PF-STATUS 'LISTSTATUS'.

******* create travel_agency *****************************************
  CREATE OBJECT r_agency EXPORTING im_name = 'Fly&Smile Travel'.

******* create hotel *****************************************
  CREATE OBJECT r_hotel EXPORTING im_name = 'Holiday Inn'
                                  im_beds = 345.

******* create rental *****************************************
  CREATE OBJECT r_rental EXPORTING im_name = 'HAPPY CAR RENTAL'.

******* create truck *****************************************
  CREATE OBJECT r_truck EXPORTING im_make = 'MAN'
                                  im_cargo = 45.
******* create truck *****************************************
  CREATE OBJECT r_bus EXPORTING im_make = 'Mercedes'
                                im_passengers = 80.

******* create truck *****************************************
  CREATE OBJECT r_truck EXPORTING im_make = 'VOLVO'
                                  im_cargo = 48.

***** Create CARRIER ********************************************
  CREATE OBJECT r_carrier EXPORTING im_name = 'Smile&Fly Travel'.

***** Passenger Plane ********************************************
  CREATE OBJECT r_passenger EXPORTING
                         im_name = 'LH BERLIN'
                         im_planetype = '747-400'
                         im_seats = 345.
***** cargo Plane ************************************************
  CREATE OBJECT r_cargo EXPORTING
                         im_name = 'US Hercules'
                         im_planetype = '747-500'
                         im_cargo = 533.
***** cargo Plane 2 *********************************************
  CREATE OBJECT r_cargo EXPORTING
                         im_name = 'US Navy 1'
                         im_planetype = '747-400'
                         im_cargo = 460.
***** Passenger Plane ********************************************
  CREATE OBJECT r_passenger EXPORTING
                         im_name = 'AA Chicago'
                         im_planetype = '747-400'
                         im_seats = 420.

******* show attributes of all partners of travel_agency ******
  r_agency->display_agency_partners( ).

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYNPROSTATUS'.
  SET TITLEBAR 'TITEL1'.

ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA: save_ok TYPE sy-ucomm.
  save_ok = ok_code.
  CLEAR ok_code.
  CASE save_ok.
    WHEN 'BACK'.
      SET SCREEN '0000'.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.

  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  ALV_GRID  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE alv_grid OUTPUT.

*** Create object of class CL_GUI_CUSTOM_CAONTAINER to manage data !

*...

*** create object of class cl_gui_alv_grid to visualize data !

*.........

*** set handler to react on double-click *******************

*...

*** call functional static method of lcl_airplane
*** to get all planetypes in itab

*...

*** Call method to visualize data of internal table ************


*........


ENDMODULE.                 " ALV_GRID  OUTPUT
