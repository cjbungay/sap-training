class CL_BUS definition
  public
  inheriting from CL_VEHICLE
  create public .

*"* public components of class CL_BUS
*"* do not include other source files here!!!
public section.
  type-pools ICON .

  methods CONSTRUCTOR
    importing
      !IM_MAKE type STRING
      !IM_PASSENGERS type I .

  methods DISPLAY_ATTRIBUTES
    redefinition .
protected section.
*"* protected components of class CL_BUS
*"* do not include other source files here!!!
private section.
*"* private components of class CL_BUS
*"* do not include other source files here!!!

  data MAX_PASSENGERS type I .
ENDCLASS.



CLASS CL_BUS IMPLEMENTATION.


method CONSTRUCTOR.

    super->constructor( im_make ).
    max_passengers = im_passengers.

endmethod.


method DISPLAY_ATTRIBUTES.

    WRITE: / icon_transportation_mode AS ICON.
    super->display_attributes( ).
    WRITE:  20 ' Passengers = ', max_passengers.
    ULINE.

endmethod.
ENDCLASS.
