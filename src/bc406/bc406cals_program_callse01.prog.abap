*----------------------------------------------------------------------*
*   INCLUDE     SAPBC406cals_programs_callsE01
**----------------------------------------------------------------------
*
*&---------------------------------------------------------------------*
*&   Event INITIALIZATION
*&---------------------------------------------------------------------*
INITIALIZATION.
  tab1 =  text-tl1.
* Flight Connection
  tab2 =  text-tl2.
* Flight Date
  tab3 =  text-tl3.
* Flight Type

*&---------------------------------------------------------------------*
*&   Event AT SELECTION-SCREEN
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN.
  CASE sy-dynnr.
    WHEN '1000' OR '1100' OR '1200' OR '1300'.
      AUTHORITY-CHECK OBJECT 'S_CARRID'
               ID 'CARRID' FIELD pa_car
               ID 'ACTVT' FIELD '03'.
      IF sy-subrc NE 0.
        MESSAGE e001 WITH pa_car.
*   No authorization for airline carrier &
      ENDIF.
  ENDCASE.

AT SELECTION-SCREEN ON RADIOBUTTON GROUP rbg1.
  IF pa_nat = 'X'.
    CALL SELECTION-SCREEN 1400 STARTING AT 20 5 ENDING AT 70 10.
    IF sy-subrc NE 0.
      MESSAGE e060(bc406).
    ENDIF.
  ENDIF.

*&---------------------------------------------------------------------*
*&   Event AT START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM read_flights.

*&---------------------------------------------------------------------*
*&   Event AT END-OF-SELECTION
*&---------------------------------------------------------------------*
END-OF-SELECTION.
  PERFORM display_flights.

* set titlebar and gui-status as late as possible
  SET TITLEBAR 'T_BASE'.
  SET PF-STATUS 'S_BASE'.
*  CLEAR: wa_flight-fldate.

*&---------------------------------------------------------------------*
*&   Event AT USER-COMMAND
*&---------------------------------------------------------------------*

AT USER-COMMAND.
  CASE sy-ucomm.
    WHEN 'BOOK'.
*      CHECK NOT wa_flight-fldate IS INITIAL.
      REFRESH it_sbook.
      DO.
        READ LINE sy-index FIELD VALUE mark.
        IF sy-subrc NE 0. EXIT. ENDIF.
        CHECK NOT mark IS INITIAL.
        PERFORM read_bookings
               USING    wa_flight-carrid
                        wa_flight-connid
                        wa_flight-fldate
                        not_cancelled
               CHANGING it_sbook.
      ENDDO.

      SORT it_sbook BY carrid connid fldate bookid.

      PERFORM display_bookings.

      SET PF-STATUS 'S_BOOK'.
      SET TITLEBAR 'T_BOOK'.
*      CLEAR: wa_flight-fldate.
    WHEN 'SELECT'.
      DO.
        READ LINE sy-index.
        IF sy-subrc NE 0. EXIT. ENDIF.
        MODIFY CURRENT LINE FIELD VALUE mark FROM selected.
      ENDDO.
    WHEN 'DESELECT'.
      DO.
        READ LINE sy-index.
        IF sy-subrc NE 0. EXIT. ENDIF.
        MODIFY CURRENT LINE FIELD VALUE mark FROM space.
      ENDDO.
    WHEN 'SRTU'.
      CHECK NOT wa_sbook-bookid IS INITIAL.
      GET CURSOR FIELD fieldname.
      IF sy-subrc  = 0.
        fieldname = fieldname+9.
        SORT it_sbook BY carrid connid fldate (fieldname).
        PERFORM display_bookings.
        sy-lsind = sy-lsind - 1.
      ENDIF.
    WHEN 'SRTD'.
      CHECK NOT wa_sbook-bookid IS INITIAL.
      GET CURSOR FIELD fieldname.
      IF sy-subrc  = 0.
        fieldname = fieldname+9.
        SORT it_sbook BY carrid connid fldate (fieldname) DESCENDING.
        PERFORM display_bookings.
        sy-lsind = sy-lsind - 1.
      ENDIF.
    WHEN 'CONN_LIST'.
      REFRESH connids.
      connids-sign = 'I'.
      connids-option = 'EQ'.
      DO.
        READ LINE sy-index FIELD VALUE mark.
        IF sy-subrc NE 0. EXIT. ENDIF.
        CHECK NOT mark IS INITIAL.
        connids-low = wa_flight-connid.
        APPEND connids.
      ENDDO.
      DESCRIBE TABLE connids LINES line_count.
      IF NOT line_count IS INITIAL.
        SUBMIT sapbc406cals_airline_list AND RETURN
                WITH pa_car = wa_flight-carrid
                WITH so_conn IN connids.
      ENDIF.
    WHEN 'CUST_TRANS'.
      CHECK NOT wa_sbook-customid IS INITIAL.
      SET PARAMETER ID 'CSM' FIELD wa_sbook-customid.
      CALL TRANSACTION 'BC406_CUST_TRANS' AND SKIP FIRST SCREEN.
      CLEAR wa_sbook-customid.
  ENDCASE.

*&---------------------------------------------------------------------*
*&   Event TOP-OF-PAGE DURING LINE-SELECTION
*&---------------------------------------------------------------------*

TOP-OF-PAGE DURING LINE-SELECTION.
  CASE sy-ucomm.
    WHEN 'BOOK' OR 'SRTU' OR 'SRTD'.
      FORMAT COLOR COL_HEADING.
      ULINE.
      WRITE: / 'Flight:'(t01), wa_sbook-carrid, wa_sbook-connid,
                AT sy-linsz space,
             / 'Date:'(t02), wa_sbook-fldate, AT sy-linsz space.
      ULINE.
  ENDCASE.
