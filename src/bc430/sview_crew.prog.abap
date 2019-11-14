REPORT SVIEW_CREW .

PARAMETERS: CARRID TYPE SCREWS-CARRID OBLIGATORY,
            CONNID TYPE SCREWS-CONNID OBLIGATORY,
            FLDATE TYPE SCREWS-FLDATE OBLIGATORY.

* An internal table with the same structure as the view is declared
DATA: ICREW TYPE STANDARD TABLE OF SCREWS WITH HEADER LINE.

* The data of the is read into the internal table ICREW
SELECT * FROM SCREWS INTO TABLE ICREW WHERE
  CARRID = CARRID AND CONNID = CONNID AND FLDATE = FLDATE.

IF SY-DBCNT = 0.
  Write: / 'No data for this flight found'(200).
  EXIT.
ENDIF.

* Output of the results
WRITE: / 'Crew for flight'(005), CARRID, CONNID NO-ZERO,
         'at'(006), FLDATE.
NEW-LINE.

READ TABLE ICREW WITH KEY ROLE = 'PILOT'.
WRITE: /3 'from'(007), 9 ICREW-COUNTRYFR, 12 ICREW-CITYFROM. NEW-LINE.
WRITE: /5 'to'(008), 9 ICREW-COUNTRYTO, 12 ICREW-CITYTO.
NEW-LINE. SKIP.

* Output of the results
WRITE: / 'Function'(001), 18 'Name'(002), 38 'First Name'(003),
          54 'Pers.No.'(004).
NEW-LINE.

ULINE 1(63). NEW-LINE.

* The name of the pilot is read from the internal table icrew
WRITE: 'Pilot' UNDER 'Function'(001),
       ICREW-LAST_NAME UNDER 'Name'(002),
       ICREW-FIRST_NAME UNDER 'First Name'(003),
       ICREW-EMP_NUM NO-ZERO UNDER 'Pers. No.'(004).
NEW-LINE.

* The co-pilot is read from the internal table icrew
READ TABLE ICREW WITH KEY ROLE = 'CO-PILOT'.
WRITE: 'Co-Pilot' UNDER 'Function'(001),
       ICREW-LAST_NAME UNDER 'Name'(002),
       ICREW-FIRST_NAME UNDER 'First Name'(003),
       ICREW-EMP_NUM NO-ZERO UNDER 'Pers. No.'(004).
NEW-LINE.

* All stewards are listed
LOOP AT ICREW WHERE ROLE = 'STEWARD'.
  WRITE: 'Steward' UNDER 'Function'(001),
         ICREW-LAST_NAME UNDER 'Name'(002),
         ICREW-FIRST_NAME UNDER 'First Name'(003),
         ICREW-EMP_NUM NO-ZERO UNDER 'Pers. No.'(004).
  NEW-LINE.
ENDLOOP.
