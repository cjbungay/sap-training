*&---------------------------------------------------------------------*
*& Report  SAPBC401_TABD_COMPARE_READ_KEY                              *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Comparison of runtime behavior between                              *
*& - READ ... WITH TABLE KEY                                           *
*& - READ ... WITH KEY                                                 *
*& for different table types.                                          *
*& Used table types:                                                   *
*& - STANDARD TABLE WITH NON-UNIQUE KEY                                *
*& - SORTED   TABLE WITH NON-UNIQUE KEY                                *
*& - SORTED   TABLE WITH UNIQUE KEY                                    *
*& - HASHED   TABLE WITH UNIQUE KEY                                    *
*&                                                                     *
*& Implementation idea:                                                *
*& A STANDARD table is filled with data from sbook. The amount of data *
*& read can be selected on the standard selection screen.              *
*& A unique table entry is insert with the help of constants. This     *
*& entry is read later on. The insert position (first line, middle,    *
*& last line) can be selected on the standard selection screen.        *
*& The STANDARD table is copied to internal tables with the other      *
*& above listed table types.                                           *
*& Runtime is measured for the different table times for both          *
*& READ statements.                                                    *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc401_tabd_compare_read_key.

DATA:
* internal table
  it_st_sbook TYPE STANDARD TABLE OF sbook
    WITH NON-UNIQUE KEY carrid connid fldate bookid,

  it_so_u_sbook TYPE SORTED TABLE OF sbook
    WITH UNIQUE KEY carrid connid fldate bookid,

  it_so_n_sbook TYPE SORTED TABLE OF sbook
    WITH NON-UNIQUE KEY carrid connid fldate bookid,

  it_hs_sbook   TYPE HASHED TABLE OF sbook
    WITH UNIQUE KEY carrid connid fldate bookid,
* table work area
  wa_sbook      LIKE LINE OF it_st_sbook,
* result structure
  BEGIN OF wa_results,
    standard          TYPE i,
    sorted_unique     TYPE i,
    sorted_non_unique TYPE i,
    hashed            TYPE i,
  END OF wa_results,
* auxiliary
  insert_mode         TYPE i, " 1=first line, 2=middle, 3=last line
  data_mode           TYPE i. " 1=minimal,    2=medium, 3=maximal

CONSTANTS:
* "key" fields for data set to read
  c_carrid     TYPE s_carr_id VALUE 'LH ',
  c_connid     TYPE s_conn_id VALUE '0500',
  c_fldate     TYPE s_date    VALUE '20000630',
  c_bookid     TYPE s_book_id VALUE '90001234',
  c_custtype   TYPE s_custtype VALUE 'P',
* fields, that determine the data amount read
  c_sel_carrid TYPE s_carr_id VALUE 'LH ',
  c_sel_connid TYPE s_conn_id VALUE '0400',
* auxiliary
  c_selected TYPE c VALUE 'X'.

*********************************************************************
*                                                                   *
*    S E L E C T I O N    S C R E E N                               *
*                                                                   *
*********************************************************************

SELECTION-SCREEN BEGIN OF BLOCK test_frame WITH FRAME TITLE text-021.
PARAMETERS:
  pa TYPE i DEFAULT 500.               " number of repetitions
SELECTION-SCREEN END OF BLOCK test_frame.

SELECTION-SCREEN BEGIN OF BLOCK insert_row WITH FRAME TITLE text-020.
PARAMETERS:
  pa_a1 TYPE c RADIOBUTTON GROUP rad1, " insert as first line
  pa_a2 TYPE c RADIOBUTTON GROUP rad1, " insert in middle
  pa_a3 TYPE c RADIOBUTTON GROUP rad1. " insert as last  line
SELECTION-SCREEN END OF BLOCK insert_row.

SELECTION-SCREEN BEGIN OF BLOCK data_set WITH FRAME TITLE text-022.
PARAMETERS:
  pa_b1 TYPE c RADIOBUTTON GROUP rad2, " minimal amount of data
  pa_b2 TYPE c RADIOBUTTON GROUP rad2, " medium  amount of data
  pa_b3 TYPE c RADIOBUTTON GROUP rad2. " maximal amount of data
SELECTION-SCREEN END OF BLOCK data_set.

