
class CL_BC412_MAPPING_4_2_TREE definition
  public
  final
  create public .

*" public components of class CL_BC412_MAPPING_4_2_TREE
*" do not include other source files here!!!
public section.


*" methods
methods:
  INSERT_BUSINESS_KEY
      importing
        value(I_BKEY1) type S_CARR_ID
        value(I_BKEY2) type S_CONN_ID
        value(I_BKEY3) type S_DATE
        value(I_BKEY4) type S_BOOK_ID
      exporting
        value(E_TKEY) type TV_NODEKEY
      exceptions
        INTERNAL_ERROR
        TECKEY_OVERFLOW
        INVALID_BUSKEY ,
  DELETE_BUSINESS_KEY
      importing
        value(I_BKEY1) type S_CARR_ID
        value(I_BKEY2) type S_CONN_ID
        value(I_BKEY3) type S_DATE
        value(I_BKEY4) type S_BOOK_ID
      exporting
        value(E_TKEY) type TV_NODEKEY
      exceptions
        INVALID_BUSKEY ,
  DELETE_TECHNICAL_KEY
      importing
        value(I_TKEY) type TV_NODEKEY
      exporting
        value(E_BKEY1) type S_CARR_ID
        value(E_BKEY2) type S_CONN_ID
        value(E_BKEY3) type S_DATE
        value(E_BKEY4) type S_BOOK_ID
      exceptions
        INVALID_TECKEY ,
  GET_BUSINESS_KEY
      importing
        value(I_TKEY) type TV_NODEKEY
      exporting
        value(E_BKEY1) type S_CARR_ID
        value(E_BKEY2) type S_CONN_ID
        value(E_BKEY3) type S_DATE
        value(E_BKEY4) type S_BOOK_ID
      exceptions
        INVALID_TECKEY ,
  GET_TECHNICAL_KEY
      importing
        value(I_BKEY1) type S_CARR_ID
        value(I_BKEY2) type S_CONN_ID
        value(I_BKEY3) type S_DATE
        value(I_BKEY4) type S_BOOK_ID
      exporting
        value(E_TKEY) type TV_NODEKEY
      exceptions
        INVALID_BUSKEY .
protected section.
*" protected components of class CL_BC412_MAPPING_4_2_TREE
*" do not include other source files here!!!


*" types
types:
  BUSKEY_1 type S_CARR_ID ,
  BUSKEY_2 type S_CONN_ID ,
  BUSKEY_3 type S_DATE ,
  BUSKEY_4 type S_BOOK_ID ,
  TECKEY type TV_NODEKEY .

*" instance attributes
data:
  MAP1 type BC412_MAP_HASH1 ,
  MAP2 type BC412_MAP_HASH2 .
private section.
*" private components of class CL_BC412_MAPPING_4_2_TREE
*" do not include other source files here!!!


*" instance attributes
data:
  COUNTER type I .
ENDCLASS.



CLASS CL_BC412_MAPPING_4_2_TREE IMPLEMENTATION.


method DELETE_BUSINESS_KEY.
* to be implemented
endmethod.


method DELETE_TECHNICAL_KEY.
* to be implemented
endmethod.


method GET_BUSINESS_KEY.
* local data
  data: wa_map type bc412_map_linetype.

* read entry
  read table map2 into wa_map with table key
    tkey = i_tkey.
  if sy-subrc ne 0.
    raise invalid_teckey.
  endif.

  e_bkey1 = wa_map-bkey1.  " return business key (1)
  e_bkey2 = wa_map-bkey2.  " return business key (2)
  e_bkey3 = wa_map-bkey3.  " return business key (3)
  e_bkey4 = wa_map-bkey4.  " return business key (4)


endmethod.


method GET_TECHNICAL_KEY.
* local data
  data: wa_map type bc412_map_linetype.

* read entry
  read table map1 into wa_map with table key
    bkey1 = i_bkey1
    bkey2 = i_bkey2
    bkey3 = i_bkey3
    bkey4 = i_bkey4.
  if sy-subrc ne 0.
    raise invalid_buskey.
  endif.

  e_tkey = wa_map-tkey.  " return technical key
endmethod.


METHOD insert_business_key.
* local data
  DATA: wa_map TYPE bc412_map_linetype.

* existence check: valid key
  READ TABLE map1 WITH TABLE KEY
    bkey1 = i_bkey1
    bkey2 = i_bkey2
    bkey3 = i_bkey3
    bkey4 = i_bkey4
    TRANSPORTING NO FIELDS.

  IF sy-subrc EQ 0.                    " entry exists already
    RAISE invalid_buskey.
  ENDIF.

* check for overflow of e_tkey
  IF counter GE 999999999999.
    RAISE teckey_overflow.
  ENDIF.

* note: maximum number to be hadled restricted by data type of
*       tv_nodekey (CHAR 12)

* create new entry
  ADD 1 TO counter.
  wa_map-bkey1 = i_bkey1.
  wa_map-bkey2 = i_bkey2.
  wa_map-bkey3 = i_bkey3.
  wa_map-bkey4 = i_bkey4.
  wa_map-tkey  = counter.
  e_tkey       = counter.              " return technical key

  INSERT wa_map INTO TABLE map1.
  IF sy-subrc NE 0.
    RAISE internal_error.
  ENDIF.

  INSERT wa_map INTO TABLE map2.
  IF sy-subrc NE 0.
    raise internal_error.
  ENDIF.

ENDMETHOD.
ENDCLASS.
