*&---------------------------------------------------------------------*
*& Report  SAPBC401_EXCD_GET_PREVIOUS                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& This program contains a local class representing carrier companies. *
*& It calls a method in order to display a carrier's airplanes data.   *
*& This method in turn calls a method in order to retrieve the data    *
*& from the local data buffer.                                         *
*&                                                                     *
*& In case of an invalid planetype an exceptions will be raised and    *
*& handled by raising a second one.                                    *
*&                                                                     *
*& The second exception is handled in the main program.                *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc401_excd_get_previous  .

TYPES t_name_15 TYPE c LENGTH 15.

INCLUDE bc401_excd_get_previous_c01.

DATA:
  ref_plane   TYPE REF TO lcl_plane,
  ref_carrier TYPE REF TO lcl_carrier,

  ref_exc      TYPE REF TO cx_bc401_excd_list,
  exc_text      TYPE string,
  previous_text TYPE string.




START-OF-SELECTION.

  CREATE OBJECT ref_carrier
    EXPORTING
      im_name = 'Better Flying'.


  CREATE OBJECT ref_plane
    EXPORTING
      im_name = 'Frankfurt'
      im_type = '747-400'.

  CALL METHOD ref_carrier->add_airplane
    EXPORTING
      im_ref_plane = ref_plane.


  CREATE OBJECT ref_plane
    EXPORTING
      im_name = 'Hamburg'
      im_type = 'A310-200F'.

  CALL METHOD ref_carrier->add_airplane
    EXPORTING
      im_ref_plane = ref_plane.


  CREATE OBJECT ref_plane
    EXPORTING
      im_name = 'Bremen'
      im_type = 'XYZ'.

  CALL METHOD ref_carrier->add_airplane
    EXPORTING
      im_ref_plane = ref_plane.


  CREATE OBJECT ref_plane
    EXPORTING
      im_name = 'Stuttgart'
      im_type = 'A319'.

  CALL METHOD ref_carrier->add_airplane
    EXPORTING
      im_ref_plane = ref_plane.

  SKIP.

  TRY.
      CALL METHOD ref_carrier->display_attributes.

    CATCH cx_bc401_excd_list INTO ref_exc.

      exc_text = ref_exc->get_text( ).
      MESSAGE exc_text TYPE 'I'.

      previous_text = ref_exc->previous->get_text( ).
      MESSAGE previous_text TYPE 'I'.
  ENDTRY.
