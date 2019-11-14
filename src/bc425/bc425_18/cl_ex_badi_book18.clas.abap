*" type-pools
type-pools:
  SEEX .

class CL_EX_BADI_BOOK18 definition
  public
  final
  create public .

*" public components of class CL_EX_BADI_BOOK18
*" do not include other source files here!!!
public section.


*" implementing interfaces
interfaces:
  IF_EX_BADI_BOOK18 .
protected section.
*" protected components of class CL_EX_BADI_BOOK18
*" do not include other source files here!!!

private section.
*" private components of class CL_EX_BADI_BOOK18
*" do not include other source files here!!!


*" class attributes
class-data:
  EXIT_TABLE type SEEX_EXIT_TAB .
ENDCLASS.



CLASS CL_EX_BADI_BOOK18 IMPLEMENTATION.


method IF_EX_BADI_BOOK18~CHANGE_VLINE.
  class cl_exit_master definition load.
  data: EXIT_OBJ_TAB type SEEX_EXIT_TAB,
        EXIT_OBJ TYPE SEEX_EXIT_TAB_STRUCT.
  data exitintf type ref to IF_EX_BADI_BOOK18 .

  loop at EXIT_TABLE INTO EXIT_OBJ WHERE
          inter_name   = 'IF_EX_BADI_BOOK18' and
          FLT_VAL      = SPACE.
    append exit_obj to exit_obj_tab.
  endloop.

  if sy-subrc = 4.
    call method cl_exit_master=>CREATE_OBJ_BY_INTERFACE_FILTER
       exporting
          inter_name   = 'IF_EX_BADI_BOOK18'
          FLT_VAL      = SPACE
       importing
          EXIT_OBJ_TAB = EXIT_OBJ_TAB.

    append lines of exit_obj_tab to EXIT_TABLE.
  endif.

  loop at EXIT_OBJ_TAB into EXIT_OBJ.

    check not EXIT_OBJ-OBJ is initial.
    check EXIT_OBJ-ACTIVE = SEEX_TRUE.

    catch system-exceptions move_cast_error = 1.
      exitintf ?= EXIT_OBJ-obj.

      call function 'PF_ASTAT_OPEN'
        exporting
           OPENKEY = 'dyh{wYI2qn6AEm2WoSWnTW'
           TYP     = 'UE'.

      call method exitintf->CHANGE_VLINE
        changing
          C_POS = C_POS.


      call function 'PF_ASTAT_CLOSE'
        exporting
           OPENKEY = 'dyh{wYI2qn6AEm2WoSWnTW'
           TYP     = 'UE'.

    endcatch.
  endloop.
ENDMETHOD.


method IF_EX_BADI_BOOK18~OUTPUT.
  class cl_exit_master definition load.
  data: EXIT_OBJ_TAB type SEEX_EXIT_TAB,
        EXIT_OBJ TYPE SEEX_EXIT_TAB_STRUCT.
  data exitintf type ref to IF_EX_BADI_BOOK18 .

  loop at EXIT_TABLE INTO EXIT_OBJ WHERE
          inter_name   = 'IF_EX_BADI_BOOK18' and
          FLT_VAL      = SPACE.
    append exit_obj to exit_obj_tab.
  endloop.

  if sy-subrc = 4.
    call method cl_exit_master=>CREATE_OBJ_BY_INTERFACE_FILTER
       exporting
          inter_name   = 'IF_EX_BADI_BOOK18'
          FLT_VAL      = SPACE
       importing
          EXIT_OBJ_TAB = EXIT_OBJ_TAB.

    append lines of exit_obj_tab to EXIT_TABLE.
  endif.

  loop at EXIT_OBJ_TAB into EXIT_OBJ.

    check not EXIT_OBJ-OBJ is initial.
    check EXIT_OBJ-ACTIVE = SEEX_TRUE.

    catch system-exceptions move_cast_error = 1.
      exitintf ?= EXIT_OBJ-obj.

      call function 'PF_ASTAT_OPEN'
        exporting
           OPENKEY = 'dih{wYI2qn6AEm2WoSWnTW'
           TYP     = 'UE'.

      call method exitintf->OUTPUT
        exporting
          I_BOOKING = I_BOOKING.


      call function 'PF_ASTAT_CLOSE'
        exporting
           OPENKEY = 'dih{wYI2qn6AEm2WoSWnTW'
           TYP     = 'UE'.

    endcatch.
  endloop.
ENDMETHOD.
ENDCLASS.
