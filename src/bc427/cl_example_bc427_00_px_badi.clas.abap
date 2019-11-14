class CL_EXAMPLE_BC427_00_PX_BADI definition
  public
  final
  create public .

*"* public components of class CL_EXAMPLE_BC427_00_PX_BADI
*"* do not include other source files here!!!
public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_BC427_00_PX_BADI .
protected section.
*"* protected components of class CL_EXAMPLE_BC427_00_PX_BADI
*"* do not include other source files here!!!
private section.
*"* private components of class CL_EXAMPLE_BC427_00_PX_BADI
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_EXAMPLE_BC427_00_PX_BADI IMPLEMENTATION.


method IF_EX_BC427_00_PX_BADI~WRITE_ADDITIONAL_COLS.
  WRITE: i_wa_spfli-distance, i_wa_spfli-distid.
endmethod.
ENDCLASS.
