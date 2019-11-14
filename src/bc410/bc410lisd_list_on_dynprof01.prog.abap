*----------------------------------------------------------------------*
***BC410LISD_LIST_ON_DYNPROF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  READ_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_flights.

  SELECT * FROM sflight INTO CORRESPONDING FIELDS OF TABLE it_sflight
  WHERE carrid = wa_spfli-carrid
    AND connid = wa_spfli-connid.

ENDFORM.                               " READ_FLIGHTS


*---------------------------------------------------------------------*
*       FORM on_ctmenu_tc_menu                                        *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  p_menu                                                        *
*  -->  to                                                            *
*  -->  cl_ctmenu                                                     *
*---------------------------------------------------------------------*
FORM on_ctmenu_tc_menu USING p_menu TYPE REF TO cl_ctmenu.

  CALL METHOD cl_ctmenu=>load_gui_status
      EXPORTING program = sy-cprog
                status  = 'CT_STATUS'
                menu    = p_menu.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LIST_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM list_flights.

  LOOP AT it_sflight into wa_sflight.
    WRITE: / wa_sflight-carrid,
             wa_sflight-connid,
             wa_sflight-fldate,
             wa_sflight-planetype,
             wa_sflight-seatsmax,
             wa_sflight-seatsocc.
    hide wa_sflight.
  ENDLOOP.
ENDFORM.                               " LIST_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  READ_BOOKINGS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form read_bookings.

SELECT * INTO TABLE IT_SBOOK FROM SBOOK
  WHERE CARRID = wa_sflight-CARRID
    AND CONNID = wa_sflight-CONNID
    AND FLDATE = wa_sflight-FLDATE
    AND CANCELLED = space.

endform.                    " READ_BOOKINGS
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_BOOKINGS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY_BOOKINGS.

  LOOP AT IT_SBOOK INTO WA_SBOOK.


    WRITE: / WA_SBOOK-BOOKID,
             WA_SBOOK-CUSTOMID,
             WA_SBOOK-CUSTTYPE,
             WA_SBOOK-LUGGWEIGHT UNIT WA_SBOOK-WUNIT,
             WA_SBOOK-WUNIT,
             WA_SBOOK-CLASS,
             WA_SBOOK-ORDER_DATE,
             WA_SBOOK-CANCELLED.
    ENDLOOP.

ENDFORM.                    " DISPLAY_BOOKINGS


