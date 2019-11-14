*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_BC_TAW12_CSS_PD
*   generation date: 01.12.2002 at 16:43:32 by user GOEBEL
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_BC_TAW12_CSS_PD    .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
