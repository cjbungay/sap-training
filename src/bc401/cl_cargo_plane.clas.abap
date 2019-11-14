class CL_CARGO_PLANE definition
  public
  inheriting from CL_AIRPLANE
  create public .

*"* public components of class CL_CARGO_PLANE
*"* do not include other source files here!!!
public section.
  type-pools ICON .

  methods CONSTRUCTOR
    importing
      !IM_CARGO type SCPLANE-CARGOMAX
      !IM_NAME type STRING
      !IM_PLANETYPE type SAPLANE-PLANETYPE .

  methods DISPLAY_ATTRIBUTES
    redefinition .
protected section.
*"* protected components of class CL_CARGO_PLANE
*"* do not include other source files here!!!
private section.
*"* private components of class CL_CARGO_PLANE
*"* do not include other source files here!!!

  data MAX_CARGO type SCPLANE-CARGOMAX .
ENDCLASS.



CLASS CL_CARGO_PLANE IMPLEMENTATION.


method CONSTRUCTOR.

    CALL METHOD super->constructor
      EXPORTING
        im_name      = im_name
        im_planetype = im_planetype.
    max_cargo = im_cargo.

endmethod.


method DISPLAY_ATTRIBUTES.

    super->display_attributes( ).
    WRITE: / 'Max Cargo = ', max_cargo.
    ULINE.

endmethod.
ENDCLASS.
