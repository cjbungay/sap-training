
DATA: UPD_ICDTXT_BC_BOOK         TYPE C.
DATA: BEGIN OF ICDTXT_BC_BOOK         OCCURS 20.
        INCLUDE STRUCTURE CDTXT.
DATA: END OF ICDTXT_BC_BOOK        .

TABLES: *SBOOK                         , SBOOK                         .
DATA: UPD_SBOOK                         .

