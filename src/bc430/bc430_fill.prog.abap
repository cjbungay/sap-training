REPORT BC430_FILL .

***********************************************************************
* This report generates the example data for course BC430             *
* (ABAP Dictionary). The tables SEMPLOYES, SFLCREW, SDEPMENT and      *
* SDEPMENTT are filled with example data for the carriers LH, AA      *
* and BA. The number of generated employees can be selected in the    *
* start screen per carrier id.                                        *
***********************************************************************

TABLES: SEMPLOYES, SFLCREW, SFLIGHT, SDEPMENT, SDEPMENTT, BC430_DS.

DATA: ISEMPLOYES LIKE SEMPLOYES OCCURS 100 WITH HEADER LINE.
DATA: ISCREW LIKE SFLCREW OCCURS 100 WITH HEADER LINE.
DATA: ISDEPMENT LIKE SDEPMENT OCCURS 20 WITH HEADER LINE.
DATA: ISDEPMENTT LIKE SDEPMENTT OCCURS 20 WITH HEADER LINE.

DATA: CLIENT LIKE SEMPLOYES-CLIENT,
      CARRIER LIKE SEMPLOYES-CARRIER,
      CA_CURR LIKE SEMPLOYES-CURRENCY,
      LOOPVAR TYPE I,
      PERSONS TYPE I.

* Internal table to collect the last names
DATA: BEGIN OF LASTNAMES OCCURS 40,
        LASTNAME LIKE SEMPLOYES-LAST_NAME,
      END OF LASTNAMES.
* Internal table to collect the first names
DATA: BEGIN OF FIRSTNAMES OCCURS 40,
        FIRSTNAME LIKE SEMPLOYES-FIRST_NAME,
      END OF FIRSTNAMES.
* Internal table to collect the departments
DATA: BEGIN OF DEPARTMENTS OCCURS 40,
        DEPARTMENT LIKE SEMPLOYES-DEPARTMENT,
      END OF DEPARTMENTS.
* Internal tables to collect the pilots
DATA: BEGIN OF PILOTS OCCURS 50,
        EMPNUM LIKE SEMPLOYES-EMP_NUM,
        LASTNAME LIKE SEMPLOYES-LAST_NAME,
        FIRSTNAME LIKE SEMPLOYES-FIRST_NAME,
      END OF PILOTS.
* Internal tables to collect the stewards/stewardesses
DATA: BEGIN OF STEWARDS OCCURS 50,
        EMPNUM LIKE SEMPLOYES-EMP_NUM,
        LASTNAME LIKE SEMPLOYES-LAST_NAME,
        FIRSTNAME LIKE SEMPLOYES-FIRST_NAME,
      END OF STEWARDS.

* Flag to initialize the random number generator
DATA: MERKER TYPE I.
MERKER = 0.

***********************************************************************
*          Makro definitions used in the report                       *
***********************************************************************

DEFINE DEP_FILL_IN.
  ISDEPMENT-DEPARTMENT = &1.
  ISDEPMENT-TELNR = &2.
  ISDEPMENT-FAXNR = &3.
  APPEND ISDEPMENT.
END-OF-DEFINITION.

DEFINE DEP_TEXT_FILL_IN.
 ISDEPMENTT-DEPARTMENT = &1.
 ISDEPMENTT-LANGU = &2.
 ISDEPMENTT-TEXT = &3.
 APPEND ISDEPMENTT.
END-OF-DEFINITION.

***********************************************************************
* Selection-Screen                                                    *
***********************************************************************

SELECTION-SCREEN COMMENT /2(80) text-002.
SELECTION-SCREEN COMMENT /2(80) text-003.
SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK BL1
                          WITH FRAME TITLE TEXT-001.
parameters: LH_PERS like persons default 1000,
            AA_PERS like persons default 1000,
            BA_PERS like persons default 1000.
*>>         <XX>_PERS like persons default 1000.
SELECTION-SCREEN END OF BLOCK BL1.

SELECTION-SCREEN SKIP.
SELECTION-SCREEN COMMENT /2(80) text-004.
SELECTION-SCREEN COMMENT /2(80) text-005.

SELECTION-SCREEN SKIP.
SELECTION-SCREEN COMMENT /2(80) text-006.

***********************************************************************
* Main Program                                                        *
***********************************************************************

CLIENT = SY-MANDT.

* To speed up the later inserts all entries in the tables are
* deleted
PERFORM DELETE_ALL_ENTRIES.

* Fill in data for carrier Lufthansa with german employee names
IF LH_PERS GT 0.
  CARRIER = 'LH '.
  CA_CURR = 'EUR  '.
  PERSONS = LH_PERS.
  PERFORM FILL_TABLES.
  MERKER = 0.
ENDIF.

* Fill in data for carrier American Airlines with english employee
* names
IF LH_PERS GT 0.
  CARRIER = 'AA '.
  CA_CURR = 'USD  '.
  PERSONS = AA_PERS.
  PERFORM FILL_TABLES.
  MERKER = 0.
ENDIF.

* Fill in data for carrier British Airways with british employee names
IF LH_PERS GT 0.
  CARRIER = 'BA '.
  CA_CURR = 'EUR  '.
  PERSONS = BA_PERS.
  PERFORM FILL_TABLES.
  MERKER = 0.
ENDIF.

