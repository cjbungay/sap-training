class CL_IM_BC_TAW12_CS_IMP definition
  public
  final
  create public .

*"* public components of class CL_IM_BC_TAW12_CS_IMP
*"* do not include other source files here!!!
public section.

  interfaces IF_EX_BC_TAW12_CS .
protected section.
*"* protected components of class CL_IM_BC_TAW12_CS_IMP
*"* do not include other source files here!!!
private section.
*"* private components of class CL_IM_BC_TAW12_CS_IMP
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_IM_BC_TAW12_CS_IMP IMPLEMENTATION.


METHOD if_ex_bc_taw12_cs~get_key_data .

  e_carrid = if_ex_bc_taw12_cs~carrid.
  e_connid = if_ex_bc_taw12_cs~connid.
  e_fldate = if_ex_bc_taw12_cs~fldate.

ENDMETHOD.


METHOD if_ex_bc_taw12_cs~get_modus .

  e_mode = if_ex_bc_taw12_cs~mode.

ENDMETHOD.


METHOD if_ex_bc_taw12_cs~get_tab_name .

  tabname = 'Sonderwünsche'.

ENDMETHOD.


METHOD if_ex_bc_taw12_cs~process_fcode .

  CALL FUNCTION 'BC_TAW12_CSS_EXEC_FCODE'
    EXPORTING
      im_fcode = fcode.

ENDMETHOD.


METHOD if_ex_bc_taw12_cs~put_key_data .

  if_ex_bc_taw12_cs~carrid = i_carrid.
  if_ex_bc_taw12_cs~connid = i_connid.
  if_ex_bc_taw12_cs~fldate = i_fldate.

ENDMETHOD.


METHOD if_ex_bc_taw12_cs~put_modus .

  if_ex_bc_taw12_cs~mode = i_mode.

ENDMETHOD.


METHOD if_ex_bc_taw12_cs~save .

  .

  CALL FUNCTION 'BC_TAW12_CSS_EXEC_FCODE'
    EXPORTING
      im_fcode  = 'SAVE'
      im_bookid = i_bookid.

ENDMETHOD.
ENDCLASS.
