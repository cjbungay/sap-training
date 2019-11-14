*&---------------------------------------------------------------------*
*& Report  SAPBC401_AIRS_MAIN_C                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   call method set_Attributes to initialize objects                  *
*&   visualize content of objects via display_attributes               *
*&---------------------------------------------------------------------*

REPORT  sapbc401_airs_main_c.

TYPE-POOLS icon.

INCLUDE sapbc401_airs_c.

DATA: r_plane TYPE REF TO lcl_airplane,
      plane_list TYPE TABLE OF REF TO lcl_airplane,
      count TYPE i.




START-OF-SELECTION.
*##############################

  lcl_airplane=>display_n_o_airplanes( ).

  CREATE OBJECT r_plane.
  APPEND r_plane TO plane_list.
  r_plane->set_attributes( im_name = 'LH Berlin'
                           im_planetype = 'A321' ).

  CREATE OBJECT r_plane.
  APPEND r_plane TO plane_list.
  r_plane->set_attributes( im_name = 'AA New York'
                           im_planetype = '747-400' ).

  CREATE OBJECT r_plane.
  APPEND r_plane TO plane_list.
  r_plane->set_attributes( im_name = 'US Hercules'
                           im_planetype = '747-500' ).

  LOOP AT plane_list INTO r_plane.
    r_plane->display_attributes( ).
  ENDLOOP.

* long syntax for functional call:
* CALL METHOD lcl_airplane=>get_n_o_airplanes
*   RECEIVING
*     re_count = count.

* a little bit shorter:
* lcl_airplane=>get_n_o_airplanes( RECEIVING re_count = count ).

* the shortest syntax for functional call:
  count = lcl_airplane=>get_n_o_airplanes( ).

  SKIP 2.
  WRITE: / 'Gesamtzahl der Flugzeuge'(ca1), count.
