*&---------------------------------------------------------------------*
*& Report  SAPBC401_CASS_MAIN_A                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  show casting operations ...                                        *
*&---------------------------------------------------------------------*

REPORT  sapbc401_cass_main_a.

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

  APPEND r_passenger TO plane_list.

  CREATE OBJECT r_cargo EXPORTING
                         im_name = 'US Hercules'
                         im_planetype = '747-500'
                         im_cargo = 533.

  APPEND r_cargo TO plane_list.

  LOOP AT plane_list INTO r_plane.
    r_plane->display_attributes( ).
  ENDLOOP.


  lcl_airplane=>display_n_o_airplanes( ).
