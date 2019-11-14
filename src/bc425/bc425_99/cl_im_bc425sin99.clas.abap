class CL_IM_BC425SIN99 definition
  public
  final
  create public .

*"* public components of class CL_IM_BC425SIN99
*"* do not include other source files here!!!
public section.

  interfaces IF_EX_BC425_99FLIGHT2 .
protected section.
*"* protected components of class CL_IM_BC425SIN99
*"* do not include other source files here!!!
private section.
*"* private components of class CL_IM_BC425SIN99
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_IM_BC425SIN99 IMPLEMENTATION.


METHOD if_ex_bc425_99flight2~get_data .

  MOVE-CORRESPONDING if_ex_bc425_99flight2~wa TO e_flight.

ENDMETHOD.


METHOD if_ex_bc425_99flight2~put_data .

  MOVE-CORRESPONDING i_flight TO if_ex_bc425_99flight2~wa.

ENDMETHOD.
ENDCLASS.
