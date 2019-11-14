*&---------------------------------------------------------------------*
*& Report  SAPBC420_SEQT_CONVERT_DEBI2                                 *
*&---------------------------------------------------------------------*
*& Template-2: "for more experienced ABAP-developers"                  *
*& This coding should be completed by the participants.                *
*& Some of the needed statements are predefined. Please fill in the    *
*& missing statements.                                                 *
*& DEBITORS with external numberrange "Z-##-2xxxx" are created.        *
*&---------------------------------------------------------------------*
report  sapbc420_seqt_convert_debi2 message-id bc420 line-size 200.

tables: bgr00, bkn00, bkna1, bknb1.
* include contains structur of file with SAP-formatted data
include sapbc420_seqi_debi_legacystruc.
include bc420_fill_nodata.

* help structure (structure equals BKN00)
data bkn00_nodata like bkn00.
* help structure (structure equals BKNA1)
data bkna1_nodata like bkna1.
* help structure (structure equals BKNB1)
data bknb1_nodata like bknb1.

data: num(4) type n,
      text(100).

parameters:
 newkunnr(10) default 'Z-##-2',          "will be new debitor-no.
 infile(70) lower case,
 outfile1(70) lower case,
 errfile(70) lower case,
 session(20) default 'BC420SES-##'       lower case,
 nodata      default '/'                 lower case.

initialization.
*---------------
  include bc_tools_420x_path_include.
  concatenate path 'BC420_##_DEBI.LEG' into infile.
  concatenate path 'BC420_##_DEBI.SAP' into outfile1.
  concatenate path 'BC420_##_DEBI.ERR' into errfile.

at selection-screen.
*--------------------
* open files
*  ....

start-of-selection.
*-------------------
* fill SAP-auxiliary-record-layer structure with nodata-sign
*   ...

* fill structure bgr00
  perform fill_bgr00.

* write data to file
*  ...



  do.
*   read legacy data into rec_legacy
*   ...
*   ...

    " just to do some cleansing of legacy data!
    if rec_legacy-kunnr is initial.
*    transfer rec_legacy to the error file.
*    ...
*    ...
      write: / text-001, rec_legacy-kunnr.
    else.                    " record is okay !
*     fill SAP record layers
*     ...
*     ...
*     ...
*     ...


      " write data to file
*     transfer the record layers to outfile
*    ...
*    ...
          WRITE: / text-002, rec_legacy-kunnr.
          WRITE:   text-003, bkn00-kunnr.
    endif.
  enddo.

* close files
*  ...


*&---------------------------------------------------------------------*
*&      Form  FILL_BGR00
*       fill structure bgr00
*----------------------------------------------------------------------*
form fill_bgr00.
  move: '0'        to bgr00-stype,
        session    to bgr00-group,
        sy-mandt   to bgr00-mandt,
        sy-uname   to bgr00-usnam,
        nodata     to bgr00-nodata,
        'X'        to bgr00-xkeep.
endform.                               " FILL_BGR00
*&---------------------------------------------------------------------*
*&      Form  FILL_BKN00
*&      fill structure bkn00
*&      New debitor-numbers are created; they start with "Z-##-1"
*&      the old debitor number is concatenated --> "Z-##-1xxxx"
*----------------------------------------------------------------------*
form fill_bkn00.
  move: '1'                to bkn00-stype,
        'XD01'             to bkn00-tcode,
        '0001'             to bkn00-bukrs,
        'KUNA'             to bkn00-ktokd.
  num = sy-index.          "sy-index is set in DO-ENDDO-Loop
  move num to newkunnr+6(4).  "move new number
  move newkunnr to bkn00-kunnr.
endform.                               " FILL_BKN00
*&---------------------------------------------------------------------*
*&      Form  FILL_BKNA1
*       fill structure bkna1
*----------------------------------------------------------------------*
form fill_bkna1.
*  move: '2'           to bkna1-stype,
*        'BKNA1'       to bkna1-tbnam,
*        rec_legacy-name1  to bkna1-name1,
* ..
*...  some fields are still missing !
*...

*  the legacy-language field must be converted
*  use special form-routine "CONVERT_LANGUAGE"
*       ...
*       ...

  if rec_legacy-stceg is initial.
    move nodata         to bkna1-stceg.
  else.
    move rec_legacy-stceg   to bkna1-stceg.
  endif.
endform.                               " FILL_BKNA1
*&---------------------------------------------------------------------*
*&      Form  FILL_BKNB1
*       fill structure bknb1
*----------------------------------------------------------------------*
form fill_bknb1.
  move: '2'           to bknb1-stype,
        'BKNB1'       to bknb1-tbnam,
        '120000'      to bknb1-akont.
*       legacy debitor-number should be moved to bknb1-altkn.
*       ...
*       ...

endform.                               " FILL_BKNB1

*---------------------------------------------------------------------*
*       FORM Convert_langu                                            *
* D -> DE; E -> EN; and so on ...                                     *
*---------------------------------------------------------------------*
form convert_language.
* ...
* ...


endform.
