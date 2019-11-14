*----------------------------------------------------------------------*
*   INCLUDE BC414S_BOOKINGS_04F03
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  READ_SFLIGHT
*&---------------------------------------------------------------------*
*      -->P_WA_SFLIGHT  text
*      -->P_SYSUBRC     text
*----------------------------------------------------------------------*
FORM read_sflight USING p_wa_sflight TYPE sflight
                        p_sysubrc LIKE sy-subrc.
  SELECT SINGLE * FROM sflight INTO p_wa_sflight
         WHERE carrid = sdyn_conn-carrid
         AND   connid = sdyn_conn-connid
         AND   fldate = sdyn_conn-fldate.
  p_sysubrc = sy-subrc.
ENDFORM.                               " READ_SFLIGHT

*&---------------------------------------------------------------------*
*&      Form  READ_SBOOK
*&---------------------------------------------------------------------*
*      -->P_ITAB_BOOK  text
*      -->P_ITAB_CD    text
*----------------------------------------------------------------------*
FORM read_sbook USING p_itab_book LIKE itab_book
                      p_itab_cd   LIKE itab_cd.
  TYPES: BEGIN OF wa_custom_type,
           id TYPE scustom-id,
           name TYPE scustom-name,
         END OF wa_custom_type.
  DATA: wa_custom TYPE wa_custom_type,
        itab_custom TYPE STANDARD TABLE OF wa_custom_type
        WITH NON-UNIQUE KEY id,
        wa_book LIKE LINE OF p_itab_book,
        wa_cd   LIKE LINE OF p_itab_cd.
  CLEAR: p_itab_book, p_itab_cd.
  SELECT id name FROM scustom INTO CORRESPONDING FIELDS
         OF TABLE itab_custom.
  SELECT * FROM sbook INTO CORRESPONDING FIELDS OF TABLE p_itab_book
         WHERE carrid = sdyn_conn-carrid
         AND   connid = sdyn_conn-connid
         AND   fldate = sdyn_conn-fldate.
  LOOP AT p_itab_book INTO wa_book.
    READ TABLE itab_custom INTO wa_custom WITH TABLE KEY
                                            id = wa_book-customid.
    wa_book-name = wa_custom-name.
    MODIFY p_itab_book FROM wa_book.
    MOVE-CORRESPONDING wa_book TO wa_cd.
    APPEND wa_cd TO p_itab_cd.
  ENDLOOP.
  SORT p_itab_book BY bookid customid.
ENDFORM.                               " READ_SBOOK

*&---------------------------------------------------------------------*
*&      Form  READ_SPFLI
*&---------------------------------------------------------------------*
*      -->P_WA_SPFLI  text
*----------------------------------------------------------------------*
FORM read_spfli USING p_wa_spfli TYPE spfli.
  SELECT SINGLE * FROM spfli INTO p_wa_spfli
         WHERE carrid = sdyn_conn-carrid
         AND   connid = sdyn_conn-connid.
  IF sy-subrc <> 0.
    PERFORM deq_all.
    MESSAGE e022 WITH sdyn_conn-carrid sdyn_conn-connid.
  ENDIF.
ENDFORM.                               " READ_SPFLI
