class CL_CARRIER definition
  public
  create public .

*"* public components of class CL_CARRIER
*"* do not include other source files here!!!
public section.
  type-pools ICON .

  interfaces IF_PARTNERS .

  methods ADD_AIRPLANE
    for event AIRPLANE_CREATED of CL_AIRPLANE
    importing
      !SENDER .
  methods CONSTRUCTOR
    importing
      !IM_NAME type STRING .
  methods DISPLAY_AIRPLANES .
  methods DISPLAY_ATTRIBUTES .
  methods GET_NAME
    returning
      value(EX_NAME) type STRING .
protected section.
*"* protected components of class CL_CARRIER
*"* do not include other source files here!!!
private section.
*"* private components of class CL_CARRIER
*"* do not include other source files here!!!

  data NAME type STRING .
  data AIRPLANE_LIST type TY_AIRPLANES .
ENDCLASS.



CLASS CL_CARRIER IMPLEMENTATION.


method ADD_AIRPLANE.

    APPEND sender TO airplane_list.

endmethod.


method CONSTRUCTOR.

    name = im_name.
    SET HANDLER add_airplane FOR ALL INSTANCES.
    RAISE EVENT if_partners~partner_created.

endmethod.


method DISPLAY_AIRPLANES.

    DATA: r_plane TYPE REF TO cl_airplane.
    LOOP AT airplane_list INTO r_plane.
      r_plane->display_attributes( ).
    ENDLOOP.

endmethod.


method DISPLAY_ATTRIBUTES.

    SKIP 2.
    WRITE: icon_flight AS ICON, name . ULINE. ULINE.
    display_airplanes( ).

endmethod.


method GET_NAME.

    ex_name = name.

endmethod.


method IF_PARTNERS~DISPLAY_PARTNER.

    display_attributes( ).

endmethod.
ENDCLASS.
