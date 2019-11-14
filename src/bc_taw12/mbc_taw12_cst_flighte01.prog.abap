*----------------------------------------------------------------------*
*   INCLUDE     MBC410TABS_TABLE_CONTROL3E01                          *
*----------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&   Event AT USER-COMMAND
*&---------------------------------------------------------------------*

AT USER-COMMAND.
  CASE sy-ucomm.
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
  ENDCASE.

*&---------------------------------------------------------------------*
*&   Event TOP-OF-PAGE DURING LINE-SELECTION
*&---------------------------------------------------------------------*

TOP-OF-PAGE DURING LINE-SELECTION.
  CASE sy-ucomm.
    WHEN 'SRTU' OR 'SRTD'.
      FORMAT COLOR COL_HEADING.
      ULINE.
      WRITE: / 'Flight:'(t01), wa_sbook-carrid, wa_sbook-connid,
                AT sy-linsz space,
             / 'Date:'(t02), wa_sbook-fldate, AT sy-linsz space.
      ULINE.
  ENDCASE.
*&---------------------------------------------------------------------*
*&   Event load-of-program
*&---------------------------------------------------------------------*
LOAD-OF-PROGRAM.
  GET PARAMETER ID: 'CAR' FIELD wa_sflight-carrid,
                    'CON' FIELD wa_sflight-connid,
                    'DAY' FIELD wa_sflight-fldate.

  AUTHORITY-CHECK OBJECT 'S_CARRID'
           ID 'CARRID' FIELD wa_sflight-carrid
           ID 'ACTVT' FIELD '03'.
  IF sy-subrc = 0.
    SELECT SINGLE * FROM sflight INTO wa_sflight
       WHERE carrid = wa_sflight-carrid
         AND connid = wa_sflight-connid
         AND fldate = wa_sflight-fldate.
  ELSE.
    MESSAGE i045 WITH wa_sflight-carrid.
  ENDIF.
