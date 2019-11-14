*&---------------------------------------------------------------------*
*& Report  SAPBC420_SEQS_COPY_DEB_TO_AS                                *
*&---------------------------------------------------------------------*
*&            Transfers File from PC to Application Server             *
*&---------------------------------------------------------------------*
REPORT   SAPBC420_SEQS_COPY_DEB_TO_AS.

* legacy-file structur
include SAPBC420_SEQI_DEBI_LEGACYSTRUC.

* file definitions
PARAMETERS: asfile(100) TYPE c DEFAULT 'bc420_##_debi.leg',
            pcfile type RLGRAP-FILENAME
                        DEFAULT 'C:\Temp\bc420_##_debi.leg'.

* Internal table for local dataset defined with Table fields
DATA: itab LIKE STANDARD TABLE OF rec_legacy
                WITH KEY kunnr WITH HEADER LINE.

* Upload the data from the PC into the internal table itab
CALL FUNCTION 'UPLOAD'
     EXPORTING
          filename                = pcfile
     TABLES
          data_tab                = itab
     EXCEPTIONS
          conversion_error        = 1
          invalid_table_width     = 2
          invalid_type            = 3
          no_batch                = 4
          unknown_error           = 5
          gui_refuse_filetransfer = 6
          OTHERS                  = 7.
IF sy-subrc <> 0.
  WRITE: / 'Could not upload the file from PC'. EXIT.
ENDIF.

* open the file on the Aplication-Server to transfer data
OPEN DATASET asfile FOR OUTPUT IN TEXT MODE.
IF sy-subrc <> 0.
  WRITE: / 'ERROR: could not open file ', asfile. EXIT.
ENDIF.

* read content of itab and save it to Application-Server
LOOP AT itab INTO rec_legacy.
  TRANSFER rec_legacy TO asfile.
  WRITE: / rec_legacy.
ENDLOOP.

CLOSE DATASET asfile.
