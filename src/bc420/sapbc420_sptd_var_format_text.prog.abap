REPORT sapbc420_sptd_var_format_text MESSAGE-ID bc420.
*
* reads debitors and bankdata, both in two different records A and B.
* B contains bankdata.
*
TYPES:
******************* legacy structure A *****************************
   BEGIN OF reca,
      rectype(1) TYPE c,               "record type
      kunnr(4),                        "Customer Number
      name1(30),                       "Customer Name
      sortl(20),                       "Sort Field
      custtype(4),                     "Old Customer Type
      stras(40),                       "Street and House Number
      ort01(30),                       "City
      pstlz(10),                       "Postal code
      land1(2),                        "Country Key
      spras(1),                        "Language Key
      telf1(16),                       "Telephone Number
      stceg  LIKE  kna1-stceg,         "VAT Registration Number
   END OF   reca,
******************* legacy structure B ****************************
   BEGIN OF recb,
      rectype(1) TYPE c,               "record type
      banklangu(3),                    "Bank language
      bankkey(8),                      "Bankkey
      bankacount(8),                   "Bankaccount
      einzug(1),                       "Einzugs
      bankname(20),                    "Bankname
   END OF   recb.

******************* Record layers for SAP-transfer programs ***********
TABLES: bgr00, bkn00, bkna1, bknb1, bknbk.

* help structure (structure equals BKN00)
DATA bkn00_nodata LIKE bkn00.
* help structure (structure equals BKNA1)
DATA bkna1_nodata LIKE bkna1.
* help structure (structure equals BKNB1)
DATA bknb1_nodata LIKE bknb1.
* help structure (structure equals BKNBK)
DATA bknbk_nodata LIKE bknbk.

****************** Define Parameters for selection-dynpro *********
PARAMETERS:
 infile(70) LOWER CASE,
 outfile(70) LOWER CASE,
 errfile(70) LOWER CASE,
 session(20) DEFAULT 'BC420SES-##' LOWER CASE,
 kunnr(10) DEFAULT 'Z-##-1',
 groupid(2)  DEFAULT '##',
 keep        DEFAULT 'X',
 nodata      DEFAULT '/' LOWER CASE.

******************** define global variables *********************
DATA:  record(180),
       reca TYPE reca,
       recb TYPE recb,
       text(100).

INCLUDE bc420_fill_nodata.  "fills any desired record with NODATA

INITIALIZATION.
*##################################

  INCLUDE bc_tools_420x_path_include.
  CONCATENATE path 'BC420_DEBI_BANK_TEXT.LEG' INTO infile.
  CONCATENATE path 'BC420_DEBI_BANK_TEXT.SAP' INTO outfile.
  CONCATENATE path 'BC420_DEBI_BANK.ERR' INTO errfile.

AT SELECTION-SCREEN.
*#######################
* open files
  OPEN DATASET: infile FOR INPUT IN TEXT MODE MESSAGE text.
  IF sy-subrc NE 0.
    MESSAGE e101 WITH infile.
  ENDIF.
  OPEN DATASET: outfile FOR OUTPUT IN TEXT MODE MESSAGE text.
  IF sy-subrc NE 0.
    MESSAGE e100 WITH outfile.
  ENDIF.
  OPEN DATASET: errfile FOR OUTPUT IN TEXT MODE MESSAGE text.
  IF sy-subrc NE 0.
    MESSAGE e100 WITH errfile.
  ENDIF.

START-OF-SELECTION.
*###################
* fill structure with nodata
  PERFORM init USING bkn00_nodata nodata.
  PERFORM init USING bkna1_nodata nodata.
  PERFORM init USING bknb1_nodata nodata.
  PERFORM init USING bknbk_nodata nodata.

* fill structure bgr00
  PERFORM fill_bgr00.
* write data to file
  TRANSFER bgr00 TO outfile.
  WRITE / bgr00.
* fill structure bkn00, bkna1, bknb1 and bknb1
  DO.
    READ DATASET infile INTO record.
    IF ( sy-subrc <> 0  ).
      EXIT.
    ENDIF.
    PERFORM fill_itab.
    CLEAR record.
  ENDDO.

END-OF-SELECTION.
*###################
  CLOSE DATASET: infile,  outfile,  errfile.
*&---------------------------------------------------------------------*
*&      Form  FILL_ITAB
*&      Decides, whether record A or B has to be processed.
*&---------------------------------------------------------------------*
FORM fill_itab.
  IF record(1) = 'A'.
    PERFORM fill_reca.
  ELSEIF record(1) = 'B'.
    PERFORM fill_recb.
  ELSE.
    WRITE: / 'Wrong rectype ( not A or B ) !'.
  ENDIF.
