*&---------------------------------------------------------------------*
*&  Include           BC401_EXCS_RAISE_TRY_CL2                         *
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

    CLASS-METHODS: display_n_o_airplanes.
    EVENTS: airplane_created.

  PRIVATE SECTION.
    "----------------------------------------------
    METHODS: get_technical_attributes
                 IMPORTING im_type     TYPE saplane-planetype
                 EXPORTING ex_weight   TYPE s_plan_wei
                           ex_tankcap  TYPE s_capacity
                 RAISING   cx_bc401_invalid_planetype.

    DATA: name      TYPE string,
          planetype TYPE saplane-planetype.

    CLASS-DATA: n_o_airplanes TYPE i.

ENDCLASS.                    "lcl_airplane DEFINITION

*------------------------------------------------------------------*
*       CLASS lcl_airplane IMPLEMENTATION                          *
*------------------------------------------------------------------*
CLASS lcl_airplane IMPLEMENTATION.

  METHOD constructor.
    name          = im_name.
    planetype     = im_planetype.
    n_o_airplanes = n_o_airplanes + 1.
    RAISE EVENT airplane_created.
  ENDMETHOD.                    "constructor

  METHOD display_attributes.
    DATA: weight TYPE saplane-weight,
          cap TYPE saplane-tankcap,
          r_exception TYPE REF TO cx_root,
          exc_text TYPE string.

    WRITE: / icon_ws_plane AS ICON,
           / 'Name of Airplane'(001), AT pos_1 name,
           / 'Type of airplane: '(002), AT pos_1 planetype.

* handle exception in case of invalid planetype:
    TRY.
        get_technical_attributes( EXPORTING im_type = planetype
                                  IMPORTING ex_weight = weight
                                            ex_tankcap = cap ).
        WRITE: / 'Weight:'(003), weight,
                 'Tankkap:'(004), cap.
      CATCH cx_bc401_invalid_planetype INTO r_exception.
        exc_text = r_exception->get_text( ).
        WRITE: / exc_text COLOR COL_NEGATIVE.
    ENDTRY.
  ENDMETHOD.                    "display_attributes

  METHOD display_n_o_airplanes.
    WRITE: /, / 'Number of airplanes: '(ca1),
           AT pos_1 n_o_airplanes LEFT-JUSTIFIED, /.
  ENDMETHOD.                    "display_n_o_airplanes

  METHOD get_technical_attributes.
    SELECT SINGLE weight tankcap FROM saplane
              INTO (ex_weight, ex_tankcap)
              WHERE planetype = im_type.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_bc401_invalid_planetype
                           EXPORTING planetype = im_type.
    ENDIF.

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
    INTERFACES lif_partners.
    METHODS: constructor IMPORTING im_name TYPE string,
             get_name RETURNING value(ex_name) TYPE string,
             add_airplane FOR EVENT airplane_created OF lcl_airplane
                       IMPORTING sender,
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
  METHOD lif_partners~display_partner.
    display_attributes( ).
  ENDMETHOD.                    "lif_partners~display_partner

  METHOD add_airplane.
    APPEND sender TO airplane_list.
  ENDMETHOD.                    "add_airplane

  METHOD display_attributes.
    SKIP 2.
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
    SET HANDLER add_airplane FOR ALL INSTANCES.
    RAISE EVENT lif_partners~partner_created.
  ENDMETHOD.                    "constructor

  METHOD get_name.
    ex_name = name.
  ENDMETHOD.                    "get_name

ENDCLASS.                    "lcl_carrier IMPLEMENTATION