* Fill in data for carrier 'xxx' with employes names defined in the
* FORMS FILL_LAST_NAMES_<LANG> and FILL_FIRST_NAMES_<LANG>.
* The CARRIER must be taken from SCARR and CA_CURR is the currency of
* this carrier (field CURRCODE in SCARR). PERSONS is the number of
* employes which are generated for a carrier.
*>> carrier = 'XX'.
*>> ca_curr = 'xxxxx'.
*>> persons = 'XX_PERS'.
*>> perform fill_tables.

* Write Message in BC430_DS
* The table BC430_DS contains the information about date and time of
* the creation of the data
BC430_DS-REPORT = 'BC430_FILL'.
BC430_DS-CR_DATE = SY-DATUM.
BC430_DS-CR_TIME = SY-UZEIT.
BC430_DS-CR_USER = SY-UNAME.
INSERT BC430_DS.

***********************************************************************
* FILL_TABLES                                                         *
* Fills the tables SDEPMENT, SDEPMENTT,SEMPLOYES, SFLCREW with data.  *
* CLIENT, CARRIER, PERSONS and CA_CURR must be specified.             *
***********************************************************************

FORM FILL_TABLES.

* Fills the table SDEPMENT depending on carrier
CASE CARRIER.
  WHEN 'LH'.  PERFORM FILL_SDEPMENT_LH.
  WHEN 'AA'.  PERFORM FILL_SDEPMENT_AA.
  WHEN 'BA'.  PERFORM FILL_SDEPMENT_BA.
*>> WHEN 'XX'. PERFORM FILL_SDEPMENT_XX.
ENDCASE.
* Fills the table SEMPLOYES with names
PERFORM FILL_SEMPLOYES.
* Assigns a crew to every flight. Data are stored in SFLCREW
PERFORM ASSIGN_CREW_TO_FLIGHT.
* Deletes the names from the internal tables. Necessary because for
* different carriers different names (for example common english or
* common german names are used)
PERFORM CLEAR_NAMES.

ENDFORM.

***********************************************************************
* FILL_SDEPMENT_LH                                                    *
* Fills the departments for LH into SDEPMENT and SDEPMENTT            *
***********************************************************************

FORM FILL_SDEPMENT_LH.

* FIRST STEP: Fill in the departments
 ISDEPMENT-CLIENT = CLIENT.
 ISDEPMENT-CARRIER = 'LH'.

* Press department
  DEP_FILL_IN 'PRES' '+49 069 / 45112' '+49 069 / 45113'.
* Central Administration
  DEP_FILL_IN 'ADMI'  '+49 089 / 5322' '+49 089 / 5323'.
* Security service
  DEP_FILL_IN 'SECU' '+49 069 / 489 222' '+49 069 / 489 223'.
* Marketing Germany
  DEP_FILL_IN 'MAR1' '+49 0211 / 41190' '+49 0211 / 41191'.
* Marketing International
  DEP_FILL_IN 'MAR2' '+01 33303 / 73 - 3321' '+01 33303 / 73 - 3322'.
* Service Germany
  DEP_FILL_IN 'SEDE' '+49 069 / 4013' '+49 069 / 4014'.
* Service America
  DEP_FILL_IN 'SEAM' '+01 089 / 7845' '+01 089 / 7846'.
* Service Asia
  DEP_FILL_IN 'SEAS' '+34 0211 / 25669' '+34 0211 / 25670'.
* Pilots
  DEP_FILL_IN 'PILO' '+49 069 / 22113' '+49 069 / 22114'.
* Stewards/Stewardesses
  DEP_FILL_IN 'STEW' '+49 069 / 22118' '+49 069 / 22119'.

* Fill in the data into SDEPMENT
INSERT SDEPMENT FROM TABLE ISDEPMENT ACCEPTING DUPLICATE KEYS.

* SECOND STEP: Fill in the department texts in german and english
 ISDEPMENTT-CLIENT = CLIENT.
 ISDEPMENTT-CARRIER = 'LH'.

* Press department
 DEP_TEXT_FILL_IN 'PRES' 'D' 'Information und Presse'.
 DEP_TEXT_FILL_IN 'PRES' 'E' 'Information and press'.
* Central Administration
 DEP_TEXT_FILL_IN 'ADMI' 'D' 'Zentrale Verwaltung'.
 DEP_TEXT_FILL_IN 'ADMI' 'E' 'Central Administration'.
* Security service
 DEP_TEXT_FILL_IN 'SECU' 'D' 'Sicherheitsdienst'.
 DEP_TEXT_FILL_IN 'SECU' 'E' 'Corporate Security'.
* Marketing Germany
 DEP_TEXT_FILL_IN 'MAR1' 'D' 'Marketing Deutschland'.
 DEP_TEXT_FILL_IN 'MAR1' 'E' 'Marketing Germany'.
* Marketing International
 DEP_TEXT_FILL_IN 'MAR2' 'D' 'Internationales Marketing'.
 DEP_TEXT_FILL_IN 'MAR2' 'E' 'International Marketing'.
* Service Germany
 DEP_TEXT_FILL_IN 'SEDE' 'D' 'Service Deutschland'.
 DEP_TEXT_FILL_IN 'SEDE' 'E' 'Service Germany'.
* Service America
 DEP_TEXT_FILL_IN 'SEAM' 'D' 'Service USA, Suedamerika'.
 DEP_TEXT_FILL_IN 'SEAM' 'E' 'Service US, South America'.
