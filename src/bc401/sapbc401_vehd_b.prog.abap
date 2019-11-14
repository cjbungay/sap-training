*&---------------------------------------------------------------------*
*&  Include           SAPBC401_VEHD_B                                  *
*&---------------------------------------------------------------------*


*---------------------------------------------------------------------*
*       CLASS lcl_vehicle DEFINITION
*---------------------------------------------------------------------*
* the constructor is introduced !   ( demo d )
*---------------------------------------------------------------------*
CLASS lcl_vehicle DEFINITION.

  PUBLIC SECTION.
    "-------------------
    METHODS       constructor importing im_make type string.
    METHODS       display_attributes.
    METHODS       set_make IMPORTING im_make TYPE string.
    METHODS       get_make EXPORTING ex_make TYPE string.
    CLASS-METHODS get_count EXPORTING re_count TYPE I.

  PRIVATE SECTION.
    "-------------------
    DATA: make   TYPE string.

    CLASS-DATA:  n_o_vehicles TYPE i.

ENDCLASS.                    "lcl_vehicle DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_vehicle IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_vehicle IMPLEMENTATION.

  METHOD constructor.
    make = im_make.
    add 1 to n_o_vehicles.
  ENDMETHOD.                    "constructor

  METHOD set_make.
    make = im_make.
  ENDMETHOD.                    "set_make

  METHOD get_make.
    ex_make = make.
  ENDMETHOD.                    "get_make

  METHOD display_attributes.
    WRITE: / icon_car AS ICON, make. ULINE.
  ENDMETHOD.                    "display_attributes

  METHOD get_count.
    re_count = n_o_vehicles.
  ENDMETHOD.                    "get_count

ENDCLASS.                    "lcl_vehicle IMPLEMENTATION
