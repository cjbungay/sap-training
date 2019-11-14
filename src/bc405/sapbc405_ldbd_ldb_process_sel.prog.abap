*&---------------------------------------------------------------------*
*& Report  SAPBC405_LDBD_LDB_PROCESS_SEL                               *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT SAPBC405_LDBD_LDB_PROCESS_SEL MESSAGE-ID bc405
        LINE-SIZE 83 .

DATA: deptime TYPE spfli-deptime,
      price   TYPE sflight-price.

SELECTION-SCREEN BEGIN OF BLOCK geo WITH FRAME.
PARAMETERS: pa_city TYPE scitairp-city OBLIGATORY
            DEFAULT 'FRANKFURT',
            pa_ctry TYPE scitairp-country OBLIGATORY
            DEFAULT 'DE'.
SELECTION-SCREEN END OF BLOCK geo.

* Additional selections
SELECT-OPTIONS: sdepart FOR deptime DEFAULT '08000' TO '220000',
                sprice  FOR price DEFAULT '500' TO '1000'.


START-OF-SELECTION.

* Tables, which are needed for the function module LDB_PROCESS
  DATA call_back_tab LIKE STANDARD TABLE OF ldbcb.
  DATA sel_tab       LIKE STANDARD TABLE OF rsparams.

*  Working Areas
  DATA: wa_call_back LIKE  ldbcb,
        wa_sel_tab   LIKE  rsparams,
        wa_scitairp  LIKE  scitairp.


  SELECT * FROM scitairp INTO wa_scitairp
     WHERE city    = pa_city
       AND country = pa_ctry.

* Filling the selection table which is passed to the LDB
    MOVE:  'I'      TO wa_sel_tab-sign,
          'EQ'      TO wa_sel_tab-option,
           'S'      TO wa_sel_tab-kind,
          'AIRP_FR' TO wa_sel_tab-selname,
           wa_scitairp-airport TO  wa_sel_tab-low.
    APPEND  wa_sel_tab TO sel_tab.
  ENDSELECT.

  IF sy-subrc <> 0. MESSAGE i007. ENDIF.

* Creation of the callback table
  wa_call_back-ldbnode     = 'SPFLI'.
  wa_call_back-get         = 'X'.
  wa_call_back-get_late    = ' '.
  wa_call_back-cb_prog     =  sy-cprog.
  wa_call_back-cb_form     = 'CALL_BACK_SPFLI'.
  APPEND wa_call_back TO call_back_tab.
  CLEAR wa_call_back.

  wa_call_back-ldbnode     = 'SFLIGHT'.
  wa_call_back-get         = 'X'.
  wa_call_back-cb_prog     =  sy-cprog.
  wa_call_back-cb_form     = 'CALL_BACK_SFLIGHT'.
  APPEND wa_call_back TO call_back_tab.
  CLEAR wa_call_back.

  wa_call_back-ldbnode     = 'SBOOK'.
  wa_call_back-get         = 'X'.
  wa_call_back-cb_prog     =  sy-cprog.
  wa_call_back-cb_form     = 'CALL_BACK_SBOOK'.
  APPEND wa_call_back TO call_back_tab.
  CLEAR wa_call_back.


* Start of Logical Database
  CALL FUNCTION 'LDB_PROCESS'
         EXPORTING
              ldbname                     =  'F1S'
*         VARIANT                     =
*         EXPRESSIONS                 =
*         FIELD_SELECTION             =
         TABLES
              callback                    =  call_back_tab
              selections                  =  sel_tab
         EXCEPTIONS
              LDB_NOT_REENTRANT                 = 1
              LDB_INCORRECT                     = 2
              LDB_ALREADY_RUNNING               = 3
              LDB_ERROR                         = 4
              LDB_SELECTIONS_ERROR              = 5
              LDB_SELECTIONS_NOT_ACCEPTED       = 6
              VARIANT_NOT_EXISTENT              = 7
              VARIANT_OBSOLETE                  = 8
              VARIANT_ERROR                     = 9
              FREE_SELECTIONS_ERROR             = 10
              CALLBACK_NO_EVENT                 = 11
              CALLBACK_NODE_DUPLICATE           = 12
              CALLBACK_NO_PROGRAM               = 13
              CALLBACK_NO_CBFORM                = 14
              DYN_NODE_NO_TYPE                  = 15
              DYN_NODE_INVALID_TYPE             = 16
              OTHERS                            = 17.

IF sy-subrc <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
           WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

END-OF-SELECTION.
  ULINE.

************************************************************************
* The logical database will process these forms
************************************************************************
* SPFLI
FORM call_back_spfli USING name LIKE ldbn-ldbnode  "Node
                  workarea TYPE spfli  " DATA
                  mode     TYPE c      " G(et) or L(ate)
                  selected TYPE c.     " Node needed
  FORMAT COLOR COL_HEADING.
  WRITE: / sy-vline, workarea-carrid,
           workarea-connid,
           workarea-countryfr,
           workarea-cityfrom,
           workarea-countryto,
           workarea-cityto, 83 sy-vline.
ENDFORM.


* SFLIGHT
FORM call_back_sflight USING name LIKE ldbn-ldbnode  " Node
                         workarea TYPE sflight       " DATA
                         mode     TYPE c             " G(et) or L(ate)
                         selected TYPE c.            " Node needed


* check of selection criteria sprice
  IF  NOT workarea-price IN sprice.
    selected = space.
    EXIT.
  ENDIF.

  FORMAT COLOR COL_NORMAL.
  WRITE: / sy-vline, workarea-fldate,
           workarea-planetype,
           workarea-seatsmax,
           workarea-seatsocc, 83 sy-vline.

ENDFORM.


* SBOOK
FORM call_back_sbook USING name LIKE ldbn-ldbnode  "Node
                  workarea TYPE sbook  " DATA
                  mode     TYPE c      " G(et) or L(ate)
                  selected TYPE c.     " Node needed

  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  WRITE: / sy-vline, 20 workarea-customid,
           workarea-bookid,
           83 sy-vline.
ENDFORM.