* Service Asia
 DEP_TEXT_FILL_IN 'SEAS' 'D' 'Service Asien'.
 DEP_TEXT_FILL_IN 'SEAS' 'E' 'Service Asia'.
* Pilots
 DEP_TEXT_FILL_IN 'PILO' 'D' 'Piloten'.
 DEP_TEXT_FILL_IN 'PILO' 'E' 'Pilots'.
* Stewards/Stewardesses
 DEP_TEXT_FILL_IN 'STEW' 'D' 'Flugbegleiter'.
 DEP_TEXT_FILL_IN 'STEW' 'E' 'Stewards'.

* Fill in the data into SDEPMENTT with German and English texts
INSERT SDEPMENTT FROM TABLE ISDEPMENTT ACCEPTING DUPLICATE KEYS.

ENDFORM.

***********************************************************************
* FILL_SDEPMENT_AA                                                    *
* Fills the departments for LH into SDEPMENT and SDEPMENTT            *
***********************************************************************

FORM FILL_SDEPMENT_AA.

 ISDEPMENT-CLIENT = CLIENT.
 ISDEPMENT-CARRIER = 'AA'.

* Information
  DEP_FILL_IN 'PRES' '+01 330 / 33 345 112' '+01 330 / 33 345 113'.
* Central Management
  DEP_FILL_IN 'ADMI' '+01 22 333 / 52 1322' '+01 22 333 / 52 1323'.
* Security service
  DEP_FILL_IN 'SECU' '+01 206 19 / 14 89 211' '+01 206 19 / 14 89 212'.
* Marketing
  DEP_FILL_IN 'MARK' '+01 2332 78 / 23 190' '+01 2332 78 / 23 191'.
* Local Management US
  DEP_FILL_IN 'LMUS' '+01 928 03 / 713 21' '+01 928 03 / 713 22'.
* Local Management America
  DEP_FILL_IN 'LMAM' '+23 7657 / 23 4013' '+23 7657 / 23 4014'.
* Local Management Europe
  DEP_FILL_IN 'LMEU' '+49 1291 / 738 45' '+49 12 91 / 738 46'.
* Local Management Asia
  DEP_FILL_IN 'LMAS' '+34 334 01 / 23 669' '+34 334 01 / 23 670'.
* Pilots
  DEP_FILL_IN 'PILO' '+01 334 02 / 232 113' '+01 334 02 / 232 114'.
* Stewards/Stewardesses
  DEP_FILL_IN 'STEW' '+01 334 08 / 232 118' '+01 334 08 / 232 119'.

* Fill in the data into SDEPMENT
INSERT SDEPMENT FROM TABLE ISDEPMENT ACCEPTING DUPLICATE KEYS.


* SECOND STEP: Fill in the department texts in german and english
 ISDEPMENTT-CLIENT = CLIENT.
 ISDEPMENTT-CARRIER = 'AA'.

* Press department
 DEP_TEXT_FILL_IN 'PRES' 'D' 'Information und Presse'.
 DEP_TEXT_FILL_IN 'PRES' 'E' 'Corporate Information'.
* Central Administration
 DEP_TEXT_FILL_IN 'ADMI' 'D' 'Zentrale Verwaltung'.
 DEP_TEXT_FILL_IN 'ADMI' 'E' 'Central Management'.
* Security service
 DEP_TEXT_FILL_IN 'SECU' 'D' 'Sicherheitsdienst'.
 DEP_TEXT_FILL_IN 'SECU' 'E' 'Security department'.
* Marketing
 DEP_TEXT_FILL_IN 'MARK' 'D' 'Marketing'.
 DEP_TEXT_FILL_IN 'MARK' 'E' 'Marketing'.
* Local Management US
 DEP_TEXT_FILL_IN 'LMUS' 'D' 'Serviceabteilung USA'.
 DEP_TEXT_FILL_IN 'LMUS' 'E' 'Service Staff US'.
* Local Management America
 DEP_TEXT_FILL_IN 'LMAM' 'D' 'Serviceabteilung Amerika'.
 DEP_TEXT_FILL_IN 'LMAM' 'E' 'Service Staff America'.
* Local Management Europe
 DEP_TEXT_FILL_IN 'LMEU' 'D' 'Serviceabteilung Europa'.
 DEP_TEXT_FILL_IN 'LMEU' 'E' 'Service Staff Europe'.
* Local Management Asia
 DEP_TEXT_FILL_IN 'LMAS' 'D' 'Serviceabteilung Asien'.
 DEP_TEXT_FILL_IN 'LMAS' 'E' 'Service Staff Asia'.
* Pilots
 DEP_TEXT_FILL_IN 'PILO' 'D' 'Piloten'.
 DEP_TEXT_FILL_IN 'PILO' 'E' 'Pilots'.
* Stewards/Stewardessen
 DEP_TEXT_FILL_IN 'STEW' 'D' 'Flugbegleiter'.
 DEP_TEXT_FILL_IN 'STEW' 'E' 'Stewards'.

* Fill in the data into SDEPMENTT with German and English texts
INSERT SDEPMENTT FROM TABLE ISDEPMENTT ACCEPTING DUPLICATE KEYS.

ENDFORM.

***********************************************************************
* FILL_SDEPMENT_BA                                                    *
* Fills the departments for LH into SDEPMENT and SDEPMENTT            *
***********************************************************************

FORM FILL_SDEPMENT_BA.

 ISDEPMENT-CLIENT = CLIENT.
 ISDEPMENT-CARRIER = 'BA'.

