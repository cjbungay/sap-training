*----------------------------------------------------------------------*
*   INCLUDE BC414S_BOOKINGS_06F06
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  CREATE_CHANGE_DOCUMENTS
*&---------------------------------------------------------------------*
FORM create_change_documents.
  LOOP AT itab_sbook_modify INTO sbook.
* read unchanged data from buffer table into *-work area
    READ TABLE itab_cd FROM sbook INTO *sbook.
* define objectid from key fields of sbook
    CONCATENATE sbook-mandt sbook-carrid sbook-connid
                sbook-fldate sbook-bookid sbook-customid
                INTO objectid SEPARATED BY space.
* fill interface parameters for function call (which itself is
* encapsulated in form CD_CALL_BC_BOOK
    MOVE: sy-tcode        TO tcode,
          sy-uzeit        TO utime,
          sy-datum        TO udate,
          sy-uname        TO username,
          'U'             TO upd_sbook.
* perform calls the neccessary function to create change document
* 'in update task'
    PERFORM cd_call_bc_book.
  ENDLOOP.
ENDFORM.                               " CREATE_CHANGE_DOCUMENTS