AT SELECTION-SCREEN.
* set insert_mode: where to insert the read line
  CASE c_selected.
    WHEN pa_a1.
      insert_mode = 1.  " insert as first line in standard table
    WHEN pa_a2.
      insert_mode = 2.  " insert in the middle of standard table
    WHEN pa_a3.
      insert_mode = 3.  " insert as last line in standard table
  ENDCASE.

* set data_mode: amount of data to read
  CASE c_selected.
    WHEN pa_b1.
      data_mode = 1.                   " minimal amount of data
    WHEN pa_b2.
      data_mode = 2.                   " medium  amount of data
    WHEN pa_b3.
      data_mode = 3.                   " maximal amount of data
  ENDCASE.

***********************************************************************
*                                                                     *
*  S T A R T    O F   M A I N   P R O G R A M                         *
*                                                                     *
***********************************************************************


START-OF-SELECTION.

  PERFORM fill_tables
    USING
      insert_mode
      data_mode
    CHANGING
      it_st_sbook
      it_so_u_sbook
      it_so_n_sbook
      it_hs_sbook.

*********************************************************************
*  W I T H    T A B L E    K E Y    k e y                           *
*********************************************************************

  WRITE: / 'WITH TABLE KEY'
            COLOR COL_KEY.

* read table WITH TABLE KEY: full qualified key
  PERFORM read_wtk_fqk
    USING
      pa
    CHANGING
      it_st_sbook
      it_so_u_sbook
      it_so_n_sbook
      it_hs_sbook
      wa_results.

  WRITE: /5  text-030 COLOR COL_TOTAL,
* (030) EN: 'full qualified key'
          40 '(carrid, connid, fldate, bookid)' COLOR COL_NORMAL.
  WRITE: /10 'STANDARD              :', wa_results-standard,
         /10 'SORTED, UNIQUE KEY    :', wa_results-sorted_unique,
         /10 'SORTED, NON-UNIQUE KEY:', wa_results-sorted_non_unique,
         /10 'HASHED                :', wa_results-hashed.


* read table WITH TABLE KEY: over or 'under' qualified key
* --> not possible: syntax check permits keys that are not
*                   full qualified

*********************************************************************
*  W I T H    K E Y    k e y                                        *
*********************************************************************
  WRITE: / 'WITH KEY'
            COLOR COL_KEY.

* read table WITH KEY: full qualified key
  PERFORM read_wk_fqk
    USING
      pa
    CHANGING
      it_st_sbook
      it_so_u_sbook
      it_so_n_sbook
      it_hs_sbook
      wa_results.

  WRITE: /5  text-030 COLOR COL_TOTAL,
* (030) EN: 'full qualified key'
          40 '(carrid, connid, fldate, bookid)' COLOR COL_NORMAL.
  WRITE: /10 'STANDARD              :', wa_results-standard,
         /10 'SORTED, UNIQUE KEY    :', wa_results-sorted_unique,
         /10 'SORTED, NON-UNIQUE KEY:', wa_results-sorted_non_unique,
         /10 'HASHED                :', wa_results-hashed.

* read table WITH KEY: over qualified key
  PERFORM read_wk_oqk
    USING
      pa
    CHANGING
      it_st_sbook
      it_so_u_sbook
      it_so_n_sbook
      it_hs_sbook
      wa_results.

  WRITE: /5  text-031 COLOR COL_TOTAL,
* (031) EN: 'over qualified key'
          40 '(carrid, connid, fldate, bookid, custtype)'
               COLOR COL_NORMAL.
  WRITE: /10 'STANDARD              :', wa_results-standard,
         /10 'SORTED, UNIQUE KEY    :', wa_results-sorted_unique,
         /10 'SORTED, NON-UNIQUE KEY:', wa_results-sorted_non_unique,
         /10 'HASHED                :', wa_results-hashed.

* read table WITH KEY: under qualified key
  PERFORM read_wk_uqk
    USING
      pa
    CHANGING
      it_st_sbook
      it_so_u_sbook
      it_so_n_sbook
      it_hs_sbook
      wa_results.

  WRITE: /5  text-032 COLOR COL_TOTAL,
