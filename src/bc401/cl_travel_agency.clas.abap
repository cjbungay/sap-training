class CL_TRAVEL_AGENCY definition
  public
  create public .

*"* public components of class CL_TRAVEL_AGENCY
*"* do not include other source files here!!!
public section.
  type-pools ICON .

  methods GET_LIST_OF_PARTNERS
    returning
      value(RE_PARTNER_LIST) type TY_PARTNERS .
  methods ADD_PARTNER
    for event PARTNER_CREATED of IF_PARTNERS
    importing
      !SENDER .
  methods CONSTRUCTOR
    importing
      !IM_NAME type STRING .
  methods DISPLAY_AGENCY_PARTNERS .
  methods DISPLAY_ATTRIBUTES .
protected section.
*"* protected components of class CL_TRAVEL_AGENCY
*"* do not include other source files here!!!
private section.
*"* private components of class CL_TRAVEL_AGENCY
*"* do not include other source files here!!!

  data NAME type STRING .
  data PARTNER_LIST type TY_PARTNERS .
ENDCLASS.



CLASS CL_TRAVEL_AGENCY IMPLEMENTATION.


method ADD_PARTNER.

    APPEND sender TO partner_list.

endmethod.


method CONSTRUCTOR.

    name = im_name.
    SET HANDLER add_partner FOR ALL INSTANCES.

endmethod.


method DISPLAY_AGENCY_PARTNERS.

    DATA: r_partner TYPE REF TO if_partners.
    WRITE: icon_dependents AS ICON, name.
    WRITE:  ' Here are the partners of the travel agency: '.
    ULINE.
    ULINE.
    LOOP AT partner_list INTO r_partner.
      r_partner->display_partner( ).
    ENDLOOP.

endmethod.


METHOD display_attributes.

  WRITE: / 'Name of travel agency : ', name.
  me->display_agency_partners( ).
ENDMETHOD.


METHOD get_list_of_partners.
  re_partner_list = partner_list.
ENDMETHOD.
ENDCLASS.
