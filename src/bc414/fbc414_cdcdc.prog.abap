FORM CD_CALL_BC_BOOK        .
   IF   ( UPD_SBOOK                          NE SPACE )
     OR ( UPD_ICDTXT_BC_BOOK         NE SPACE )
   .
     CALL FUNCTION 'BC_BOOK_WRITE_DOCUMENT        ' IN UPDATE TASK
        EXPORTING OBJECTID              = OBJECTID
                  TCODE                 = TCODE
                  UTIME                 = UTIME
                  UDATE                 = UDATE
                  USERNAME              = USERNAME
                  PLANNED_CHANGE_NUMBER = PLANNED_CHANGE_NUMBER
                  OBJECT_CHANGE_INDICATOR = CDOC_UPD_OBJECT
                  PLANNED_OR_REAL_CHANGES = CDOC_PLANNED_OR_REAL
                  NO_CHANGE_POINTERS = CDOC_NO_CHANGE_POINTERS
                  O_SBOOK
                      = *SBOOK
                  N_SBOOK
                      = SBOOK
                  UPD_SBOOK
                      = UPD_SBOOK
                  UPD_ICDTXT_BC_BOOK
                      = UPD_ICDTXT_BC_BOOK
          TABLES  ICDTXT_BC_BOOK
                      = ICDTXT_BC_BOOK
     .
   ENDIF.
   CLEAR PLANNED_CHANGE_NUMBER.
ENDFORM.