* Press department
  DEP_FILL_IN 'PRES' '+44 3340 / 334 5112' '+44 3340 / 334 5113'.
* Central Administration
  DEP_FILL_IN 'ADMI' '+44 522 333 / 352 322' '+44 522 333 / 352 323'.
* Security service
  DEP_FILL_IN 'SECU' '+44 206 19 / 41 211' '+44 206 19 / 41 212'.
* Marketing Great Britain
  DEP_FILL_IN 'MAGB' '+44 2332 78 / 523 190' '+44 2332 78 / 523 191'.
* Marketing Commonwealth
  DEP_FILL_IN 'MACO' '+44 928 03 / 87 521' '+44 928 03 / 87 522'.
* Marketing Rest of the world
  DEP_FILL_IN 'MARW' '+01 7657 / 789 991' '+01 7657 / 789 991'.
* Service GB
  DEP_FILL_IN 'SER1' '+44 12 91 / 348 45' '+44 12 91 / 348 46'.
* Service Rest
  DEP_FILL_IN 'SER2' '+44 334 01 / 244 669' '+44 334 01 / 244 670'.
* Pilots
  DEP_FILL_IN 'PILO' '+44 34 02 / 232 113' '+44 34 02 / 232 114'.
* Stewards/Stewardesses
  DEP_FILL_IN 'STEW' '+44 444 08 / 232 118' '+44 444 08 / 232 119'.

* Fill in the data into SDEPMENT
INSERT SDEPMENT FROM TABLE ISDEPMENT ACCEPTING DUPLICATE KEYS.


* SECOND STEP: Fill in the department texts in german and english
 ISDEPMENTT-CLIENT = CLIENT.
 ISDEPMENTT-CARRIER = 'BA'.

* Press department
 DEP_TEXT_FILL_IN 'PRES' 'D' 'Informationsabteilung'.
 DEP_TEXT_FILL_IN 'PRES' 'E' 'Information department'.
* Central Administration
 DEP_TEXT_FILL_IN 'ADMI' 'D' 'Verwaltung'.
 DEP_TEXT_FILL_IN 'ADMI' 'E' 'Central Administration'.
* Security service
 DEP_TEXT_FILL_IN 'SECU' 'D' 'Sicherheitsdienst'.
 DEP_TEXT_FILL_IN 'SECU' 'E' 'Security department'.
* Marketing Großbritanien
 DEP_TEXT_FILL_IN 'MAGB' 'D' 'Marketing Grossbritanien'.
 DEP_TEXT_FILL_IN 'MAGB' 'E' 'Marketing GB'.
* Marketing Commonwealth
 DEP_TEXT_FILL_IN 'MAR2' 'D' 'Marketing Commonwealth'.
 DEP_TEXT_FILL_IN 'MAR2' 'E' 'Marketing Commonwealth'.
* Marketing rest of the world
 DEP_TEXT_FILL_IN 'MAI1' 'D' 'Internationales Marketing'.
 DEP_TEXT_FILL_IN 'MAI1' 'E' 'Marketing International'.
* Service GB
 DEP_TEXT_FILL_IN 'MAI2' 'D' 'Service Grossbritanien'.
 DEP_TEXT_FILL_IN 'MAI2' 'E' 'Service GB'.
* Service Rest
 DEP_TEXT_FILL_IN 'SELL' 'D' 'Internationaler Service'.
 DEP_TEXT_FILL_IN 'SELL' 'E' 'Service international'.
* Pilots
 DEP_TEXT_FILL_IN 'PILO' 'D' 'Piloten'.
 DEP_TEXT_FILL_IN 'PILO' 'E' 'Pilots'.
* Stewards/Stewardesses
 DEP_TEXT_FILL_IN 'STEW' 'D' 'Flugbegleiter'.
 DEP_TEXT_FILL_IN 'STEW' 'E' 'Stewards'.

* Fill in the data into SDEPMENTT with German and English texts
INSERT SDEPMENTT FROM TABLE ISDEPMENTT ACCEPTING DUPLICATE KEYS.

ENDFORM.

***********************************************************************
* FILL_SDEPMENT_XX                                                    *
* Fills the departments for XX into SDEPMENT and SDEPMENTT            *
***********************************************************************

*>> FORM FILL_SDEPMENT_XX.

* FIRST STEP: Fill in the departments
*>>  ISDEPMENT-CLIENT = CLIENT.
*>>  ISDEPMENT-CARRIER = 'LH'.

* Copy the following lines for each department XXXX you want to create:
* Department XX
*>>   DEP_FILL_IN 'XXXX' '+49 069 / 45112' '+49 069 / 45113'.

* The following to departments MUST be created:
* Pilots
*>>   DEP_FILL_IN 'PILO' '+49 069 / 22113' '+49 069 / 22114'.
* Stewards/Stewardesses
*>>   DEP_FILL_IN 'STEW' '+49 069 / 22118' '+49 069 / 22119'.

* Fill in the data into SDEPMENT
*>> INSERT SDEPMENT FROM TABLE ISDEPMENT ACCEPTING DUPLICATE KEYS.

* SECOND STEP: Fill in the department texts in english and your
* chosen language X
*>> ISDEPMENTT-CLIENT = CLIENT.
*>> ISDEPMENTT-CARRIER = 'XX'.

