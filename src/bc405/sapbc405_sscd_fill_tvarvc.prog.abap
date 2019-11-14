*&---------------------------------------------------------------------*
*& Report  SAPBC405_SSCD_FILL_TVARVC                                   *
*&                                                                     *
*&---------------------------------------------------------------------*
* Modifiziert die Tabelle TVARVC, so dass dort ein vom Benutzer zu
* Eintrag für eine select-option vorhanden ist, deren low-Feld den
* Monatsersten enthält und das high-Feld das aktuelle Tagesdatum,
* verringert um einen Tag.
* Dieser Report muss täglich (am besten in einem Job) eingeplant
* werden, so dass Varianten über eine TVARVC-Selektionsvariable darauf
* zurückgreifen können.
*&---------------------------------------------------------------------*
* This program modifies the database table TVARVC. The low field of the
* select option table always contains the first day of the month. The
* high field contains yesterday's date.
* This report has to be run on a daily basis. Thus the relevant entries
* of table TVARVC are up to date.
*&---------------------------------------------------------------------*

REPORT  sapbc405_sscd_fill_tvarvc .

TABLES tvarvc.

PARAMETERS:
pa_key TYPE rvari_vnam DEFAULT 'DYNAMIC_DATE_CALC',

pa_clnt RADIOBUTTON GROUP clnt,
pa_all  RADIOBUTTON GROUP clnt,
pa_both RADIOBUTTON GROUP clnt.

data: l_high type d.

START-OF-SELECTION.
* Calculation
  tvarvc-low = sy-datum.
  tvarvc-low+6(2) = '01'.
  l_high = sy-datum - 1.
  tvarvc-high = l_high.
  tvarvc-name = pa_key.      " Key field required to identify entry
  tvarvc-type = 'S'.         " Type: select-option
  tvarvc-numb = '0000'.      "
  tvarvc-sign = 'I'.         " inlcude
  tvarvc-opti = 'BT'.        " between

* for client-specific variants
  IF pa_clnt = 'X' OR pa_both = 'X'.
    tvarvc-mandt = sy-mandt.
    MODIFY tvarvc.
    IF sy-dbcnt = 1.
      WRITE: / 'New or modified entry in table TVARVC, client'(s01),
        sy-mandt, pa_key.
    ENDIF.
  ENDIF.

* for client-unspecific variants (in client 000, starting with CUS&)
  IF pa_all = 'X' OR pa_both = 'X'.
    tvarvc-mandt = '000'.
    MODIFY tvarvc CLIENT SPECIFIED.  " modify data base table TVARVC
    IF sy-dbcnt = 1.
      WRITE: / 'New or modified entry in table TVARVC, client 000'(s02),
        pa_key.
    ENDIF.
  ENDIF.
