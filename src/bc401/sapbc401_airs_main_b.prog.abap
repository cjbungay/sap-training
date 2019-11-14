*&---------------------------------------------------------------------*
*& Report  SAPBC401_AIRS_MAIN_B                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*& create and insert planes into internal table                        *
*&---------------------------------------------------------------------*

REPORT  sapbc401_airs_main_b.

TYPE-POOLS icon.

INCLUDE sapbc401_airs_a.


DATA: r_plane TYPE REF TO lcl_airplane,
      plane_list TYPE TABLE OF REF TO lcl_airplane.



START-OF-SELECTION.
*##############################

  CREATE OBJECT r_plane.
  APPEND r_plane TO plane_list.

  CREATE OBJECT r_plane.
  APPEND r_plane TO plane_list.

  CREATE OBJECT r_plane.
  APPEND r_plane TO plane_list.