* Copy the following 3 lines for each of your departments
* Your department XXXX
*>>  DEP_TEXT_FILL_IN 'XXXX' 'X' 'Information und Presse'.
*>>  DEP_TEXT_FILL_IN 'XXXX' 'E' 'Information and press'.

* The following lines MUST be contained:
* Pilots
*>> DEP_TEXT_FILL_IN 'PILO' 'X' 'XXXXXXX'.
*>> DEP_TEXT_FILL_IN 'PILO' 'E' 'Pilots'.
* Stewards/Stewardesses
*>> DEP_TEXT_FILL_IN 'STEW' 'X' 'XXXXXXXXXX'.
*>> DEP_TEXT_FILL_IN 'STEW' 'E' 'Stewards'.

* Fill in the data into SDEPMENTT with German and English texts
*>>INSERT SDEPMENTT FROM TABLE ISDEPMENTT ACCEPTING DUPLICATE KEYS.

*>>ENDFORM.

***********************************************************************
* FILL_SEMPLOYES                                                      *
***********************************************************************

FORM FILL_SEMPLOYES.

STATICS: LAST_ANZ TYPE I,
         FIRST_ANZ TYPE I,
         DEP_ANZ TYPE I,
         PERSNR TYPE I,
         FIRST_IMOD TYPE I,
         LAST_IMOD TYPE I,
         DEP_IMOD TYPE I,
         BASE_AMMOUNT TYPE I,
         RAND_AMMOUNT TYPE I,
         RAND TYPE I,
         RAND1 TYPE I,
         RAND2 TYPE I,
         RAND3 TYPE I,
         RAND4 TYPE I.

* Fills the names tables in dependency of the carrier. For Lufthansa
* (LH) German names are used, for American Airlines (AA) and British
* Airways (BA) english names are used.
IF CARRIER = 'LH '.
 PERFORM FILL_LAST_NAMES_D.
 PERFORM FILL_FIRST_NAMES_D.
 PERFORM FILL_DEPARTMENTS.
ELSEIF CARRIER = 'AA '.
 PERFORM FILL_LAST_NAMES_E.
 PERFORM FILL_FIRST_NAMES_E.
 PERFORM FILL_DEPARTMENTS.
ELSEIF CARRIER = 'BA '.
 PERFORM FILL_LAST_NAMES_E.
 PERFORM FILL_FIRST_NAMES_E.
 PERFORM FILL_DEPARTMENTS.
*>>elseif carrier = 'xx'.
*>> perform fill_last_names_<lang>.
*>> perform fill_first_names_<lang>.
*>> perform fill_departments.
ENDIF.

* Counts the number of available first names, last names and functions
LAST_ANZ = 0.
FIRST_ANZ = 0.
DEP_ANZ = 0.

LOOP AT LASTNAMES.
 ADD 1 TO LAST_ANZ.
ENDLOOP.

LOOP AT FIRSTNAMES.
 ADD 1 TO FIRST_ANZ.
ENDLOOP.

LOOP AT DEPARTMENTS.
 ADD 1 TO DEP_ANZ.
ENDLOOP.

* Loop over the number of persons to be created
ISEMPLOYES-CLIENT = CLIENT.
ISEMPLOYES-CARRIER = CARRIER.
ISEMPLOYES-CURRENCY = CA_CURR.
PERSNR = 1.

DO PERSONS TIMES.

* Get 4 random numbers (for firstname, lastname, department,
* employee number)
 PERFORM GENERATE_RANDOM_NUMBER CHANGING RAND.
  RAND1 = RAND.
 PERFORM GENERATE_RANDOM_NUMBER CHANGING RAND.
  RAND2 = RAND.
 PERFORM GENERATE_RANDOM_NUMBER CHANGING RAND.
  RAND3 = RAND.
 PERFORM GENERATE_RANDOM_NUMBER CHANGING RAND.
  RAND4 = RAND.

 PERSNR = PERSNR + ( RAND1 MOD 23 ) + 1.
 ISEMPLOYES-EMP_NUM = PERSNR.

* Find the first name randomly
FIRST_IMOD = ( RAND2 MOD FIRST_ANZ ) + 1.
READ TABLE FIRSTNAMES INDEX FIRST_IMOD.
ISEMPLOYES-FIRST_NAME = FIRSTNAMES-FIRSTNAME.

* Find the last name randomly
LAST_IMOD = ( RAND3 MOD LAST_ANZ ) + 1.
READ TABLE LASTNAMES INDEX LAST_IMOD.
ISEMPLOYES-LAST_NAME = LASTNAMES-LASTNAME.

* Find the department randomly
DEP_IMOD = ( RAND4 MOD DEP_ANZ ) + 1.
READ TABLE DEPARTMENTS INDEX DEP_IMOD.
ISEMPLOYES-DEPARTMENT = DEPARTMENTS-DEPARTMENT.

* Find the area code
CASE ISEMPLOYES-DEPARTMENT.
  WHEN 'PILO'. ISEMPLOYES-AREA = 'F'.
  WHEN 'STEW'. ISEMPLOYES-AREA = 'F'.
  WHEN 'SER1'. ISEMPLOYES-AREA = 'S'.
  WHEN 'SER2'. ISEMPLOYES-AREA = 'S'.
  WHEN 'PRES'. ISEMPLOYES-AREA = 'S'.
  WHEN 'SECU'. ISEMPLOYES-AREA = 'S'.
  WHEN 'SEDE'. ISEMPLOYES-AREA = 'S'.
  WHEN 'SEAM'. ISEMPLOYES-AREA = 'S'.
  WHEN 'SEAS'. ISEMPLOYES-AREA = 'S'.
  WHEN OTHERS. ISEMPLOYES-AREA = 'A'.
