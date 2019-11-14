*&---------------------------------------------------------------------*
*& Report  SAPBC401_AIRS_MAIN_F                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  Raise exception if planetype does not exist                        *
*&  Exception is raised in GET_TECHNICAL_ATTRIBUTES                    *
*&---------------------------------------------------------------------*

REPORT  sapbc401_airs_main_e.

TYPE-POOLS icon.

INCLUDE SAPBC401_AIRS_F.

DATA: r_plane TYPE REF TO lcl_airplane,
      plane_list TYPE TABLE OF REF TO lcl_airplane.



START-OF-SELECTION.
*##############################

  lcl_airplane=>display_n_o_airplanes( ).


  CREATE OBJECT r_plane EXPORTING im_name = 'LH Berlin'
                                  im_planetype = 'A321'.
  APPEND r_plane TO plane_list.

  r_plane->display_attributes( ).


  CREATE OBJECT r_plane EXPORTING im_name = 'AA New York'
                                  im_planetype = '747-400'.
  APPEND r_plane TO plane_list.

  r_plane->display_attributes( ).

  CREATE OBJECT r_plane EXPORTING im_name = 'US Hercules'
                                  im_planetype = '747-500'.
  APPEND r_plane TO plane_list.

  r_plane->display_attributes( ).


  lcl_airplane=>display_n_o_airplanes( ).
