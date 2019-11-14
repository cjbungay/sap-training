*----------------------------------------------------------------------*
*   INCLUDE BC412_MAPPING_521_1LCL                                     *
*----------------------------------------------------------------------*


*---------------------------------------------------------------------*
*       CLASS lcl_mapping_4to_tree_1 DEFINITION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_mapping_4to_tree_1 DEFINITION.
  PUBLIC SECTION.
*   mapping of business types to class internal types
    TYPES: buskey_1 TYPE s_carr_id,    " Carrier id     (CARRID)
           buskey_2 TYPE s_conn_id,    " Connection id  (CONNID)
           buskey_3 TYPE s_date,       " Flight date    (FLDATE)
           buskey_4 TYPE S_BOOK_ID,    " Book id        (BOOKID)
           teckey   TYPE tv_nodekey.   " node key       (NODE_KEY)
    METHODS:
*   create an entry for a new business key
             insert_business_key
                IMPORTING
                  i_bkey1 TYPE buskey_1
                  i_bkey2 TYPE buskey_2
                  i_bkey3 TYPE buskey_3
                  i_bkey4 TYPE buskey_4
                EXPORTING
                  e_tkey  TYPE teckey
                EXCEPTIONS
                  internal_error
                  teckey_overflow
                  invalid_buskey,      " entry already in table

             delete_business_key
                IMPORTING
                  i_bkey1 TYPE buskey_1
                  i_bkey2 TYPE buskey_2
                  i_bkey3 TYPE buskey_3
                  i_bkey4 TYPE buskey_4
                EXPORTING
                  e_tkey  TYPE teckey
                EXCEPTIONS
                  invalid_buskey,      " entry not in table

             delete_technical_key
                IMPORTING
                  i_tkey  TYPE teckey
                EXPORTING
                  e_bkey1 TYPE buskey_1
                  e_bkey2 TYPE buskey_2
                  e_bkey3 TYPE buskey_3
                  e_bkey4 TYPE buskey_4
                EXCEPTIONS
                  invalid_teckey,      " entry not in table

             get_business_key
                IMPORTING
                  i_tkey  TYPE teckey
                EXPORTING
                  e_bkey1 TYPE buskey_1
                  e_bkey2 TYPE buskey_2
                  e_bkey3 TYPE buskey_3
                  e_bkey4 TYPE buskey_4
                EXCEPTIONS
                  invalid_teckey,      " entry not in table

             get_technical_key
                IMPORTING
                  i_bkey1 TYPE buskey_1
                  i_bkey2 TYPE buskey_2
                  i_bkey3 TYPE buskey_3
                  i_bkey4 TYPE buskey_4
                EXPORTING
                  e_tkey   TYPE teckey
                EXCEPTIONS
                  invalid_buskey.      " entry not in table
  PRIVATE SECTION.
*   linetype
    TYPES: BEGIN OF linetype,
             bkey1  TYPE buskey_1,
             bkey2  TYPE buskey_2,
             bkey3  TYPE buskey_3,
             bkey4  TYPE buskey_4,
             tkey   TYPE teckey,
           END OF linetype.
*   internal tables
*   i)  map1 used for: business key  --> technical key
    DATA: map1 TYPE HASHED TABLE OF linetype
            WITH UNIQUE KEY bkey1 bkey2 bkey3 bkey4.
*   ii) map2 used for: technical key --> business key
    DATA: map2 TYPE HASHED TABLE OF linetype
            WITH UNIQUE KEY tkey.
*   counter for assignment of technical keys
    DATA: counter TYPE i.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_mapping_4to1_tree_1 IMPLEMENTATION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_mapping_4to_tree_1 IMPLEMENTATION.
  METHOD insert_business_key.
*   local data
    DATA: wa_map TYPE linetype.

*   existence check: valid key
    READ TABLE map1 WITH TABLE KEY
        bkey1 = i_bkey1
        bkey2 = i_bkey2
        bkey3 = i_bkey3
        bkey4 = i_bkey4
        TRANSPORTING NO FIELDS.
    IF sy-subrc EQ 0.            " entry exists, no new entry possible
      RAISE invalid_buskey.
    ENDIF.
*   check for overflow of e_tkey
    IF counter GE 999999999999.        " greater should not occur
      RAISE teckey_overflow.           " maximim number of entries to be
    ENDIF.                             " handled restricted by type of
                                       " tv_nodekey (CHAR 12)
*   create new entry
    ADD 1 TO counter.

    wa_map-bkey1 = i_bkey1.
    wa_map-bkey2 = i_bkey2.
    wa_map-bkey3 = i_bkey3.
    wa_map-bkey4 = i_bkey4.
    wa_map-tkey  = counter.
    e_tkey       = counter.            " return technical key

    INSERT wa_map INTO TABLE map1.
    IF sy-subrc NE 0.
      RAISE internal_error.
    ENDIF.

    INSERT wa_map INTO TABLE map2.
    IF sy-subrc NE 0.
      RAISE internal_error.
    ENDIF.

  ENDMETHOD.

  METHOD delete_business_key.
*   to be implemented
  ENDMETHOD.

  METHOD delete_technical_key.
*   to be implemented
  ENDMETHOD.

  METHOD get_business_key.
*   local data
    DATA: wa_map TYPE linetype.

*   read entry
    READ TABLE map2 INTO wa_map WITH TABLE KEY
           tkey  = i_tkey.
    IF sy-subrc NE 0.
      RAISE invalid_teckey.
    ENDIF.

    e_bkey1 = wa_map-bkey1.    " return business key (1)
    e_bkey2 = wa_map-bkey2.    "                     (2)
    e_bkey3 = wa_map-bkey3.    "                     (3)
    e_bkey4 = wa_map-bkey4.    "                     (4)
  ENDMETHOD.

  METHOD get_technical_key.
*   local data
    DATA: wa_map TYPE linetype.

*   read entry
    READ TABLE map1 INTO wa_map WITH TABLE KEY
           bkey1  = i_bkey1
           bkey2  = i_bkey2
           bkey3  = i_bkey3
           bkey4  = i_bkey4.
    IF sy-subrc NE 0.
      RAISE invalid_buskey.
    ENDIF.

    e_tkey  = wa_map-tkey.     " return technical key

  ENDMETHOD.
ENDCLASS.
