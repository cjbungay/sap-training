*&---------------------------------------------------------------------*
*& Report  SAPBC401_EXCD_HANDLE_EXCEP                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& This program contains a local class representing carrier companies. *
*& It calls a method in order to display a carrier's airplanes data.   *
*& This method in turn calls a method in order to retrieve the data    *
*& from the local data buffer.                                         *
*&                                                                     *
*& In case of an invalid planetype an exception will be raised and     *
*& handled.                                                            *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc401_excd_handle_excep  .

TYPES t_name_15 TYPE c LENGTH 15.

INCLUDE bc401_excd_handle_excep_c01.


DATA:
  ref_plane   TYPE REF TO lcl_plane,
  ref_carrier TYPE REF TO lcl_carrier.




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
  CALL METHOD ref_carrier->display_attributes.
