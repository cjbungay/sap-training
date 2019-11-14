class CL_PASSENGER_PLANE definition
  public
  inheriting from CL_AIRPLANE
  create public .

*"* public components of class CL_PASSENGER_PLANE
*"* do not include other source files here!!!
public section.
  type-pools ICON .

  methods CONSTRUCTOR
    importing
      !IM_NAME type STRING
      !IM_PLANETYPE type SAPLANE-PLANETYPE
      !IM_SEATS type SFLIGHT-SEATSMAX .

  methods DISPLAY_ATTRIBUTES
    redefinition .
protected section.
*"* protected components of class CL_PASSENGER_PLANE
*"* do not include other source files here!!!
private section.
*"* private components of class CL_PASSENGER_PLANE
*"* do not include other source files here!!!

  data MAX_SEATS type SFLIGHT-SEATSMAX .
ENDCLASS.



CLASS CL_PASSENGER_PLANE IMPLEMENTATION.


method CONSTRUCTOR.

    CALL METHOD super->constructor
      EXPORTING
        im_name      = im_name
        im_planetype = im_planetype.
    max_seats = im_seats.

endmethod.


method DISPLAY_ATTRIBUTES.

    super->display_attributes( ).
    WRITE: / 'Max Seats = ', max_seats.
    ULINE.

endmethod.
ENDCLASS.
