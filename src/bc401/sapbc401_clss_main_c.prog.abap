*&---------------------------------------------------------------------*
*& Report  SAPBC401_CLSS_MAIN_C                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&    Final program with event processing of ALV-GRID double-click;    *
*&    airplanetypes are shown in ALV-Grid --> double-click  -->        *
*&    all flights concerning this planetype are shown !                *
*&    The event is hadled by lcl_carrier class.                        *
*&    Handler-method is "display_flights"                              *
*&    -->  all flights concerning this planetype are shown !           *
*&---------------------------------------------------------------------*

REPORT  sapbc401_clss_main_c.

TYPE-POOLS icon.

DATA: r_container TYPE REF TO cl_gui_custom_container,
      r_alv_grid TYPE REF TO cl_gui_alv_grid.

DATA: it_planetypes TYPE ty_planetypes.
DATA: ok_code TYPE sy-ucomm.

INCLUDE sapbc401_vehd_j.
INCLUDE sapbc401_clss_c.

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
  CREATE OBJECT r_agency EXPORTING im_name = 'Fly and Smile Travel'.

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
  CREATE OBJECT r_carrier EXPORTING im_name = 'Lufthansa'.

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
      SET SCREEN '0100'.
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
  IF NOT r_container IS BOUND.
    CREATE OBJECT r_container
      EXPORTING
        container_name              = 'CONTAINER_1'
      EXCEPTIONS
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
*** create object of class cl_gui_alv_grid to visualize data !
  IF NOT r_alv_grid IS BOUND.
    CREATE OBJECT r_alv_grid
      EXPORTING
        i_parent          = r_container
      EXCEPTIONS
        OTHERS            = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

*** set handler to react on double-click *******************
    SET HANDLER r_carrier->display_flights FOR r_alv_grid.

*** call functional static method to get all planetypes in itab
    it_planetypes = lcl_airplane=>get_planetypes( ).
  ENDIF.

*** Call method to visualize data of internal table ************
  CALL METHOD r_alv_grid->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SAPLANE'
    CHANGING
      it_outtab        = it_planetypes
    EXCEPTIONS
      OTHERS           = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDMODULE.                 " ALV_GRID  OUTPUT
