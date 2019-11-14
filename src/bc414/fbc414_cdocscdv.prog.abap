* declaration for the long text
DATA: BEGIN OF ICDTXT_BC_BOOK         OCCURS 20.
        INCLUDE STRUCTURE CDTXT.
DATA: END OF ICDTXT_BC_BOOK        .

DATA: UPD_ICDTXT_BC_BOOK         TYPE C.

TABLES: *SBOOK
       , SBOOK                         .
DATA: UPD_SBOOK                          TYPE C.

