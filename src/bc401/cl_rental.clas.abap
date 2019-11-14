class CL_RENTAL definition
  public
  create public .

*"* public components of class CL_RENTAL
*"* do not include other source files here!!!
public section.
  type-pools ICON .

  interfaces IF_PARTNERS .

  methods ADD_VEHICLE
    for event VEHICLE_CREATED of CL_VEHICLE
    importing
      !SENDER .
  methods CONSTRUCTOR
    importing
      !IM_NAME type STRING .
  methods DISPLAY_ATTRIBUTES .
protected section.
*"* protected components of class CL_RENTAL
*"* do not include other source files here!!!
private section.
*"* private components of class CL_RENTAL
*"* do not include other source files here!!!

  data NAME type STRING .
  data VEHICLE_LIST type TY_VEHICLES .
ENDCLASS.



CLASS CL_RENTAL IMPLEMENTATION.


method ADD_VEHICLE.

    APPEND sender TO vehicle_list.

endmethod.


method CONSTRUCTOR.

    name = im_name.
    SET HANDLER add_vehicle FOR ALL INSTANCES.
    RAISE EVENT if_partners~partner_created.

endmethod.


method DISPLAY_ATTRIBUTES.

    DATA: r_vehicle TYPE REF TO cl_vehicle.
    SKIP 2.
    WRITE: /  icon_transport_proposal AS ICON, name.
    WRITE:  ' Here comes the vehicle list: '. ULINE. ULINE.
    LOOP AT vehicle_list INTO r_vehicle.
      r_vehicle->display_attributes( ).
    ENDLOOP.

endmethod.


method IF_PARTNERS~DISPLAY_PARTNER.

    display_attributes( ).

endmethod.
ENDCLASS.
