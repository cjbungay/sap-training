*&---------------------------------------------------------------------*
*&  Include           SAPBC401_CAST_B                                  *
*&---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
*       CLASS lcl_carrier DEFINITION                                  *
*---------------------------------------------------------------------*
*CLASS lcl_carrier DEFINITION.
*
*  PUBLIC SECTION.
*    "----------------------------------------
*    METHODS: constructor IMPORTING im_name TYPE string,
*             get_name RETURNING value(ex_name) TYPE string,
*             add_airplane
*             display_airplanes,
*             display_attributes.
*
*  PRIVATE SECTION.
*    "-----------------------------------
*    DATA: name              TYPE string,
*          airplane_list TYPE TABLE OF REF TO lcl_airplane.
*ENDCLASS.                    "lcl_carrier DEFINITION
*
*---------------------------------------------------------------------*
*       CLASS lcl_carrier IMPLEMENTATION
*---------------------------------------------------------------------*
*CLASS lcl_carrier IMPLEMENTATION.
*
*  METHOD add_airplane.
*
*  ENDMETHOD.                    "add_airplane
*
*  METHOD display_attributes.
*    WRITE: icon_flight AS ICON, name . ULINE. ULINE.
*
*  ENDMETHOD.                    "display_attributes
*
*
*  METHOD display_airplanes.
*    DATA: r_plane TYPE REF TO lcl_airplane.
*
*
*  ENDMETHOD.                    "display_airplanes
*
*  METHOD constructor.
*    name = im_name.
*  ENDMETHOD.                    "constructor
*
*  METHOD get_name.
*    ex_name = name.
*  ENDMETHOD.                    "get_name
*
*ENDCLASS.                    "lcl_carrier IMPLEMENTATION