ENDCASE.

* Determine the salary
CASE ISEMPLOYES-AREA.
  WHEN 'P'. BASE_AMMOUNT = '5000'.
  WHEN 'S'. BASE_AMMOUNT = '2500'.
  WHEN OTHERS. BASE_AMMOUNT = '2000'.
ENDCASE.

RAND_AMMOUNT = ( ( RAND1 + RAND2 ) * RAND3 ) + RAND4.
RAND_AMMOUNT = RAND_AMMOUNT MOD 4000.
ISEMPLOYES-SALARY = BASE_AMMOUNT + RAND_AMMOUNT.

* Append the created employee to the internal table
APPEND ISEMPLOYES.

ENDDO.

* Write the data to SEMPLOYES
INSERT SEMPLOYES FROM TABLE ISEMPLOYES ACCEPTING DUPLICATE KEYS.

ENDFORM.

***********************************************************************
* FILL_LAST_NAMES_D                                                   *
* Creates a number of common german last names                        *
***********************************************************************

FORM FILL_LAST_NAMES_D.

constants german_last_names1(255) type c value
 'MEIER,MUELLER,SCHMIDT,LOHMANN,SCHMID,MEISTER,SCHMITT,LOBER,SOMMER,
 STEINER,BOMMER,MEHLHORN,MUSTER,FEIST,HERB,BERG,BAUER,LORANT,FROEBE,
 FREGE,BERGER,METZGER,BRAUN,KOHL,BECK,SAENGER,BUSCH,SCHNEIDER,HEINRICH,
 GRABOWSKI,SAUER,MEUER,MAURER'.

constants german_last_names2(255) type c value
 'SPANGER,SCHEUER,MENDEL,MAURITZ,WEIN,GLOEDE,HUBER,KUNTZ,BAIERHAMMER,
 HORN,BACH,WEBER,WEINDL,TURBA,LINDENBERG,HAGEN,STOLLE,STEMMLER,
 MAURITZ,WALTER,WAGNER,LOHMUELLER,KOEHLER,MERTENS,STAHL,FISCHER,
 HEINATZ,BURGERT,BANNERT,LAGES'.

data: german_last_names type string.
concatenate german_last_names1 german_last_names2 into
            german_last_names separated by ','.

condense german_last_names no-gaps.
split german_last_names at ',' into table lastnames.

ENDFORM.

***********************************************************************
* FILL_LAST_NAMES_E                                                   *
* Creates a number of common english last names                       *
***********************************************************************

FORM FILL_LAST_NAMES_E.

constants english_last_names1(255) type c value
 'CLARK,SMITH,WATSON,WALKER,MILL,TAYLOR,POWELL,FRANK,CURRY,KIRBY,
 DANIELS,FISHER,CARPENTER,TURNER,CARTWRIGHT,WRIGHT,DOLE,JEFFERSON,
 WASHINGTON,ADAMS,CALLAHAN,WHITE,BROWN,ROTH,MAJOR,COOPER,MC DONALD,
 BUSH,SIMPSON,WILDER,PFEIFFER,ROBERTSON'.

constants english_last_names2(255) type c value
 'BARKER,LAUREL,HARDY,CHAPLIN,MORGAN,CRAWFORD,WILSON,GRAY,GREEN,WHITE,
 KEMPE,COOPER,COLLINS,CLINTON,YIN,DA SILVA,DONNALDSON,ERICSON,QIN,
 MAYOR,MORGAN,MARTINSON,PARKINSON,MC NEILL,BATTISTA,BORGES,CARAVELLI,
 MARINETTI,ANTONELLI,CARDINALE'.

data: english_last_names type string.
concatenate english_last_names1 english_last_names2 into
            english_last_names separated by ','.

condense english_last_names no-gaps.
split english_last_names at ',' into table lastnames.

ENDFORM.

***********************************************************************
* FILL_FIRST_NAMES_D                                                  *
* Creates a number of common german first names                       *
***********************************************************************

FORM FILL_FIRST_NAMES_D.

constants german_first_names1(255) type c value
 'ANNETTE,HORST,STEPHAN,DORIS,BERND,ANGELIKA,JOCHEN,KATRIN,EDGAR,
 ULRICH,INGRID,BORIS,IVONNE,PETER,PETRA,KLAUS,JESSICA,GERHARD,
 CHRISTIANE,PAUL,KERSTIN,ULRIKE,FRANZ,MARKUS,INGE,STEFFEN,LOTHAR,
 CHRISTIAN,DIETMAR,DIETRICH,JUDITH'.

constants german_first_names2(255) type c value
 'GABI,UTE,KARL,KAREN,HELMUT,MARTIN,HERMANN,MARIA,MARGIT,THEA,IRENE,
 BARBARA,MADLEINE,MAREN,MYRIAM,RACHEL,ISABELL,AGNES,CAROLINE,SIGRID,
 SIEGFRIED,EBERHART,CONNI,SABRINA,SABINE,SARAH,SANDRA,RALF,ROMAN,
 NELLY,GUENTHER'.

data: german_first_names type string.
concatenate german_first_names1 german_first_names2 into
            german_first_names separated by ','.

