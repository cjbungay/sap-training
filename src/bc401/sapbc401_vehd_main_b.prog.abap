*&---------------------------------------------------------------------*
*& Report  SAPBC401_VEHD_MAIN_B                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   instantiates 3 vehicles and inserts them into internal table      *
*&---------------------------------------------------------------------*

REPORT  sapbc401_vehd_main_b.                                 .
TYPE-POOLS icon.

INCLUDE sapbc401_vehd_a.


DATA: r_vehicle TYPE REF TO lcl_vehicle,
      vehicle_list TYPE TABLE OF REF TO lcl_vehicle.


START-OF-SELECTION.
*########################

  CREATE OBJECT r_vehicle.
  APPEND r_vehicle TO vehicle_list.

  CREATE OBJECT r_vehicle.
  APPEND r_vehicle TO vehicle_list.

  CREATE OBJECT r_vehicle.
  APPEND r_vehicle TO vehicle_list.
