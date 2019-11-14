*&---------------------------------------------------------------------*
*& Report SAPBC420_SEQD_FILES                                          *
*&                                                                     *
*&---------------------------------------------------------------------*
*& report create two seq. files                                        *
*&                                                                     *
*&    file one in text mode                                            *
*&    file one in binary mode                                          *
*&---------------------------------------------------------------------*

REPORT sapbc420_seqd_files MESSAGE-ID bc420.

DATA: row(2),
      line(14).

PARAMETERS:
    textfile(50) LOWER CASE,
    binfile(50)  LOWER CASE.

INITIALIZATION.

  INCLUDE bc_tools_420x_path_include.

  CONCATENATE path 'BC420-##-text' INTO textfile.           "#EC NOTEXT
  CONCATENATE path 'BC420-##-binary' INTO binfile.

AT SELECTION-SCREEN.
*--------------------
* open files
  OPEN DATASET textfile FOR OUTPUT IN TEXT MODE.
  IF sy-subrc NE 0.
    MESSAGE e101 WITH textfile.
  ENDIF.
  OPEN DATASET binfile FOR OUTPUT IN BINARY MODE.
  IF sy-subrc NE 0.
    MESSAGE e100 WITH binfile.
  ENDIF.



START-OF-SELECTION.


  DO 50 TIMES.
    row = sy-index.
   CONCATENATE 'This is line' row INTO line.                 "#EC NOTEXT
    TRANSFER line TO textfile.
    TRANSFER line TO binfile.

  ENDDO.

  CLOSE DATASET textfile.
  CLOSE DATASET binfile.


  WRITE 'files have been created'(001)."#EC *
