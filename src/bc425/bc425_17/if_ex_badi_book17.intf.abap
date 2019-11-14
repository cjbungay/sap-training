*" components of interface IF_EX_BADI_BOOK17
interface IF_EX_BADI_BOOK17
  public .


*" methods
methods:
  OUTPUT
      importing
        value(I_BOOKING) type SDYN_BOOK ,
  CHANGE_VLINE
      changing
        value(C_POS) type I .
endinterface.
