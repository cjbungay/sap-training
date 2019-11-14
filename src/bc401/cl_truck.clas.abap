class CL_TRUCK definition
  public
  inheriting from CL_VEHICLE
  create public .

*"* public components of class CL_TRUCK
*"* do not include other source files here!!!
public section.
  type-pools ICON .

  methods CONSTRUCTOR
    importing
      !IM_CARGO type S_PLAN_CAR
      !IM_MAKE type STRING .
  methods GET_CARGO
    returning
      value(RE_CARGO) type S_PLAN_CAR .

  methods DISPLAY_ATTRIBUTES
    redefinition .
protected section.
*"* protected components of class CL_TRUCK
*"* do not include other source files here!!!
private section.
*"* private components of class CL_TRUCK
*"* do not include other source files here!!!

  data MAX_CARGO type S_PLAN_CAR .
ENDCLASS.



CLASS CL_TRUCK IMPLEMENTATION.


method CONSTRUCTOR.

    super->constructor( im_make ).
    max_cargo = im_cargo.

endmethod.


method DISPLAY_ATTRIBUTES.

    WRITE: / icon_ws_truck AS ICON.
    super->display_attributes( ).
    WRITE: 20 ' Cargo = ', max_cargo.
    ULINE.

endmethod.


method GET_CARGO.

    re_cargo = max_cargo.

endmethod.
ENDCLASS.
