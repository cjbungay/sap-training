*----------------------------------------------------------------------*
*   INCLUDE BC414S_BOOKINGS_06F02
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*   FORM ENQ_SFLIGHT
*----------------------------------------------------------------------*
FORM enq_sflight.
  CALL FUNCTION 'ENQUEUE_ESFLIGHT'
       EXPORTING
            carrid         = sdyn_conn-carrid
            connid         = sdyn_conn-connid
            fldate         = sdyn_conn-fldate
       EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.
  CASE sy-subrc.
    WHEN 0.
    WHEN 1.
      MESSAGE e060.
    WHEN OTHERS.
      MESSAGE e063 WITH sy-subrc.
  ENDCASE.
ENDFORM.                               "ENQ_SFLIGHT

*----------------------------------------------------------------------*
*   FORM ENQ_SBOOK
*----------------------------------------------------------------------*
FORM enq_sbook.
  CALL FUNCTION 'ENQUEUE_ESBOOK'
       EXPORTING
            carrid         = sdyn_book-carrid
            connid         = sdyn_book-connid
            fldate         = sdyn_book-fldate
            bookid         = sdyn_book-bookid
       EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.
  CASE sy-subrc.
    WHEN 0.
    WHEN 1.
      MESSAGE e061.
    WHEN OTHERS.
      MESSAGE e063 WITH sy-subrc.
  ENDCASE.
ENDFORM.                               "ENQ_SBOOK

*----------------------------------------------------------------------*
*   FORM ENQ_SFLIGHT_SBOOK
*----------------------------------------------------------------------*
FORM enq_sflight_sbook.
  CALL FUNCTION 'ENQUEUE_ESFLIGHT_SBOOK'
       EXPORTING
            carrid         = sdyn_conn-carrid
            connid         = sdyn_conn-connid
            fldate         = sdyn_conn-fldate
       EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.
  CASE sy-subrc.
    WHEN 0.
    WHEN 1.
      MESSAGE e062.
    WHEN OTHERS.
      MESSAGE e063 WITH sy-subrc.
  ENDCASE.
ENDFORM.                               "ENQ_SFLIGHT_SBOOK

*----------------------------------------------------------------------*
*   FORM DEQ_ALL
*----------------------------------------------------------------------*
FORM deq_all.
  CALL FUNCTION 'DEQUEUE_ALL'.
ENDFORM.                               "DEQ_ALL
