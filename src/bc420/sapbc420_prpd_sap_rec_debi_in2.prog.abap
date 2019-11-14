*&---------------------------------------------------------------------*
*& REPORT  SAPBC420_PRPD_SAP_REC_DEBI_IN2                              *
*&                                                                     *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*

REPORT sapbc420_prpd_sap_rec_debi_in2 MESSAGE-ID bc420.

TABLES: bgr00, bkn00, bkna1, bknb1.
TABLES: dxfile.
INCLUDE bc420c_debi_struc_file.
INCLUDE bc420_fill_nodata.
INCLUDE <list>.

* help structure (structure equal BKN00)
DATA bkn00_nodata LIKE bkn00.
* help structure (structure equal BKNA1)
DATA bkna1_nodata LIKE bkna1.
* help structure (structure equal BKNB1)
DATA bknb1_nodata LIKE bknb1.

DATA: n TYPE i,
      test-kunnr(6) VALUE 'Z-##-1',
      text(100).

SELECT-OPTIONS:
*filesin FOR dxfile-filename NO INTERVALS,
filesout FOR dxfile-filename NO INTERVALS.





*PARAMETERS:
* infile(70) LOWER CASE,
* outfile1(70) LOWER CASE,
* outfile2(70) LOWER CASE,
* session(20) DEFAULT 'BC420SES-##'       LOWER CASE,
* groupid(2)  DEFAULT '##',
* nodata      DEFAULT '/'                LOWER CASE,
* cust_nr DEFAULT 'X' AS CHECKBOX.

DATA:
 infile(70) ,
 outfile1(70) ,
 outfile2(70) ,
 session(20) VALUE 'BC420SES-##' ,
 groupid(2)  VALUE '##',
 nodata      VALUE '/'     ,
 cust_nr VALUE 'X' .



INITIALIZATION.
  INCLUDE bc_tools_420x_path_include.
  CONCATENATE path 'BC420_##_DEBI.FOR' INTO infile.
  CONCATENATE path 'BC420_00_DEBI_DTFILE_INT.SAP' INTO outfile1.
  CONCATENATE path 'BC420_##_DEDI_ERROR.ERR' INTO outfile2.


AT SELECTION-SCREEN.
* open files
  outfile1 = filesout-low.

  OPEN DATASET: infile FOR INPUT IN TEXT MODE MESSAGE text.
  IF sy-subrc NE 0.
    MESSAGE e101 WITH infile.
  ENDIF.
  OPEN DATASET: outfile1 FOR OUTPUT IN TEXT MODE MESSAGE text.
  IF sy-subrc NE 0.
    MESSAGE e100 WITH outfile1.
  ENDIF.
  OPEN DATASET: outfile2 FOR OUTPUT IN TEXT MODE MESSAGE text.
  IF sy-subrc NE 0.
    MESSAGE e100 WITH outfile2.
  ENDIF.

START-OF-SELECTION.


* fill structure with nodata
  PERFORM init USING bkn00_nodata nodata.
  PERFORM init USING bkna1_nodata nodata.
  PERFORM init USING bknb1_nodata nodata.

* fill structure bgr00
  PERFORM fill_bgr00.
* write data to file
  TRANSFER bgr00 TO outfile1.
  WRITE / bgr00.
* fill structure bkn00, bkna1 and bknb1
  DO.
    READ DATASET infile INTO  rec_convert.
    IF sy-subrc NE 0. EXIT. ENDIF.

    MOVE groupid TO test-kunnr+2(2).



    IF  cust_nr EQ space AND
       rec_convert-kunnr(6)  NE test-kunnr. "test-kunnr = 'Z-##-1'
      TRANSFER rec_convert TO outfile2.
      WRITE: / text-001, rec_convert-kunnr.
    ELSE.
      MOVE bkn00_nodata TO bkn00.
      PERFORM fill_bkn00.
      MOVE  bkna1_nodata TO bkna1.
      PERFORM fill_bkna1.
      MOVE  bknb1_nodata TO bknb1.
      PERFORM fill_bknb1.

* write data to file
      TRANSFER: bkn00 TO outfile1,
                bkna1 TO outfile1,
                bknb1 TO outfile1.
      WRITE: / text-002,  bkn00-kunnr, bkna1-name1.
    ENDIF.
  ENDDO.

  SKIP.
  WRITE icon_green_light AS ICON .
  WRITE text-001.

* close files
  CLOSE DATASET: infile,  outfile1,  outfile1.


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
        'X'        TO bgr00-xkeep.
ENDFORM.                               " FILL_BGR00

*&---------------------------------------------------------------------*
*&      Form  FILL_BKN00
*&---------------------------------------------------------------------*
*       fill structure bkn00
*----------------------------------------------------------------------*
FORM fill_bkn00.
  MOVE: '1'                TO bkn00-stype,
        'XD01'             TO bkn00-tcode,
        '0001'             TO bkn00-bukrs.
  IF  cust_nr EQ space.
    MOVE: rec_convert-kunnr  TO bkn00-kunnr,
          'KUNA'             TO bkn00-ktokd.
  ELSE.
    MOVE: space   TO bkn00-kunnr,
          'DEBI'  TO bkn00-ktokd.
  ENDIF.
ENDFORM.                               " FILL_BKN00

*&---------------------------------------------------------------------*
*&      Form  FILL_BKNA1
*&---------------------------------------------------------------------*
*       fill structure bkna1
*----------------------------------------------------------------------*
FORM fill_bkna1.
  MOVE: '2'           TO bkna1-stype,
        'BKNA1'       TO bkna1-tbnam,
        rec_convert-name1  TO bkna1-name1,
        rec_convert-sortl  TO bkna1-sortl,
        rec_convert-stras  TO bkna1-stras,
        rec_convert-ort01  TO bkna1-ort01,
        rec_convert-pstlz  TO bkna1-pstlz,
        rec_convert-land1  TO bkna1-land1,
        rec_convert-spras  TO bkna1-spras,
        rec_convert-telf1  TO bkna1-telf1.

  IF rec_convert-stceg IS INITIAL.
    MOVE nodata         TO bkna1-stceg.
  ELSE.
    MOVE rec_convert-stceg   TO bkna1-stceg.
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
