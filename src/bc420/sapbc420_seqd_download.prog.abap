*&---------------------------------------------------------------------*
*& Report  SAPBC420_SEQD_DOWNLOAD                                      *
*&---------------------------------------------------------------------*
*&            Downloads Data from kna1-table to file                   *
*&---------------------------------------------------------------------*

REPORT  sapbc420_seqd_download        .

* Internal table for local dataset defined with Table fields
TYPES: BEGIN OF rectype,
        kunnr LIKE kna1-kunnr,
        land1 LIKE kna1-land1,
        name1 LIKE kna1-name1,
        stras LIKE kna1-stras,
        ort01 LIKE kna1-ort01,
        pstlz LIKE kna1-pstlz,
      END OF rectype      .

DATA: itab TYPE STANDARD TABLE OF rectype
                WITH KEY kunnr WITH HEADER LINE.

* Accessing Customer Data and storing the data in an internal table
SELECT kunnr land1 name1 stras ort01 pstlz stras FROM kna1 INTO
   CORRESPONDING FIELDS OF TABLE itab.

* Call of the function module DOWNLOAD. Data is transferred by means of
* an internal table ITAB

CALL FUNCTION 'GUI_DOWNLOAD'
  EXPORTING
*   BIN_FILESIZE                  =
    FILENAME                      = 'BC420_00_Demofile.txt'
*   FILETYPE                      = 'ASC'
*   APPEND                        = ' '
*   WRITE_FIELD_SEPARATOR         = ' '
*   HEADER                        = '00'
*   TRUNC_TRAILING_BLANKS         = ' '
*   WRITE_LF                      = 'X'
*   COL_SELECT                    = ' '
*   COL_SELECT_MASK               = ' '
*   DAT_MODE                      = ' '
*   CONFIRM_OVERWRITE             = ' '
*   NO_AUTH_CHECK                 = ' '
*   CODEPAGE                      = ' '
*   IGNORE_CERR                   = ABAP_TRUE
*   REPLACEMENT                   = '#'
*   WRITE_BOM                     = ' '
* IMPORTING
*   FILELENGTH                    =
  TABLES
    DATA_TAB                      = itab
 EXCEPTIONS
   FILE_WRITE_ERROR              = 1
   NO_BATCH                      = 2
   GUI_REFUSE_FILETRANSFER       = 3
   INVALID_TYPE                  = 4
   NO_AUTHORITY                  = 5
   UNKNOWN_ERROR                 = 6
   HEADER_NOT_ALLOWED            = 7
   SEPARATOR_NOT_ALLOWED         = 8
   FILESIZE_NOT_ALLOWED          = 9
   HEADER_TOO_LONG               = 10
   DP_ERROR_CREATE               = 11
   DP_ERROR_SEND                 = 12
   DP_ERROR_WRITE                = 13
   UNKNOWN_DP_ERROR              = 14
   ACCESS_DENIED                 = 15
   DP_OUT_OF_MEMORY              = 16
   DISK_FULL                     = 17
   DP_TIMEOUT                    = 18
   FILE_NOT_FOUND                = 19
   DATAPROVIDER_EXCEPTION        = 20
   CONTROL_FLUSH_ERROR           = 21
   OTHERS                        = 22.

IF sy-subrc NE 0.
  WRITE 'Error'(001).
ELSE.
  WRITE 'Download Ok'(002).
ENDIF.
