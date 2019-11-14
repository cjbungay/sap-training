*&---------------------------------------------------------------------*
*&  Include           SAPBC401_VEHD_C                                  *
*&---------------------------------------------------------------------*


*---------------------------------------------------------------------*
*       CLASS lcl_vehicle DEFINITION
*---------------------------------------------------------------------*
* use functional method get_average_fuel (demo e)
* show usage of private method INIT_MAKE
*---------------------------------------------------------------------*
CLASS lcl_vehicle DEFINITION.

  PUBLIC SECTION.
    "-------------------
    METHODS: get_average_fuel IMPORTING im_distance TYPE s_distance
                                        im_fuel TYPE s_capacity
                              RETURNING value(re_avgfuel) TYPE s_consum.
    METHODS: constructor IMPORTING im_make TYPE string.
    METHODS       display_attributes.
    METHODS       set_make IMPORTING im_make TYPE string.
    METHODS       get_make EXPORTING ex_make TYPE string.
    CLASS-METHODS get_count EXPORTING re_count TYPE i.

  PRIVATE SECTION.
    "-------------------
    DATA: make   TYPE string.

    METHODS      init_make.

    CLASS-DATA:  n_o_vehicles TYPE i.

ENDCLASS.                    "lcl_vehicle DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_vehicle IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_vehicle IMPLEMENTATION.
  METHOD get_average_fuel.
    re_avgfuel = im_distance / im_fuel.
  ENDMETHOD.                    "get_average_fuel

  METHOD constructor.
    make = im_make.
    ADD 1 TO n_o_vehicles.
  ENDMETHOD.                    "constructor

  METHOD set_make.
    IF im_make IS INITIAL.
      init_make( ).   " me->init_make( ). also possible
    ELSE.
      make = im_make.
    ENDIF.
  ENDMETHOD.                    "set_make

  METHOD init_make.
    make = 'default make'.
  ENDMETHOD.                    "init_make

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