condense german_first_names no-gaps.
split german_first_names at ',' into table firstnames.

ENDFORM.

***********************************************************************
* FILL_FIRST_NAMES_E                                                  *
* Creates a number of common english first names                      *
***********************************************************************

FORM FILL_FIRST_NAMES_E.

constants english_first_names1(255) type c value
 'ANNE,CHARLES,DIANA,EDWARD,ANDREW,PHILIP,SARAH,ELIZABETH,ALISON,
 DAVID,PAUL,CHRISTINE,PETER,NEIL,EMMA,CLAIRE,SOPHIE,RACHEL,DANIEL,
 JOHN,JAMES,GEORGE,ALBERT,MARK,FLORA,ESTHER,JUDITH,MIRIAM,BEVERLY,
 MARTIN,DENNIS,WILLIAM,SIMON'.

constants english_first_names2(255) type c value
 'PRISCILLA,JENNIFER,NICKOLAS,TRACY,SUSAN,BENJAMIN,JOANNE,CLAUDIA,
 SPENCER,STANLEY,OLIVER,BILL,LIZ,CORINNE,SANDY,WILL,WENDY,IGOR,FRANK,
 RAE,WILL,MARK,PHLI,RUDY,CARL,JOSEPH,MURRAY,JEFF,HERB'.

data: english_first_names type string.
concatenate english_first_names1 english_first_names2 into
            english_first_names separated by ','.

condense english_first_names no-gaps.
split english_first_names at ',' into table firstnames.

ENDFORM.

***********************************************************************
* FORM FILL_LAST_NAMES_<LANG>.                                        *
* Creates the last names in customer language.                        *
***********************************************************************

* Add a sufficiently large number (>30) of names to ensure that the
* generated data look natural!

*>>FORM FILL_LAST_NAMES_<LANG>.

*>>constants cust_last_names1(255) type c value
*>> 'NAME1,NAME2,.... '.

*>>constants cust_last_names2(255) type c value
*>> 'NAME1,NAME2,.... '.

* Make sure that the literals 'NAME1,...' contain at most 250
* characters! This is an ABAP restriction.

*>>data: cust_last_names type string.
*>>concatenate cust_last_names1 cust_last_names2 into
*>>            cust_last_names separated by ','.

*>>condense cust_last_names no-gaps.
*>>split cust_last_names at ',' into table lastnames.

*>>ENDFORM.

***********************************************************************
* FORM FILL_LAST_NAMES_<LANG>.                                        *
* Creates the last names in customer language.                        *
***********************************************************************

* Add a sufficiently large number (>30) of names to ensure that the
* generated data look natural!

*>>FORM FILL_FIRST_NAMES_<LANG>.

*>>constants cust_first_names1(255) type c value
*>> 'NAME1,NAME2,.... '.

*>>constants cust_first_names2(255) type c value
*>> 'NAME1,NAME2,.... '.

* Make sure that the literals 'NAME1,...' contain at most 250
* characters! This is an ABAP restriction.

*>>data: cust_first_names type string.
*>>concatenate cust_first_names1 cust_first_names2 into
*>>            cust_first_names separated by ','.

*>>condense cust_first_names no-gaps.
*>>split cust_first_names at ',' into table lastnames.

*>>ENDFORM.

***********************************************************************
* CLEAR_NAMES                                                         *
* Function: Deletes all names from the internal tables FIRSTNAMES,    *
*           LASTNAMES, FUNCTIONS, PILOTS, CHIEFSTEWS, STEWARDS and    *
*           ISCREW                                                    *
***********************************************************************

FORM CLEAR_NAMES.

REFRESH FIRSTNAMES.
REFRESH LASTNAMES.
REFRESH DEPARTMENTS.
REFRESH PILOTS.
REFRESH STEWARDS.
REFRESH ISCREW.

ENDFORM.

***********************************************************************
* FILL_DEPARTMENTS                                                    *
* Fills the available departments for the carrier into DEPARTMENTS    *
***********************************************************************

FORM FILL_DEPARTMENTS.

SELECT * FROM SDEPMENT WHERE CARRIER = CARRIER.
  DEPARTMENTS-DEPARTMENT = SDEPMENT-DEPARTMENT.
  APPEND DEPARTMENTS.
ENDSELECT.

* To increase the number of pilots and stewards some dummy entries
* are added to DEPARTMENTS
DEPARTMENTS-DEPARTMENT = 'PILO'.
APPEND DEPARTMENTS.

DO 3 TIMES.
  DEPARTMENTS-DEPARTMENT = 'STEW'.
  APPEND DEPARTMENTS.
ENDDO.

ENDFORM.

***********************************************************************
*  ASSIGN_CREW_TO_FLIGHT                                              *
*  Fills the table SFLCREW with data                                  *
***********************************************************************

FORM ASSIGN_CREW_TO_FLIGHT.

DATA: PILOT_C TYPE I,
      STEW_C TYPE I,
      PILOT_NUM TYPE I,
      STEW_NUM TYPE I.

PILOT_C = 1.
STEW_C = 1.
PILOT_NUM = 0.
STEW_NUM = 0.

* Find the names of pilots, chief-stewards and stewards
PERFORM FILL_CREW_TABLES.

* Count the number of available pilots, chief-stewards and stewards
LOOP AT PILOTS.
  ADD 1 TO PILOT_NUM.
ENDLOOP.

LOOP AT STEWARDS.
  ADD 1 TO STEW_NUM.
