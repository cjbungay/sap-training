*&---------------------------------------------------------------------*
*& Report  SAPBC420_SEQD_SEQFILES                                      *
*&---------------------------------------------------------------------*
*& demonstrates how to deal with sequential files;                     *
*& the source-file is read and transfered to the target file.         *
*&---------------------------------------------------------------------*

REPORT  sapbc420_seqd_seqfiles MESSAGE-ID bc420 LINE-SIZE 200    .

* include contains structur of old file
INCLUDE sapbc420_seqi_debi_legacystruc.
INCLUDE sapbc420_seqi_debi_strucnew.

* Creating the selection-screen with two file-names.
PARAMETERS:
  infile(50)  LOWER CASE,
  outfile(50) LOWER CASE.

INITIALIZATION.
  INCLUDE bc_tools_420x_path_include.
  CONCATENATE path 'BC420_DEBI_1.LEG' INTO infile.
  CONCATENATE path 'BC420_NewFile.TXT' INTO outfile.

* Both files are opened
AT SELECTION-SCREEN.
  OPEN DATASET infile FOR INPUT  IN TEXT MODE.
  IF sy-subrc NE 0.
    MESSAGE e101 WITH infile.
  ENDIF.
  OPEN DATASET outfile FOR OUTPUT IN TEXT MODE.
  IF sy-subrc NE 0.
    MESSAGE e100 WITH outfile.
  ENDIF.

START-OF-SELECTION.

* Transfer of data from the infile to the outfile
  DO.
    READ DATASET infile INTO rec_legacy.
    IF sy-subrc NE 0. EXIT. ENDIF.
    MOVE-CORRESPONDING rec_legacy TO rec_convert. "for same fieldnames
    MOVE rec_legacy-kunnr TO rec_convert-altnr.  "the fieldnames differ!
    TRANSFER rec_convert   TO outfile. "write record to file
    WRITE: / rec_convert.
  ENDDO.

* Closing both files
  CLOSE DATASET infile.
  CLOSE DATASET outfile.