ENDFORM.                               " FILL_ITAB

*&---------------------------------------------------------------------*
*&      Form  FILL_RECA
*&---------------------------------------------------------------------*
*       Fill SAP-records bkn00, bkna1, bknb1 with data from reca
*----------------------------------------------------------------------*
FORM fill_reca.
  reca = record.   "move legacy data to reca, rectype A has been scanned
  ULINE. WRITE: / 'set A:', reca.
  MOVE bkn00_nodata TO bkn00.
  PERFORM fill_bkn00.
  MOVE  bkna1_nodata TO bkna1.
  PERFORM fill_bkna1.
  MOVE  bknb1_nodata TO bknb1.
  PERFORM fill_bknb1.
  TRANSFER: bkn00 TO outfile,
            bkna1 TO outfile,
            bknb1 TO outfile.
ENDFORM.                               " FILL_RECA

*&---------------------------------------------------------------------*
*&      Form  FILL_RECB
*&---------------------------------------------------------------------*
FORM fill_recb.
  recb = record.   "move legacy data to recb, rectype B has been scanned
  WRITE: / 'set B:', recb.
  MOVE  bknbk_nodata TO bknbk.
  PERFORM fill_bknbk.
  TRANSFER: bknbk TO outfile.
ENDFORM.                               " FILL_RECB

*&---------------------------------------------------------------------*
*&      Form  FILL_BGR00
*&---------------------------------------------------------------------*
*       fill structure bgr00
*----------------------------------------------------------------------*
FORM fill_bgr00.
  MOVE: '0'        TO bgr00-stype,
        session    TO bgr00-group,
        sy-mandt   TO bgr00-mandt,
        sy-uname   TO bgr00-usnam,
        nodata     TO bgr00-nodata,
        keep       TO bgr00-xkeep.
ENDFORM.                               " FILL_BGR00

*&---------------------------------------------------------------------*
*&      Form  FILL_BKN00
*&---------------------------------------------------------------------*
*       fill structure bkn00
*----------------------------------------------------------------------*
FORM fill_bkn00.
  bkn00-kunnr = kunnr.
  MOVE: '1'                TO bkn00-stype,
        'XD01'             TO bkn00-tcode,
        reca-kunnr         TO bkn00-kunnr+6(4),
        '0001'             TO bkn00-bukrs,
        'KUNA'             TO bkn00-ktokd.
ENDFORM.                               " FILL_BKN00

*&---------------------------------------------------------------------*
*&      Form  FILL_BKNA1
*&---------------------------------------------------------------------*
*       fill structure bkna1
*----------------------------------------------------------------------*
FORM fill_bkna1.
  MOVE: '2'           TO bkna1-stype,
        'BKNA1'       TO bkna1-tbnam,
        reca-name1  TO bkna1-name1,
        reca-sortl  TO bkna1-sortl,
        reca-stras  TO bkna1-stras,
        reca-ort01  TO bkna1-ort01,
        reca-pstlz  TO bkna1-pstlz,
        reca-land1  TO bkna1-land1,
        reca-spras  TO bkna1-spras,
        reca-telf1  TO bkna1-telf1.

  IF reca-stceg IS INITIAL.
    MOVE nodata         TO bkna1-stceg.
  ELSE.
    MOVE reca-stceg   TO bkna1-stceg.
  ENDIF.

ENDFORM.                               " FILL_BKNA1

*&---------------------------------------------------------------------*
*&      Form  FILL_BKNB1
*&---------------------------------------------------------------------*
*       fill structure bknb1
*----------------------------------------------------------------------*
FORM fill_bknb1.
  MOVE: '2'           TO bknb1-stype,
        'BKNB1'       TO bknb1-tbnam,
        '120000'      TO bknb1-akont.

ENDFORM.                               " FILL_BKNB1

*&---------------------------------------------------------------------*
*&      Form  FILL_BKNBK
*&---------------------------------------------------------------------*
*       fill structure bknbk
*----------------------------------------------------------------------*
FORM fill_bknbk.
  MOVE: '2' TO bknbk-stype,
        'BKNBK' TO bknbk-tbnam,
        recb-bankkey TO bknbk-bankl,
        recb-banklangu TO bknbk-banks,
        recb-bankacount TO bknbk-bankn,
*        recb-einzug TO bknbk-xezer,
        recb-bankname TO bknbk-banka.
ENDFORM.                               " FILL_BKNBK
