*&---------------------------------------------------------------------*
*& Report  SAPBC414D_ENQUEUE                                           *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  SAPBC414D_ENQUEUE             .
data: carrid type sflight-carrid,
      connid type sflight-connid,
      fldate type sflight-fldate.

get parameter ID 'CAR' field carrid.
get parameter ID 'CON' field connid.
get parameter ID 'DAY' field fldate.

CALL FUNCTION 'ENQUEUE_ESFLIGHT'
    EXPORTING
         CARRID         = carrid
         CONNID         = connid
         FLDATE         = fldate
    EXCEPTIONS
         FOREIGN_LOCK   = 1
         SYSTEM_FAILURE = 2
         OTHERS         = 3
          .
IF sy-subrc <> 0.
  write: / text-002, sy-subrc.
else.
write: / text-001.

ENDIF.
