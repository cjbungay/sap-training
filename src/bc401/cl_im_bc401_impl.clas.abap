class CL_IM_BC401_IMPL definition
  public
  final
  create public .

*"* public components of class CL_IM_BC401_IMPL
*"* do not include other source files here!!!
public section.

  interfaces IF_EX_BADI_BC401 .
protected section.
*"* protected components of class CL_IM_BC401_IMPL
*"* do not include other source files here!!!
private section.
*"* private components of class CL_IM_BC401_IMPL
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_IM_BC401_IMPL IMPLEMENTATION.


METHOD if_ex_badi_bc401~enhance_list.
  DATA list_of_partners TYPE ty_partners.
  data: r_partner type ref to if_partners.

  list_of_partners = im_r_agency->get_list_of_partners( ).
  loop at list_of_partners into r_partner.
     write: / ' I am a business partner of the travel agency ! '.
  endloop.
ENDMETHOD.
ENDCLASS.
