*----------------------------------------------------------------------*
*   INCLUDE BC410INPS_INPUT_FIELDE01                                   *
*----------------------------------------------------------------------*

START-OF-SELECTION.
  PERFORM READ_FLIGHTS.

END-OF-SELECTION.
  PERFORM DISPLAY_FLIGHTS.
  SET PF-STATUS 'BASE'.
  SET TITLEBAR 'BASE'.
  CLEAR WA_SFLIGHT-CARRID.

*&---------------------------------------------------------------------*
*&   Event AT USER-COMMAND
*&---------------------------------------------------------------------*
AT USER-COMMAND.
  CASE SY-UCOMM.
    WHEN 'BOOK'.
      CHECK NOT WA_SFLIGHT-CARRID IS INITIAL.
      REFRESH IT_SBOOK.
      DO.
        READ LINE SY-INDEX FIELD VALUE MARK.
        IF SY-SUBRC NE 0. EXIT. ENDIF.
        CHECK NOT MARK IS INITIAL.
          PERFORM READ_BOOKINGS
                   USING WA_SFLIGHT-CARRID
                         WA_SFLIGHT-CONNID
                         WA_SFLIGHT-FLDATE
                         ' '.
          APPEND LINES OF IT_SBOOK_READ TO IT_SBOOK.
      ENDDO.
      SORT IT_SBOOK BY CARRID CONNID FLDATE BOOKID.
      PERFORM DISPLAY_BOOKINGS.
      SET PF-STATUS 'BOOK'.
      SET TITLEBAR 'BOOK'.
      CLEAR: WA_SFLIGHT-CARRID,
             WA_SBOOK-BOOKID.
    WHEN 'SELECT'.
      DO.
        READ LINE SY-INDEX.
        IF SY-SUBRC NE 0. EXIT. ENDIF.
        MODIFY CURRENT LINE FIELD VALUE MARK FROM 'X'.
      ENDDO.
    WHEN 'DESELECT'.
      DO.
        READ LINE SY-INDEX.
        IF SY-SUBRC NE 0. EXIT. ENDIF.
        MODIFY CURRENT LINE FIELD VALUE MARK FROM SPACE.
      ENDDO.
    WHEN 'SRTU'.
      CHECK NOT WA_SBOOK-BOOKID IS INITIAL.
        GET CURSOR FIELD FIELDNAME.
        FIELDNAME = FIELDNAME+9.
        SORT IT_SBOOK BY CARRID CONNID FLDATE (FIELDNAME).
        PERFORM DISPLAY_BOOKINGS.
        SY-LSIND = SY-LSIND - 1.
        CLEAR WA_SBOOK-BOOKID.
    WHEN 'SRTD'.
      CHECK NOT WA_SBOOK-BOOKID IS INITIAL.
        GET CURSOR FIELD FIELDNAME.
        FIELDNAME = FIELDNAME+9.
        SORT IT_SBOOK BY CARRID CONNID FLDATE (FIELDNAME) DESCENDING.
        PERFORM DISPLAY_BOOKINGS.
        SY-LSIND = SY-LSIND - 1.
        CLEAR WA_SBOOK-BOOKID.

  ENDCASE.

TOP-OF-PAGE DURING LINE-SELECTION.
  CHECK SY-UCOMM = 'BOOK' OR SY-UCOMM = 'SRTD' OR SY-UCOMM = 'SRTU'.
  FORMAT COLOR COL_HEADING.
  ULINE.
  WRITE: / 'Flight:'(T01), WA_SBOOK-CARRID, WA_SBOOK-CONNID,
            AT SY-LINSZ SPACE,
         / 'Date:'(T02), WA_SBOOK-FLDATE, AT SY-LINSZ SPACE.
  ULINE.
*&---------------------------------------------------------------------*
*&   Event AT LINE-SELECTION.
*&---------------------------------------------------------------------*
AT LINE-SELECTION.
   CALL SCREEN 100.
