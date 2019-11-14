*----------------------------------------------------------------------*
*& Include BC425_TAVARF01
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  PROCESS_BACK
*&---------------------------------------------------------------------*
*       Process ok code BACK for all subsequent screens
*----------------------------------------------------------------------*
FORM process_back.

  IF save_ok = 'BACK'.
    LEAVE TO SCREEN 100.
  ENDIF.

ENDFORM.                               " PROCESS_BACK

*&---------------------------------------------------------------------*
*&      Form  FILL_ITAB
*&---------------------------------------------------------------------*
*       Call BAPI to get a list of flights
*----------------------------------------------------------------------*
FORM fill_itab.

  DATA  my_return TYPE bapiret2.       "Return structure for BAPI call

  CLEAR  itab.

  CASE checked.
    WHEN rb_aa.
      sdyn_conn-carrid = 'AA'.
    WHEN rb_lh.
      sdyn_conn-carrid = 'LH'.
    WHEN OTHERS.
      CLEAR sdyn_conn-carrid.
  ENDCASE.

  CALL FUNCTION 'BAPI_SFLIGHT_GETLIST'
       EXPORTING
            fromcountrykey = sdyn_conn-countryfr
            fromcity       = sdyn_conn-cityfrom
            tocountrykey   = sdyn_conn-countryto
            tocity         = sdyn_conn-cityto
            airlinecarrier = sdyn_conn-carrid
            afternoon      = sdyn_conn-mark
       IMPORTING
            return         = my_return
       TABLES
            flightlist     = itab.

* sy-subrc is always 0. However return-type may indicate an error.

  IF my_return-type <> ' ' AND my_return-type <> 'S'.
    MESSAGE ID     my_return-id
            TYPE   my_return-type
            NUMBER my_return-number
            WITH   my_return-message_v1 my_return-message_v2
                   my_return-message_v3 my_return-message_v4.

  ENDIF.

  line_first = 1.             "First visible line in step loop on 210
  DESCRIBE TABLE itab LINES my_tc-lines. " Last line for TableControl

ENDFORM.                               " FILL_ITAB

*&---------------------------------------------------------------------*
*&      Form  READ_ITAB
*&---------------------------------------------------------------------*
*       Get the selected line from the internal table
*----------------------------------------------------------------------*
FORM read_itab.

  DATA: line_sel LIKE sy-stepl.

  DATA  my_return TYPE bapiret2.       "Return structure for BAPI call

  IF line_itab IS INITIAL.
* Mark column not used
    GET CURSOR LINE line_sel.

    IF line_sel > 0.
* Use cursor postion for selecting (R/3 only, not ITS)

      IF sy-dynnr = 200.
        line_itab = my_tc-top_line + line_sel - 1.
      ELSE.
        line_itab = line_first + line_sel - 1.
      ENDIF.

    ELSE.
* No line selected
      MESSAGE s012(bc425).             "    Please mark one line
      LEAVE SCREEN.
    ENDIF.
  ENDIF.

  READ TABLE itab INDEX line_itab INTO wa.
  IF sy-subrc <> 0.
* illegal line number via input field on 210
    MESSAGE s012(bc425).               "    Please mark one line
    LEAVE SCREEN.
  ENDIF.

  CALL FUNCTION 'BAPI_SFLIGHT_GETDETAIL'
       EXPORTING
            airlinecarrier   = wa-carrid
            connectionnumber = wa-connid
            dateofflight     = wa-fldate
       IMPORTING
            return           = my_return
            flightdata       = my_flightdata.

* sy-subrc is always 0. However return-type may indicate an error.

  IF my_return-type <> ' ' AND my_return-type <> 'S'.
    MESSAGE ID     my_return-id
            TYPE   my_return-type
            NUMBER my_return-number
            WITH   my_return-message_v1 my_return-message_v2
                   my_return-message_v3 my_return-message_v4.

  ENDIF.

  MOVE-CORRESPONDING my_flightdata TO sdyn_conn.

  list_screen = sy-dynnr. "Remember if user wants to return to here.
  LEAVE TO SCREEN 300.

ENDFORM.                               " READ_ITAB

*&---------------------------------------------------------------------*
*&      Form  SPECIAL_OK_CODE
*&---------------------------------------------------------------------*
*       ITS synchronization
FORM special_ok_code.

* data: sync_itab ...

  IF save_ok(4) = 'AWSY'.

*---
* Implement synchronization here
*---

  ENDIF.

ENDFORM.                               " SPECIAL_OK_CODE

*&---------------------------------------------------------------------*
*&      Form  LOGON_AND_BOOK
*&---------------------------------------------------------------------*
*       Check userno and password
*       Book the flight (if possible)
*----------------------------------------------------------------------*
FORM logon_and_book.

  DATA  my_return TYPE bapiret2.       "Return structure for BAPI call


  DATA: my_bookingdata LIKE bapisbdeta,
        my_bookingdata_in LIKE bapisbdtin,
        temp LIKE sy-msgv1.

*---
* Check Customerno and password here!
*---

  MOVE-CORRESPONDING my_flightdata TO my_bookingdata_in.

  my_bookingdata_in-customid  = customernumber.
  my_bookingdata_in-class     = 'Y'.   " economy class
  my_bookingdata_in-agencynum = agencynum.

  CALL FUNCTION 'BAPI_SBOOK_CREATEFROMDATA'
       EXPORTING
            bookingdata_in = my_bookingdata_in
       IMPORTING
            return         = my_return
            bookingdata    = my_bookingdata.

* sy-subrc is always 0. However return-type may indicate an error.

  IF my_return-type <> 'S'.
    IF my_return-number = 155.         " flight booked out

      my_return-type = 'S'.
      MESSAGE ID     my_return-id
              TYPE   my_return-type
              NUMBER my_return-number
              WITH   my_return-message_v1
                     my_return-message_v2
                     my_return-message_v3
                     my_return-message_v4.

      PERFORM fill_itab.
      SET SCREEN list_screen.

    ELSE.

      MESSAGE ID     my_return-id
              TYPE   my_return-type
              NUMBER my_return-number
              WITH   my_return-message_v1
                     my_return-message_v2
                     my_return-message_v3
                     my_return-message_v4.
    ENDIF.

  ELSE.
    CONCATENATE my_bookingdata-carrid my_bookingdata-connid
                INTO temp.


    MESSAGE ID 'BC425'
              TYPE   'S'
              NUMBER '013'               " booking created
              WITH   my_bookingdata-customid
                      temp
                      my_bookingdata-fldate
                      my_bookingdata-bookid.


    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

    LEAVE TO SCREEN 100.

  ENDIF.

ENDFORM.                               " LOGON_AND_BOOK

*&---------------------------------------------------------------------*
*&      Form  SEND_CITIES_TO_ITS
*&---------------------------------------------------------------------*
*       Dynamic list of city for ITS
*----------------------------------------------------------------------*
FORM send_cities_to_its.

*---
* Send cities to ITS via RFC here
*
* DATA city LIKE sgeocity-city.
* SELECT city FROM sgeocity INTO city WHERE...
*---

ENDFORM.                               " SEND_CITIES_TO_ITS