* (032) EN: 'sub qualified key'
          40 '(carrid, connid, fldate)' COLOR COL_NORMAL.
  WRITE: /10 'STANDARD              :', wa_results-standard,
         /10 'SORTED, UNIQUE KEY    :', wa_results-sorted_unique,
         /10 'SORTED, NON-UNIQUE KEY:', wa_results-sorted_non_unique,
         /10 'HASHED                :', wa_results-hashed.

* read table WITH KEY: any key (carrid, bookid, custtype)
  PERFORM read_wk_anyk
    USING
      pa
    CHANGING
      it_st_sbook
      it_so_u_sbook
      it_so_n_sbook
      it_hs_sbook
      wa_results.

  WRITE: /5  text-033 COLOR COL_TOTAL,
* (033) EN: 'any key'
          40 '(carrid, bookid, custtype)' COLOR COL_NORMAL.
  WRITE: /10 'STANDARD              :', wa_results-standard,
         /10 'SORTED, UNIQUE KEY    :', wa_results-sorted_unique,
         /10 'SORTED, NON-UNIQUE KEY:', wa_results-sorted_non_unique,
         /10 'HASHED                :', wa_results-hashed.
************************************************************************
*                                                                      *
*  E N D   O F   M A I N   P R O G R A M                               *
*                                                                      *
************************************************************************

************************************************************************
*                                                                      *
*  F O R M    R O U T I N E S                                          *
*                                                                      *
************************************************************************

*&---------------------------------------------------------------------*
*&      Form  fill_tables
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MODE_I   1 = insert as first line
*                    2 = insert in middle
*                    3 = insert as last line
*                                                bookings of
*      -->P_MODE_D   1 = minimal amount of data ("LH", "0400")
*                    2 = medium  amount of data ("LH"        )
*                    3 = maximal amount of data ( all        )
*      <--P_IT_ST    standard table
*      <--P_IT_SO_U  sorted table with unique key
*      <--P_IT_SO_N  sorted table with non-unique key
*      <--P_IT_HS    hashed table
*----------------------------------------------------------------------*
FORM fill_tables USING    value(p_mode_i) TYPE i
                          value(p_mode_d) TYPE i
                 CHANGING p_it_st         LIKE it_st_sbook
                          p_it_so_u       LIKE it_so_u_sbook
                          p_it_so_n       LIKE it_so_n_sbook
                          p_it_hs         LIKE it_hs_sbook.
  DATA:
    wa    LIKE LINE OF p_it_st,
    index TYPE sy-tabix.

* read data from table sbook
  CASE p_mode_d.
    WHEN 1.
      SELECT * FROM sbook INTO CORRESPONDING FIELDS OF TABLE p_it_st
        WHERE carrid = 'LH'
        AND   connid = '0400'.
    WHEN 2.
      SELECT * FROM sbook INTO CORRESPONDING FIELDS OF TABLE p_it_st
        WHERE carrid = 'LH'.
    WHEN 3.
      SELECT * FROM sbook INTO CORRESPONDING FIELDS OF TABLE p_it_st.
  ENDCASE.

  FORMAT COLOR COL_KEY.
  WRITE: / text-034,
* (034) EN: 'number of lines in the tables'
           35 sy-dbcnt.
  WRITE: / text-035.
* (035) EN: 'insert line'

  CASE p_mode_i.
    WHEN 1.
      index = 1.
      WRITE: 35 text-036.              " <-- EN: 'as fist line'
    WHEN 2.
      index = sy-dbcnt DIV 2.
      WRITE: 35 text-037.              " <-- EN: 'in the middle'
    WHEN 3.
      index = sy-dbcnt + 1.
      WRITE: 35 text-038.              " <-- EN: 'as last line'
  ENDCASE.

  FORMAT COLOR COL_KEY OFF.
  SKIP.

* create extra entry = search entry
  wa-carrid   = c_carrid.
  wa-connid   = c_connid.
  wa-fldate   = c_fldate.
  wa-bookid   = c_bookid.
  wa-custtype = c_custtype.
  INSERT wa INTO p_it_st INDEX index.

  MOVE p_it_st TO: p_it_so_u,          " sorted unique key
                   p_it_so_n,          " sorted non-unique key
                   p_it_hs.            " hashed


ENDFORM.                               " fill_tables

