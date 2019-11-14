*"* components of interface IF_EX_BADI_BOOK20
interface IF_EX_BADI_BOOK20
  public .


  methods CHANGE_VLINE
    changing
      value(C_POS) type I .
  methods OUTPUT
    importing
      value(I_BOOKING) type SDYN_BOOK .
endinterface.
