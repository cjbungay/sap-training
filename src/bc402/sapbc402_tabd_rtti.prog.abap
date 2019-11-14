*&---------------------------------------------------------------------*
*& Report  SAPBC402_TABD_RTTI                                          *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc402_tabd_rtti .

TYPES:
  BEGIN OF line_type,
    carrid   TYPE sflight-carrid,
    connid   TYPE sflight-connid,
    fldate   TYPE sflight-fldate,
    seatsmax TYPE sflight-seatsmax,
    seatsocc TYPE sflight-seatsocc,
  END OF line_type,

  standard_ty TYPE STANDARD TABLE OF line_type
    WITH NON-UNIQUE KEY carrid connid,

  sorted_ty   TYPE SORTED TABLE OF line_type
    WITH NON-UNIQUE KEY carrid connid fldate,

  hashed_ty   TYPE HASHED TABLE OF line_type
    WITH UNIQUE KEY carrid connid fldate.

DATA:
  it_standard TYPE standard_ty,
  it_sorted TYPE sorted_ty,
  it_hashed TYPE hashed_ty.

START-OF-SELECTION.
  SELECT carrid connid fldate seatsmax seatsocc
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE it_hashed
*    WHERE carrid = 'LH'
    UP TO 20 ROWS.

  it_sorted = it_standard = it_hashed.


* standard
  PERFORM analyze_table_properties USING it_standard.
  SKIP 1.
  ULINE.
* sorted
  PERFORM analyze_table_properties USING it_sorted.
  SKIP 1.
  ULINE.
* hashed
  PERFORM analyze_table_properties USING it_hashed.
  SKIP 1.
  ULINE.


*---------------------------------------------------------------------*
*       FORM analyze_table_properties                                 *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM analyze_table_properties
     USING itab TYPE ANY TABLE.
* local data
  DATA:
    ref           TYPE REF TO cl_abap_tabledescr.
  FIELD-SYMBOLS:
    <key_comp_wa> TYPE abap_keydescr.

  ref ?= cl_abap_typedescr=>describe_by_data( itab ).

  data:
      lv_lines_count type i.

  lv_lines_count = lines( itab ).

  WRITE: /(50) text-002 COLOR COL_KEY, " number of lines
            52 ref->length
               COLOR COL_NORMAL.
  WRITE: /(50) text-003 COLOR COL_KEY, " table kind
            52 ref->table_kind
               COLOR COL_NORMAL.
  WRITE: /(50) text-004 COLOR COL_KEY, " initial size
            52 ref->initial_size
               COLOR COL_NORMAL.
  WRITE: /(50) text-005 COLOR COL_KEY, " key def kind
            52 ref->key_defkind
               COLOR COL_NORMAL.
  WRITE: /(50) text-006 COLOR COL_KEY, " has unique key
            52 ref->has_unique_key
               COLOR COL_NORMAL.
  WRITE: /(50) text-007 COLOR COL_KEY. " key components:

  LOOP AT ref->key ASSIGNING <key_comp_wa>.
    WRITE: /52 '->' COLOR COL_KEY,
               <key_comp_wa>-name
               COLOR COL_TOTAL.
  ENDLOOP.
ENDFORM.                    "analyze_table_properties
