*----------------------------------------------------------------------*
*   INCLUDE BC425_BOOKING_00E01                                        *
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*  START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

* create object of adapter class:
    call method cl_exithandler=>get_instance
             changing
                 instance = exit_book.

* Select Data from Table SBOOK:
  SELECT CARRID CONNID FLDATE BOOKID CUSTOMID ORDER_DATE
    FROM sbook
    INTO CORRESPONDING FIELDS OF TABLE itab_book
      WHERE carrid IN so_car AND
            connid IN so_con AND
            fldate IN so_fld.
  IF sy-subrc <> 0.
    WRITE: 'Keine Buchungsdaten vorhanden'(003).
  ENDIF.

  PERFORM data_output.
