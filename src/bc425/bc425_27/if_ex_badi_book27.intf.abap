*"* components of interface IF_EX_BADI_BOOK27
interface IF_EX_BADI_BOOK27
  public .


  methods OUTPUT
    importing
      value(I_BOOKING) type SDYN_BOOK .
  methods CHANGE_VLINE
    changing
      value(C_POS) type I .
endinterface.
