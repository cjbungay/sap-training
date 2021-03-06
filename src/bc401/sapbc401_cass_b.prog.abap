*&---------------------------------------------------------------------*
*&  Include           SAPBC401_CASS_B                                  *
*&---------------------------------------------------------------------*


*------------------------------------------------------------------*
*       CLASS lcl_airplane DEFINITION                              *
*------------------------------------------------------------------*
CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.
    "---------------------------------------------
    CONSTANTS: pos_1 TYPE i VALUE 30.

    METHODS: constructor IMPORTING
                   im_name      TYPE string
                   im_planetype TYPE saplane-planetype,
             display_attributes.

    CLASS-METHODS: class_constructor.
    CLASS-METHODS: display_n_o_airplanes.

  PRIVATE SECTION.
    "----------------------------------------------
    METHODS: get_technical_attributes
                 IMPORTING im_type     TYPE saplane-planetype
                 EXPORTING ex_weight   TYPE s_plan_wei
                           ex_tankcap  TYPE s_capacity.

    DATA: name      TYPE string,
          planetype TYPE saplane-planetype.

    CLASS-DATA: n_o_airplanes TYPE i.
    CLASS-DATA: list_of_planetypes TYPE ty_planetypes.

ENDCLASS.                    "lcl_airplane DEFINITION

*------------------------------------------------------------------*
*       CLASS lcl_airplane IMPLEMENTATION                          *
*------------------------------------------------------------------*
CLASS lcl_airplane IMPLEMENTATION.

  METHOD constructor.
    name          = im_name.
    planetype     = im_planetype.
    n_o_airplanes = n_o_airplanes + 1.
  ENDMETHOD.                    "constructor

  METHOD class_constructor.
    SELECT * FROM saplane INTO TABLE list_of_planetypes.
  ENDMETHOD.                    "constructor

  METHOD display_attributes.
    DATA: weight TYPE saplane-weight,
          cap TYPE saplane-tankcap.
    WRITE: / icon_ws_plane AS ICON,
           / 'Name of airplane: '(001), AT pos_1 name,
           / 'Type of airplane: '(002), AT pos_1 planetype.
    get_technical_attributes( EXPORTING im_type = planetype
                              IMPORTING ex_weight = weight
                                        ex_tankcap = cap ).
    WRITE: / 'Weight:'(003), weight,
             'Tankkap:'(004), cap.
  ENDMETHOD.                    "display_attributes

  METHOD display_n_o_airplanes.
    WRITE: /, / 'Number of airplanes: '(ca1),
           AT pos_1 n_o_airplanes LEFT-JUSTIFIED, /.
  ENDMETHOD.                    "display_n_o_airplanes

  METHOD get_technical_attributes.
    DATA: wa TYPE saplane.

    READ TABLE list_of_planetypes INTO wa
               WITH TABLE KEY planetype = im_type
                          TRANSPORTING weight tankcap.
    ex_weight = wa-weight.
    ex_tankcap = wa-tankcap.
  ENDMETHOD.                    "get_technical_attributes

ENDCLASS.                    "lcl_airplane IMPLEMENTATION


*---------------------------------------------------------------------*
*       CLASS lcl_cargo_plane DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_cargo_plane DEFINITION INHERITING FROM lcl_airplane.

  PUBLIC SECTION.
    "----------------------
    METHODS: constructor IMPORTING im_name TYPE string
                                   im_planetype TYPE saplane-planetype
                                   im_cargo TYPE scplane-cargomax.
    METHODS: display_attributes REDEFINITION.

  PRIVATE SECTION.
    "----------------------
    DATA: max_cargo TYPE scplane-cargomax.

ENDCLASS.                    "lcl_cargo_plane DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_cargo_plane IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_cargo_plane IMPLEMENTATION.


  METHOD constructor.
    CALL METHOD super->constructor
      EXPORTING
        im_name      = im_name
        im_planetype = im_planetype.
    max_cargo = im_cargo.
  ENDMETHOD.                    "constructor


  METHOD display_attributes.
    super->display_attributes( ).
    WRITE: / 'Max Cargo = ', max_cargo.
    ULINE.
  ENDMETHOD.                    "display_attributes

ENDCLASS.                    "lcl_cargo_plane IMPLEMENTATION

*---------------------------------------------------------------------*
*       CLASS lcl_passenger_plane DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_passenger_plane DEFINITION INHERITING FROM lcl_airplane..

  PUBLIC SECTION.
    METHODS: constructor IMPORTING im_name TYPE string
                                   im_planetype TYPE saplane-planetype
                                   im_seats TYPE sflight-seatsmax.
    METHODS: display_attributes REDEFINITION.

  PRIVATE SECTION.
    DATA: max_seats TYPE sflight-seatsmax.
ENDCLASS.                    "lcl_passenger_plane DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_passenger_plane IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_passenger_plane IMPLEMENTATION.


  METHOD constructor.
    CALL METHOD super->constructor
      EXPORTING
        im_name      = im_name
        im_planetype = im_planetype.
    max_seats = im_seats.
  ENDMETHOD.                    "constructor


  METHOD display_attributes.
    super->display_attributes( ).
    WRITE: / 'Max Seats = ', max_seats.
    ULINE.
  ENDMETHOD.                    "display_attributes
ENDCLASS.                    "lcl_passenger_plane IMPLEMENTATION


*---------------------------------------------------------------------*
*       CLASS lcl_carrier DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_carrier DEFINITION.

  PUBLIC SECTION.
    "----------------------------------------
    METHODS: constructor IMPORTING im_name TYPE string,
             get_name RETURNING value(ex_name) TYPE string,
             add_airplane IMPORTING
                     im_plane TYPE REF TO lcl_airplane,
             display_airplanes,
             display_attributes.
  PRIVATE SECTION.
    "-----------------------------------
    DATA: name              TYPE string,
          airplane_list TYPE TABLE OF REF TO lcl_airplane.
ENDCLASS.                    "lcl_carrier DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_carrier IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_carrier IMPLEMENTATION.

  METHOD add_airplane.
    APPEND im_plane TO airplane_list.
  ENDMETHOD.                    "add_airplane

  METHOD display_attributes.
    WRITE: icon_flight AS ICON, name . ULINE. ULINE.
    display_airplanes( ).
  ENDMETHOD.                    "display_attributes


  METHOD display_airplanes.
    DATA: r_plane TYPE REF TO lcl_airplane.
    LOOP AT airplane_list INTO r_plane.
      r_plane->display_attributes( ).
    ENDLOOP.
  ENDMETHOD.                    "display_airplanes

  METHOD constructor.
    name = im_name.
  ENDMETHOD.                    "constructor

  METHOD get_name.
    ex_name = name.
  ENDMETHOD.                    "get_name

ENDCLASS.                    "lcl_carrier IMPLEMENTATION
