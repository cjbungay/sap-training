FUNCTION BC430_CHECK_INCLUDE.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(T_INCLUDE) LIKE  DD03L-TABNAME
*"     VALUE(M_INCLUDE) LIKE  DD03L-TABNAME
*"     VALUE(T_TAB) LIKE  DD03L-TABNAME
*"     VALUE(INC_TYPE) TYPE  CHAR8
*"  TABLES
*"      ERRORS STRUCTURE  BC430_ERROR
*"      TEMP_ERRORS STRUCTURE  BC430_ERROR
*"  EXCEPTIONS
*"      T_INC_NOT_EXIST
*"      T_INC_NOT_ACTIVE
*"      M_INC_NOT_ACTIVE
*"      T_TAB_NOT_ACTIVE
*"      SYSTEM_INCONSISTENT
*"----------------------------------------------------------------------

  DATA: SUBRC TYPE SY-SUBRC,
        DD02V_WA TYPE DD02V,
        DD03P_TAB TYPE DD03P OCCURS 20 WITH HEADER LINE,
        INCLUDED(1) TYPE C,
        GOTSTATE LIKE DCOBJIF-GOTSTATE.

* Prüfe, ob T_INCLUDE strukturell mit M_INCLUDE übereinstimmt

  CALL FUNCTION 'BC430_COMP_AND_FILL'
       EXPORTING
            T_TAB               = T_INCLUDE
            M_TAB               = M_INCLUDE
            FILL                = 'N'
       TABLES
            ERRORS              = TEMP_ERRORS
       EXCEPTIONS
            T_TAB_NOT_EXIST     = 1
            T_TAB_NOT_ACTIVE    = 2
            M_TAB_NOT_ACTIVE    = 3
            SYSTEM_INCONSISTENT = 4
            OTHERS              = 5.

  IF SY-SUBRC <> 0.
    SUBRC = SY-SUBRC.
    CASE SUBRC.
      WHEN '1'.
        RAISE T_INC_NOT_EXIST.
      WHEN '2'.
        RAISE T_INC_NOT_ACTIVE.
      WHEN '3'.
        RAISE M_INC_NOT_ACTIVE.
      WHEN '4'.
        RAISE SYSTEM_INCONSISTENT.
      WHEN '5'.
        RAISE SYSTEM_INCONSISTENT.
    ENDCASE.
  ELSE.
    IF NOT TEMP_ERRORS IS INITIAL.
      ERRORS-TABNAME = T_INCLUDE.
      ERRORS-ERROR = 'FIELD_STR'.
      APPEND ERRORS.
    ENDIF.
  ENDIF.

* Prüfe, ob T_INCLUDE den korrekten Typ (Include,
* Append) hat.

  CALL FUNCTION 'DDIF_TABL_GET'
       EXPORTING
            NAME          = T_INCLUDE
            STATE         = 'A'
*         LANGU         = ' '
       IMPORTING
*         GOTSTATE      =
            DD02V_WA      = DD02V_WA
*         DD09L_WA      =
*    TABLES
*         DD03P_TAB     =
*         DD05M_TAB     =
*         DD08V_TAB     =
*         DD12V_TAB     =
*         DD17V_TAB     =
*         DD35V_TAB     =
*         DD36M_TAB     =
       EXCEPTIONS
            ILLEGAL_INPUT = 1
            OTHERS        = 2.

  IF SY-SUBRC <> 0.
    RAISE SYSTEM_INCONSISTENT.
  ENDIF.

  IF INC_TYPE = 'INCLUDE'.
    IF DD02V_WA-TABCLASS NE 'INTTAB'.
      ERRORS-TABNAME = T_INCLUDE.
      ERRORS-ERROR = 'SHOULD_BE_INCLUDE'.
      APPEND ERRORS.
    ENDIF.
  ELSEIF INC_TYPE = 'APPEND'.
    IF DD02V_WA-TABCLASS NE 'APPEND'.
      ERRORS-TABNAME = T_INCLUDE.
      ERRORS-ERROR = 'SHOULD_BE_APPEND'.
      APPEND ERRORS.
    ENDIF.
  ELSE.                                "Falscher Aufruf der Fkt.
    RAISE SYSTEM_INCONSISTENT.
  ENDIF.

* Prüfe, ob T_INCLUDE in T_TAB inkludiert/appendiert ist. Dafür wird
* T_TAB gelesen und geprüft, ob T_INCLUDE irgendwo in DD03P-PRECFIELD
* auftaucht.

  CALL FUNCTION 'DDIF_TABL_GET'
       EXPORTING
            NAME          = T_TAB
            STATE         = 'A'
*         LANGU         = ' '
       IMPORTING
            GOTSTATE      = GOTSTATE
*         DD02V_WA      =
*         DD09L_WA      =
       TABLES
            DD03P_TAB     = DD03P_TAB
*         DD05M_TAB     =
*         DD08V_TAB     =
*         DD12V_TAB     =
*         DD17V_TAB     =
*         DD35V_TAB     =
*         DD36M_TAB     =
       EXCEPTIONS
            ILLEGAL_INPUT = 1
            OTHERS        = 2.

  IF SY-SUBRC <> 0.
    RAISE SYSTEM_INCONSISTENT.
  ENDIF.
  IF GOTSTATE = ' '.
    RAISE T_TAB_NOT_ACTIVE.
  ENDIF.

  INCLUDED = 'N'.
  LOOP AT DD03P_TAB.
    IF DD03P_TAB-PRECFIELD = T_INCLUDE.
      INCLUDED = 'Y'.
    ENDIF.
  ENDLOOP.

  IF INCLUDED = 'N'.
    ERRORS-TABNAME = T_INCLUDE.
    ERRORS-ERROR = 'NOT_INCLUDED'.
    APPEND ERRORS.
  ENDIF.

ENDFUNCTION.
