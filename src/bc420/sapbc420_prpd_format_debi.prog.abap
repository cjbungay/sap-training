*&---------------------------------------------------------------------*
*& Report  SAPBC420_PRPD_FORMAT_DEBI                                   *
*&                                                                     *
*&---------------------------------------------------------------------*
*& first file create customer with number Z-00-X001 thru Z-00-X001     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc420_prpd_format_debi MESSAGE-ID bc420 LINE-SIZE 200    .

* include contains structur of old file
INCLUDE bc420l_debi_struc_file.
INCLUDE bc420c_debi_struc_file.
INCLUDE <list>.
* Creating the selection-screen (manual data input)
*PARAMETERS:
DATA:
  kunnr1(6)  VALUE 'Z-##-1',
  infile(50),                          "LOWER CASE,
  outfile(50).                         "LOWER CASE.

INITIALIZATION.
  INCLUDE bc_tools_420x_path_include.
  CONCATENATE path 'BC420_DEBI.LEG' INTO infile.
  CONCATENATE path 'BC420_##_DEBI.FOR' INTO outfile.

* Dataset opened for output and in text mode
* At selection-screen.
  OPEN DATASET infile FOR INPUT  IN TEXT MODE.
  IF sy-subrc NE 0.
    MESSAGE e101 WITH infile.
  ENDIF.
  OPEN DATASET outfile FOR OUTPUT IN TEXT MODE.
  IF sy-subrc NE 0.
    MESSAGE e100 WITH outfile.
  ENDIF.

START-OF-SELECTION.

* Transfer of data from the selection-screen to the inrecord
  DO.
    READ DATASET infile INTO rec_legacy.
    IF sy-subrc NE 0. EXIT. ENDIF.
    PERFORM write_outfiles.
    TRANSFER rec_convert   TO outfile.
    WRITE: / rec_convert.
  ENDDO.
  SKIP.
  WRITE icon_green_light AS ICON .
  WRITE text-001.


* Closing the completed sequential dataset
  CLOSE DATASET infile.
  CLOSE DATASET outfile.

*---------------------------------------------------------------------*
*       FORM WRITE_OUTFILES                                           *
*---------------------------------------------------------------------*
*       fill structur for files outfile                                *
*---------------------------------------------------------------------*
FORM write_outfiles.

  MOVE kunnr1       TO rec_convert-kunnr.
  MOVE rec_legacy-kunnr  TO rec_convert-kunnr+6.
  MOVE rec_legacy-name1  TO rec_convert-name1.
  MOVE rec_legacy-sortl  TO rec_convert-sortl.
  MOVE rec_legacy-stras  TO rec_convert-stras.
  MOVE rec_legacy-ort01  TO rec_convert-ort01.
  MOVE rec_legacy-pstlz  TO rec_convert-pstlz.
  MOVE rec_legacy-land1  TO rec_convert-land1.

  PERFORM  convert_langu.

  MOVE rec_legacy-telf1  TO rec_convert-telf1.
  MOVE rec_legacy-stceg  TO rec_convert-stceg.


ENDFORM.


*---------------------------------------------------------------------*
*       FORM Convert_langu                                            *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM convert_langu.
  CASE rec_legacy-spras.
    WHEN 'E'.
      rec_convert-spras = 'EN'.
    WHEN 'D'.
      rec_convert-spras = 'DE'.
    WHEN 'F'.
      rec_convert-spras = 'FR'.
    WHEN 'S'.
      rec_convert-spras = 'ES'.
    WHEN 'J'.
      rec_convert-spras = 'JA'.
  ENDCASE.

ENDFORM.