*&---------------------------------------------------------------------*
*&      Form  read_wtk_fqk
*&---------------------------------------------------------------------*
*       READ TABLE ... WITH TABLE KEY key
*          key: full qualified key
*----------------------------------------------------------------------*
*      -->P_PA          number of repititions for run time measurement
*      <--P_IT_ST       standard table
*      <--P_IT_SO_U     sorted table with unique key
*      <--P_IT_SO_N     sorted table with non-unique key
*      <--P_IT_HS       hashed table
*      <--P_WA_RESULTS  work area with run time results
*----------------------------------------------------------------------*
FORM read_wtk_fqk USING    value(p_pa)         TYPE i
                  CHANGING p_it_st             LIKE it_st_sbook
                           p_it_so_u           LIKE it_so_u_sbook
                           p_it_so_n           LIKE it_so_n_sbook
                           p_it_hs             LIKE it_hs_sbook
                           value(p_wa_results) LIKE wa_results.
* local data
  DATA:
    wa       LIKE LINE OF p_it_st,
    rt_start TYPE i,
    rt_stop  TYPE i.

  DO p_pa TIMES.
*   standard
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_st   INTO wa TRANSPORTING NO FIELDS
      WITH TABLE KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate
                     bookid = c_bookid.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-standard.
    SUBTRACT rt_start FROM p_wa_results-standard.
    CLEAR: rt_start, rt_stop.

*   sorted with unique key
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_so_u INTO wa TRANSPORTING NO FIELDS
      WITH TABLE KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate
                     bookid = c_bookid.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-sorted_unique.
    SUBTRACT rt_start FROM p_wa_results-sorted_unique.
    CLEAR: rt_start, rt_stop.

*   sorted with non-unique key
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_so_n INTO wa TRANSPORTING NO FIELDS
      WITH TABLE KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate
                     bookid = c_bookid.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-sorted_non_unique.
    SUBTRACT rt_start FROM p_wa_results-sorted_non_unique.
    CLEAR: rt_start, rt_stop.

*   hashed
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_hs   INTO wa TRANSPORTING NO FIELDS
      WITH TABLE KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate
                     bookid = c_bookid.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-hashed.
    SUBTRACT rt_start FROM p_wa_results-hashed.
    CLEAR: rt_start, rt_stop.

  ENDDO.

  DIVIDE:
    p_wa_results-standard          BY p_pa,
    p_wa_results-sorted_unique     BY p_pa,
    p_wa_results-sorted_non_unique BY p_pa,
    p_wa_results-hashed            BY p_pa.

ENDFORM.                               " read_wtk_fqk

*&---------------------------------------------------------------------*
*&      Form  read_wk_fqk
*&---------------------------------------------------------------------*
*       READ TABLE ... WITH KEY key
*          key: full qualified key
*----------------------------------------------------------------------*
*      -->P_PA          number of repititions for run time measurement
*      <--P_IT_ST       standard table
*      <--P_IT_SO_U     sorted table with unique key
*      <--P_IT_SO_N     sorted table with non-unique key
*      <--P_IT_HS       hashed table
*      <--P_WA_RESULTS  work area with run time results
*----------------------------------------------------------------------*
FORM read_wk_fqk  USING    value(p_pa)         TYPE i
                  CHANGING p_it_st             LIKE it_st_sbook
                           p_it_so_u           LIKE it_so_u_sbook
                           p_it_so_n           LIKE it_so_n_sbook
                           p_it_hs             LIKE it_hs_sbook
                           value(p_wa_results) LIKE wa_results.
* local data
  DATA:
    wa       LIKE LINE OF p_it_st,
    rt_start TYPE i,
    rt_stop  TYPE i.

  DO p_pa TIMES.
*   standard
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_st   INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate
                     bookid = c_bookid.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-standard.
    SUBTRACT rt_start FROM p_wa_results-standard.
    CLEAR: rt_start, rt_stop.

*   sorted with unique key
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_so_u INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate
                     bookid = c_bookid.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-sorted_unique.
    SUBTRACT rt_start FROM p_wa_results-sorted_unique.
    CLEAR: rt_start, rt_stop.

*   sorted with non-unique key
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_so_n INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate
                     bookid = c_bookid.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-sorted_non_unique.
    SUBTRACT rt_start FROM p_wa_results-sorted_non_unique.
    CLEAR: rt_start, rt_stop.