ENDLOOP.

* Fills the table SFLCREW
SELECT * FROM SFLIGHT WHERE CARRID = CARRIER.
  ISCREW-CLIENT = CLIENT.
  ISCREW-CARRID = SFLIGHT-CARRID.
  ISCREW-CONNID = SFLIGHT-CONNID.
  ISCREW-FLDATE = SFLIGHT-FLDATE.
* Assign a pilot
  READ TABLE PILOTS INDEX PILOT_C.
   ISCREW-EMP_NUM = PILOTS-EMPNUM.
   ISCREW-ROLE = 'PILOT'.
     IF PILOT_C < PILOT_NUM.
       ADD 1 TO PILOT_C.
     ELSE.
       PILOT_C = 1.
     ENDIF.
   APPEND ISCREW.
* Assign a co-pilot
  READ TABLE PILOTS INDEX PILOT_C.
   ISCREW-EMP_NUM = PILOTS-EMPNUM.
   ISCREW-ROLE = 'CO-PILOT'.
     IF PILOT_C < PILOT_NUM.
       ADD 1 TO PILOT_C.
     ELSE.
       PILOT_C = 1.
     ENDIF.
   APPEND ISCREW.
* Assign the stewards
  DO 8 TIMES.
    READ TABLE STEWARDS INDEX STEW_C.
      ISCREW-EMP_NUM = STEWARDS-EMPNUM.
      ISCREW-ROLE = 'STEWARD'.
        IF STEW_C < STEW_NUM.
          ADD 1 TO STEW_C.
        ELSE.
          STEW_C = 1.
        ENDIF.
      APPEND ISCREW.
  ENDDO.

ENDSELECT.

* Write the data to SFLCREW
INSERT SFLCREW FROM TABLE ISCREW ACCEPTING DUPLICATE KEYS.

ENDFORM.

***********************************************************************
* FILL_CREW_TABLES                                                    *
* Selects all pilots, chief stewards and stewards from the table      *
* SEMPLOYES and inserts them into internal tables for the pilots,     *
* the chief stewards and the stewards                                 *
***********************************************************************

FORM FILL_CREW_TABLES.

SELECT * FROM SEMPLOYES WHERE CARRIER = CARRIER.
  IF SEMPLOYES-DEPARTMENT = 'PILO'.
    PILOTS-EMPNUM = SEMPLOYES-EMP_NUM.
    PILOTS-LASTNAME = SEMPLOYES-LAST_NAME.
    PILOTS-FIRSTNAME = SEMPLOYES-FIRST_NAME.
    APPEND PILOTS.
  ELSEIF SEMPLOYES-DEPARTMENT = 'STEW'.
    STEWARDS-EMPNUM = SEMPLOYES-EMP_NUM.
    STEWARDS-LASTNAME = SEMPLOYES-LAST_NAME.
    STEWARDS-FIRSTNAME = SEMPLOYES-FIRST_NAME.
    APPEND STEWARDS.
  ENDIF.
ENDSELECT.

ENDFORM.

***********************************************************************
* GENERATE_RANDOM_NUMBER                                              *
* Generates a pseudo random number                                    *
***********************************************************************

FORM GENERATE_RANDOM_NUMBER CHANGING RAND TYPE I.

STATICS: RAND1 TYPE I,
         RAND2 TYPE I,
         RAND3 TYPE I,
         ZAEHL1 TYPE I,
         ZAEHL2 TYPE I,
         ZAEHL3 TYPE I,
         ZAEHL4 TYPE I,
         ZAEHL5 TYPE I,
         ZAEHL6 TYPE I.


* If the random number generator is called the first time the
* variables are set to their initial value.
IF MERKER = 0.
  ZAEHL1 = 3.
  ZAEHL2 = 5.
  ZAEHL3 = 7.
  ZAEHL4 = 19.
  ZAEHL5 = 11.
  ZAEHL6 = 13.
ENDIF.

* Produces the random number RAND as a function of three Fibonacci
* series
  RAND1 = ZAEHL1 + ZAEHL2.
  RAND2 = ZAEHL3 + ZAEHL4.
  RAND3 = ZAEHL5 + ZAEHL6.

  RAND1 = RAND1 MOD 131.
  RAND2 = RAND2 MOD 173.
  RAND3 = RAND3 MOD 231.

  ZAEHL1 = ZAEHL2.
  ZAEHL2 = RAND1.
  ZAEHL3 = ZAEHL4.
  ZAEHL4 = RAND2.
  ZAEHL5 = ZAEHL6.
  ZAEHL6 = RAND3.

  RAND = RAND1 + ( RAND2 * RAND3 ).

* Marks that the form was called at least one time
MERKER = 1.

ENDFORM.

*********************************************************************
* FORM DELETE_ALL_ENTRIES                                           *
* Löscht alle Datensätze aus den Vorlagen                           *
*********************************************************************

FORM DELETE_ALL_ENTRIES.

DELETE FROM SEMPLOYES CLIENT SPECIFIED WHERE CLIENT = SY-MANDT.
DELETE FROM SDEPMENT CLIENT SPECIFIED WHERE CLIENT = SY-MANDT.
DELETE FROM SDEPMENTT CLIENT SPECIFIED WHERE CLIENT = SY-MANDT.
DELETE FROM SFLCREW CLIENT SPECIFIED WHERE CLIENT = SY-MANDT.

COMMIT WORK.

ENDFORM.
