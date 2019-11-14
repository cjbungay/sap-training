*&---------------------------------------------------------------------*
*& Report  SAPBC420_SEQT_CONVERT_DEBI1                                 *
*&---------------------------------------------------------------------*
*& Template-1: This coding should be completed by the participants.    *
*& Some of the needed statements are predefined. Please fill in the    *
*& missing statements.                                                 *
*& DEBITORS with external numberrange "Z-##-2xxxx" are created.        *
*&---------------------------------------------------------------------*
REPORT  sapbc420_seqt_convert_debi1 MESSAGE-ID bc420 LINE-SIZE 200.

TABLES: bgr00, bkn00, bkna1, bknb1.
* include contains structur of file with SAP-formatted data
INCLUDE sapbc420_seqi_debi_legacystruc.
INCLUDE bc420_fill_nodata.

* help structure (structure equals BKN00)
DATA bkn00_nodata LIKE bkn00.
* help structure (structure equals BKNA1)
DATA bkna1_nodata LIKE bkna1.
* help structure (structure equals BKNB1)
DATA bknb1_nodata LIKE bknb1.

DATA: num(4) TYPE n,
      text(100).

PARAMETERS:
 newkunnr(10) DEFAULT 'Z-##-2',        "will be new debitor-no.
 infile(70)   LOWER CASE,
 outfile1(70) LOWER CASE,
 errfile(70)  LOWER CASE,
 session(20)  DEFAULT 'BC420SES-##'       LOWER CASE,
 nodata       DEFAULT '/'                 LOWER CASE.

INITIALIZATION.
*---------------
  INCLUDE bc_tools_420x_path_include.
  CONCATENATE path 'BC420_##_DEBI.LEG' INTO infile.
  CONCATENATE path 'BC420_##_DEBI.SAP' INTO outfile1.
  CONCATENATE path 'BC420_##_DEBI.ERR' INTO errfile.

AT SELECTION-SCREEN.
*--------------------
* open files
  OPEN DATASET: infile FOR INPUT IN TEXT MODE MESSAGE text.
  IF sy-subrc NE 0.
    MESSAGE e101 WITH infile.
  ENDIF.
  OPEN DATASET: outfile1 FOR OUTPUT IN TEXT MODE MESSAGE text.
  IF sy-subrc NE 0.
    MESSAGE e100 WITH outfile1.
  ENDIF.
  OPEN DATASET: errfile FOR OUTPUT IN TEXT MODE MESSAGE text.
  IF sy-subrc NE 0.
    MESSAGE e100 WITH errfile.
  ENDIF.

START-OF-SELECTION.
*-------------------
* fill auxiliary-SAP-record-layer structure with nodata
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
*   read legacy data into rec_legacy
*   ...
*   ...

    " just to do some cleansing of legacy data!
    IF rec_legacy-kunnr IS INITIAL.
*    transfer rec_legacy to the error file.
*    ...
*    ...
      WRITE: / text-001, rec_legacy-kunnr.
    ELSE.                              " record is okay !
      MOVE bkn00_nodata TO bkn00.
      PERFORM fill_bkn00.
      MOVE  bkna1_nodata TO bkna1.
      PERFORM fill_bkna1.
      MOVE  bknb1_nodata TO bknb1.
      PERFORM fill_bknb1.
                                       " write data to file
*     transfer the record layers to outfile
*    ...
*    ...

      WRITE: / text-002, rec_legacy-kunnr.
      WRITE:   text-003, bkn00-kunnr.
    ENDIF.
  ENDDO.
* close files
  CLOSE DATASET: infile,  outfile1,  errfile.


*&---------------------------------------------------------------------*
*&      Form  FILL_BGR00
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
*&      fill structure bkn00
*&      New debitor-numbers are created; they start with "Z-##-1"
*&      the old debitor number is concatenated --> "Z-##-1xxxx"
*----------------------------------------------------------------------*
FORM fill_bkn00.
  MOVE: '1'                TO bkn00-stype,
        'XD01'             TO bkn00-tcode,
        '0001'             TO bkn00-bukrs,
        'KUNA'             TO bkn00-ktokd.
  num = sy-index.                      "sy-index is set in DO-ENDDO-Loop
  MOVE num TO newkunnr+6(4).           "move new number
  MOVE newkunnr TO bkn00-kunnr.
ENDFORM.                               " FILL_BKN00
*&---------------------------------------------------------------------*
*&      Form  FILL_BKNA1
*       fill structure bkna1
*----------------------------------------------------------------------*
FORM fill_bkna1.
  MOVE: '2'           TO bkna1-stype,
        'BKNA1'       TO bkna1-tbnam,
        rec_legacy-name1  TO bkna1-name1,
        rec_legacy-sortl  TO bkna1-sortl,
        rec_legacy-stras  TO bkna1-stras,
        rec_legacy-ort01  TO bkna1-ort01,
        rec_legacy-pstlz  TO bkna1-pstlz,
        rec_legacy-land1  TO bkna1-land1,
        rec_legacy-telf1  TO bkna1-telf1.
*  the legacy-language field must be converted
*  use special form-routine "CONVERT_LANGUAGE"
*       ...
*       ...

  IF rec_legacy-stceg IS INITIAL.
    MOVE nodata         TO bkna1-stceg.
  ELSE.
    MOVE rec_legacy-stceg   TO bkna1-stceg.
  ENDIF.
ENDFORM.                               " FILL_BKNA1
*&---------------------------------------------------------------------*
*&      Form  FILL_BKNB1
*       fill structure bknb1
*----------------------------------------------------------------------*
FORM fill_bknb1.
  MOVE: '2'           TO bknb1-stype,
        'BKNB1'       TO bknb1-tbnam,
        '120000'      TO bknb1-akont.
*       legacy debitor-number should be moved to bknb1-altkn.
*       ...
*       ...

ENDFORM.                               " FILL_BKNB1

*---------------------------------------------------------------------*
*       FORM Convert_langu                                            *
*---------------------------------------------------------------------*
FORM convert_language.
  CASE rec_legacy-spras.
    WHEN 'E'.
      bkna1-spras = 'EN'.
    WHEN 'D'.
      bkna1-spras = 'DE'.
    WHEN 'F'.
      bkna1-spras = 'FR'.
    WHEN 'S'.
      bkna1-spras = 'ES'.
    WHEN 'J'.
      bkna1-spras = 'JA'.
  ENDCASE.
ENDFORM.