*   hashed
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_hs   INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate
                     bookid = c_bookid.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-hashed.
    SUBTRACT rt_start FROM p_wa_results-hashed.
    CLEAR: rt_start, rt_stop.

  ENDDO.

  DIVIDE:
    p_wa_results-standard          BY p_pa,
    p_wa_results-sorted_unique     BY p_pa,
    p_wa_results-sorted_non_unique BY p_pa,
    p_wa_results-hashed            BY p_pa.

ENDFORM.                               " read_wk_fqk

*&---------------------------------------------------------------------*
*&      Form  read_wk_oqk
*&---------------------------------------------------------------------*
*       READ TABLE ... WITH KEY key
*          key: over qualified key
*----------------------------------------------------------------------*
*      -->P_PA          number of repititions for run time measurement
*      <--P_IT_ST       standard table
*      <--P_IT_SO_U     sorted table with unique key
*      <--P_IT_SO_N     sorted table with non-unique key
*      <--P_IT_HS       hashed table
*      <--P_WA_RESULTS  work area with run time results
*----------------------------------------------------------------------*
FORM read_wk_oqk  USING    value(p_pa)         TYPE i
                  CHANGING p_it_st             LIKE it_st_sbook
                           p_it_so_u           LIKE it_so_u_sbook
                           p_it_so_n           LIKE it_so_n_sbook
                           p_it_hs             LIKE it_hs_sbook
                           value(p_wa_results) LIKE wa_results.
* local data
  DATA:
    wa       LIKE LINE OF p_it_st,
    rt_start TYPE i,
    rt_stop  TYPE i.

  DO p_pa TIMES.
*   standard
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_st   INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate
                     bookid = c_bookid
                     custtype = c_custtype.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-standard.
    SUBTRACT rt_start FROM p_wa_results-standard.
    CLEAR: rt_start, rt_stop.

*   sorted with unique key
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_so_u INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate
                     bookid = c_bookid
                     custtype = c_custtype.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-sorted_unique.
    SUBTRACT rt_start FROM p_wa_results-sorted_unique.
    CLEAR: rt_start, rt_stop.

*   sorted with non-unique key
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_so_n INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate
                     bookid = c_bookid
                     custtype = c_custtype.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-sorted_non_unique.
    SUBTRACT rt_start FROM p_wa_results-sorted_non_unique.
    CLEAR: rt_start, rt_stop.

*   hashed
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_hs   INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate
                     bookid = c_bookid
                     custtype = c_custtype.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-hashed.
    SUBTRACT rt_start FROM p_wa_results-hashed.
    CLEAR: rt_start, rt_stop.

  ENDDO.

  DIVIDE:
    p_wa_results-standard          BY p_pa,
    p_wa_results-sorted_unique     BY p_pa,
    p_wa_results-sorted_non_unique BY p_pa,
    p_wa_results-hashed            BY p_pa.

ENDFORM.                               " read_wk_oqk

*&---------------------------------------------------------------------*
*&      Form  read_wk_uqk
*&---------------------------------------------------------------------*
*       READ TABLE ... WITH KEY key
*          key: under qualified key
*----------------------------------------------------------------------*
*      -->P_PA          number of repititions for run time measurement
*      <--P_IT_ST       standard table
*      <--P_IT_SO_U     sorted table with unique key
*      <--P_IT_SO_N     sorted table with non-unique key
*      <--P_IT_HS       hashed table
*      <--P_WA_RESULTS  work area with run time results
*----------------------------------------------------------------------*
FORM read_wk_uqk  USING    value(p_pa)         TYPE i
                  CHANGING p_it_st             LIKE it_st_sbook
                           p_it_so_u           LIKE it_so_u_sbook
                           p_it_so_n           LIKE it_so_n_sbook
                           p_it_hs             LIKE it_hs_sbook
                           value(p_wa_results) LIKE wa_results.
* local data
  DATA:
    wa       LIKE LINE OF p_it_st,
    rt_start TYPE i,
    rt_stop  TYPE i.

  DO p_pa TIMES.
