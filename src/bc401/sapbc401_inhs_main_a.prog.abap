*&---------------------------------------------------------------------*
*& Report  SAPBC401_INHS_MAIN_A                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  the classes plcl_passenger_plane and lcl_cargo_plane are           *
*&  instantiated. Inheritance is shown                                 *
*&---------------------------------------------------------------------*

REPORT  sapbc401_inhs_main_a.

TYPE-POOLS icon.

INCLUDE sapbc401_inhs_a.


DATA: r_plane TYPE REF TO lcl_airplane,
      r_cargo TYPE REF TO lcl_cargo_plane,
      r_passenger TYPE REF TO lcl_passenger_plane,
      plane_list TYPE TABLE OF REF TO lcl_airplane.


START-OF-SELECTION.
*##############################

  lcl_airplane=>display_n_o_airplanes( ).

  CREATE OBJECT r_passenger EXPORTING
                         im_name = 'LH BERLIN'
                         im_planetype = '747-400'
                         im_seats = 345.

  CREATE OBJECT r_cargo EXPORTING
                         im_name = 'US Hercules'
                         im_planetype = '747-500'
                         im_cargo = 533.


  r_cargo->display_attributes( ).

  r_passenger->display_attributes( ).


  lcl_airplane=>display_n_o_airplanes( ).
