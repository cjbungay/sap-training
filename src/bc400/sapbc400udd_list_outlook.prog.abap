*&---------------------------------------------------------------------*
*& Report  SAPBC400UDD_LIST_OUTLOOK                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   Interactive lists with input, window and modification             *
*&---------------------------------------------------------------------*

REPORT  sapbc400udd_list_outlook .

DATA: wa_spfli   TYPE spfli,
      wa_sflight TYPE sflight.

SELECT-OPTIONS: se_carr FOR wa_spfli-carrid,
                se_conn FOR wa_spfli-connid.

* Auxiliary fields for the line selection
DATA: markfield1, markfield2.


START-OF-SELECTION.

  SELECT carrid connid airpfrom cityfrom airpto cityto deptime arrtime
         INTO CORRESPONDING FIELDS OF wa_spfli
         FROM spfli
         WHERE carrid IN se_carr
          AND  connid IN se_conn.

    WRITE: / markfield1 AS CHECKBOX,
             markfield2,
             wa_spfli-carrid COLOR COL_KEY,
             wa_spfli-connid COLOR COL_KEY,
             wa_spfli-airpfrom COLOR COL_NORMAL,
             wa_spfli-cityfrom COLOR COL_NORMAL,
             wa_spfli-airpto COLOR COL_NORMAL,
             wa_spfli-cityto COLOR COL_NORMAL,
             wa_spfli-deptime COLOR COL_NORMAL,
             wa_spfli-arrtime COLOR COL_NORMAL.
*   hide information
    HIDE: wa_spfli-carrid, wa_spfli-connid.

  ENDSELECT.


END-OF-SELECTION.
  SET PF-STATUS '0001'.


AT USER-COMMAND.
  IF sy-ucomm = 'LIST'.
    SET PF-STATUS '0002'.
  ENDIF.
* Report controlled accessing of the list lines
  DO.
    CLEAR markfield1.
* Read line mit Field Value
    READ LINE sy-index
         FIELD VALUE markfield1.

* Accessing of the list terminates at the end of the list
    IF sy-subrc NE 0. EXIT. ENDIF.

    CHECK markfield1 NE space.  " if line is selected

* Creating Window
    WINDOW STARTING AT 10 5
           ENDING   AT 60 20.

*   display detail list only if valid line is selected
    WRITE: text-001 COLOR COL_NORMAL,
           wa_spfli-carrid COLOR COL_TOTAL,
           wa_spfli-connid COLOR COL_TOTAL,
           text-002 COLOR COL_NORMAL.
    SKIP.
*   page header for secondary list.
    WRITE: text-003 COLOR COL_HEADING.
    SKIP.
*   selecting data for secondary list
    SELECT fldate seatsmax seatsocc
           INTO CORRESPONDING FIELDS OF wa_sflight
           FROM sflight
           WHERE carrid = wa_spfli-carrid
           AND   connid = wa_spfli-connid.
*     output secondary list
      WRITE: / wa_sflight-fldate COLOR COL_KEY,
               wa_sflight-seatsmax COLOR COL_NORMAL,
               wa_sflight-seatsocc COLOR COL_NORMAL.
    ENDSELECT.

* The line being currently accessed is saved in modified version
    MODIFY CURRENT LINE
           FIELD VALUE markfield1 FROM space
                       markfield2 FROM '*'
           FIELD FORMAT markfield1 INPUT
           LINE FORMAT RESET.

  ENDDO.