*   standard
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_st   INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate.
*                     bookid = c_bookid.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-standard.
    SUBTRACT rt_start FROM p_wa_results-standard.
    CLEAR: rt_start, rt_stop.

*   sorted with unique key
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_so_u INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate.
*                     bookid = c_bookid.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-sorted_unique.
    SUBTRACT rt_start FROM p_wa_results-sorted_unique.
    CLEAR: rt_start, rt_stop.

*   sorted with non-unique key
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_so_n INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate.
*                     bookid = c_bookid.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-sorted_non_unique.
    SUBTRACT rt_start FROM p_wa_results-sorted_non_unique.
    CLEAR: rt_start, rt_stop.

*   hashed
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_hs   INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
                     connid = c_connid
                     fldate = c_fldate.
*                     bookid = c_bookid.
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-hashed.
    SUBTRACT rt_start FROM p_wa_results-hashed.
    CLEAR: rt_start, rt_stop.

  ENDDO.

  DIVIDE:
    p_wa_results-standard          BY p_pa,
    p_wa_results-sorted_unique     BY p_pa,
    p_wa_results-sorted_non_unique BY p_pa,
    p_wa_results-hashed            BY p_pa.

ENDFORM.                               " read_wk_uqk

*&---------------------------------------------------------------------*
*&      Form  read_wk_anyk
*&---------------------------------------------------------------------*
*       READ TABLE ... WITH KEY key
*          key: any key
*----------------------------------------------------------------------*
*      -->P_PA          number of repititions for run time measurement
*      <--P_IT_ST       standard table
*      <--P_IT_SO_U     sorted table with unique key
*      <--P_IT_SO_N     sorted table with non-unique key
*      <--P_IT_HS       hashed table
*      <--P_WA_RESULTS  work area with run time results
*----------------------------------------------------------------------*
FORM read_wk_anyk USING    value(p_pa)         TYPE i
                  CHANGING p_it_st             LIKE it_st_sbook
                           p_it_so_u           LIKE it_so_u_sbook
                           p_it_so_n           LIKE it_so_n_sbook
                           p_it_hs             LIKE it_hs_sbook
                           value(p_wa_results) LIKE wa_results.
* local data
  DATA:
    wa       LIKE LINE OF p_it_st,
    rt_start TYPE i,
    rt_stop  TYPE i.

  DO p_pa TIMES.
*   standard
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_st   INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
*                     connid = c_connid    " <-
*                     fldate = c_fldate    " <-
                     bookid = c_bookid
                     custtype = c_custtype." <-

    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-standard.
    SUBTRACT rt_start FROM p_wa_results-standard.
    CLEAR: rt_start, rt_stop.

*   sorted with unique key
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_so_u INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
*                     connid = c_connid    " <-
*                     fldate = c_fldate    " <-
                     bookid = c_bookid
                     custtype = c_custtype." <-
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-sorted_unique.
    SUBTRACT rt_start FROM p_wa_results-sorted_unique.
    CLEAR: rt_start, rt_stop.

*   sorted with non-unique key
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_so_n INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
*                     connid = c_connid    " <-
*                     fldate = c_fldate    " <-
                     bookid = c_bookid
                     custtype = c_custtype." <-
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-sorted_non_unique.
    SUBTRACT rt_start FROM p_wa_results-sorted_non_unique.
    CLEAR: rt_start, rt_stop.

*   hashed
    GET RUN TIME FIELD rt_start.       " <-- start
    READ TABLE p_it_hs   INTO wa TRANSPORTING NO FIELDS
      WITH       KEY carrid = c_carrid
*                     connid = c_connid    " <-
*                     fldate = c_fldate.   " <-
                     bookid = c_bookid
                     custtype = c_custtype." <-
    GET RUN TIME FIELD rt_stop.        " <-- stop

    ADD      rt_stop  TO   p_wa_results-hashed.
    SUBTRACT rt_start FROM p_wa_results-hashed.
    CLEAR: rt_start, rt_stop.

  ENDDO.

  DIVIDE:
    p_wa_results-standard          BY p_pa,
    p_wa_results-sorted_unique     BY p_pa,
    p_wa_results-sorted_non_unique BY p_pa,
    p_wa_results-hashed            BY p_pa.

ENDFORM.                               " read_wk_anyk
