*&---------------------------------------------------------------------*
*& Report  SAPBC420_SEQS_COPY_DEB_TO_PC
*&---------------------------------------------------------------------*
*&            Downloads File (legacy debitors) to PC                   *
*&---------------------------------------------------------------------*

REPORT   SAPBC420_SEQS_COPY_DEB_TO_PC.

* legacy debitor - structure
INCLUDE sapbc420_seqi_debi_legacystruc.

* file with legacy data
parameters: asfile(100) type c default 'bc420_debi.leg',
            pcfile type RLGRAP-FILENAME default
            'C:\Temp\BC420_##_DEBI.LEG' lower case.

* Internal table for local dataset defined with Table fields
DATA: itab like STANDARD TABLE OF REC_LEGACY
                WITH KEY kunnr WITH HEADER LINE.

open dataset asfile in text mode.
if sy-subrc <> 0.
  write: / 'ERROR: could not open file ', asfile.
endif.

* read legacy data from Appl.-Server and download to PC
do.
  read dataset asfile into rec_legacy.
  if sy-subrc <> 0. exit. endif.

  append rec_legacy to itab.

enddo.

close dataset asfile.


* Just check if itab is okay !
loop at itab into rec_legacy.
  write: / rec_legacy.
endloop.

CALL FUNCTION 'DOWNLOAD'
    EXPORTING
         FILENAME                = pcfile
     TABLES
          DATA_TAB                = itab
    EXCEPTIONS
         INVALID_FILESIZE        = 1
         INVALID_TABLE_WIDTH     = 2
         INVALID_TYPE            = 3
         NO_BATCH                = 4
         UNKNOWN_ERROR           = 5
         GUI_REFUSE_FILETRANSFER = 6
         OTHERS                  = 7.

IF SY-SUBRC <> 0.
  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
          WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.
