*&---------------------------------------------------------------------*
*& Report  SAPBC420_SEQD_UPLOAD                                        *
*&---------------------------------------------------------------------*
*& Read file from front-end                                            *
*&---------------------------------------------------------------------*

REPORT  sapbc420_seqd_upload         .
* Internal table for local dataset defined with Tables fields

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

* Call of the function module UPLOAD. Data is transferred by means
* an internal table ITAB
CALL FUNCTION 'GUI_UPLOAD'
  EXPORTING
    FILENAME                      = 'BC420_00_Demofile.txt'
*   FILETYPE                      = 'ASC'
*   HAS_FIELD_SEPARATOR           = ' '
*   HEADER_LENGTH                 = 0
*   READ_BY_LINE                  = 'X'
*   DAT_MODE                      = ' '
*   CODEPAGE                      = ' '
*   IGNORE_CERR                   = ABAP_TRUE
*   REPLACEMENT                   = '#'
* IMPORTING
*   FILELENGTH                    =
*   HEADER                        =
  TABLES
    DATA_TAB                      = itab
 EXCEPTIONS
   FILE_OPEN_ERROR               = 1
   FILE_READ_ERROR               = 2
   NO_BATCH                      = 3
   GUI_REFUSE_FILETRANSFER       = 4
   INVALID_TYPE                  = 5
   NO_AUTHORITY                  = 6
   UNKNOWN_ERROR                 = 7
   BAD_DATA_FORMAT               = 8
   HEADER_NOT_ALLOWED            = 9
   SEPARATOR_NOT_ALLOWED         = 10
   HEADER_TOO_LONG               = 11
   UNKNOWN_DP_ERROR              = 12
   ACCESS_DENIED                 = 13
   DP_OUT_OF_MEMORY              = 14
   DISK_FULL                     = 15
   DP_TIMEOUT                    = 16
   OTHERS                        = 17.

IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

IF sy-subrc NE 0.
  WRITE 'Error'(001).                  "#EC *
ELSE.
* Output of the internal table
  LOOP AT itab.

    WRITE: / itab-kunnr, itab-land1, itab-name1(30),
             itab-stras(30), itab-pstlz, itab-ort01(30).
  ENDLOOP.
ENDIF.
