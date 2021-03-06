REPORT BC430_DEMO_FILL.

************************************************************************
* Fills the tables BC430TABA, BC430TABB, SCARGO, DANGER_NO, DANGER_NOT *
* with example data. This report is used for the trainer demo in the   *
* course BC430.                                                        *
************************************************************************

TABLES: BC430TABA, BC430TABB, SCARGO, DANGER_NO, DANGER_NOT.

TYPES: BEGIN OF CUSTOM_NR,
         NUMBER TYPE S_CUSTOMER,
       END OF CUSTOM_NR.

TYPES: BEGIN OF FRACHT,
         CARGO_DESC LIKE SCARGO-CARGO_DESC,
         CARGOTYPE LIKE SCARGO-CARGOTYPE,
         VALUE LIKE SCARGO-VALUE,
         CURRENCY LIKE SCARGO-CURRENCY,
       END OF FRACHT.

DATA: I_TABA TYPE BC430TABA OCCURS 10 WITH HEADER LINE,
      I_TABB TYPE BC430TABB OCCURS 10 WITH HEADER LINE,
      I_SCARGO TYPE SCARGO OCCURS 100 WITH HEADER LINE,
      I_DANGER_NO TYPE DANGER_NO OCCURS 100 WITH HEADER LINE,
      I_DANGER_NOT TYPE DANGER_NOT OCCURS 100 WITH HEADER LINE,
      I_SFLIGHT TYPE SFLIGHT OCCURS 100 WITH HEADER LINE,
      I_SCUSTOM TYPE SCUSTOM,
      FRACHT TYPE FRACHT OCCURS 20 WITH HEADER LINE.

DATA: CUST TYPE CUSTOM_NR OCCURS 100 WITH HEADER LINE.

* Makros
DEFINE ADD_DANGER_NO.
  I_DANGER_NO-DANGER_NO = '&1'.
  I_DANGER_NO-DANGER_KAT = '&2'.
  APPEND I_DANGER_NO.
END-OF-DEFINITION.

DEFINE ADD_DANGER_NOT.
  I_DANGER_NOT-DANGER_NO = '&1'.
  I_DANGER_NOT-LANGU = '&2'.
  I_DANGER_NOT-TEXT = &3.
  APPEND I_DANGER_NOT.
END-OF-DEFINITION.

DEFINE ADD_FRACHT.
  FRACHT-CARGO_DESC = &1.
  FRACHT-CARGOTYPE = '&2'.
  FRACHT-VALUE = '&3'.
  FRACHT-CURRENCY = '&4'.
  APPEND FRACHT.
END-OF-DEFINITION.

* Fill table BC430TABA
I_TABA-FIELD1 = '1'. I_TABA-FIELD2 = 'Text 1'. APPEND I_TABA.
I_TABA-FIELD1 = '2'. I_TABA-FIELD2 = 'Text 2'. APPEND I_TABA.

INSERT BC430TABA FROM TABLE I_TABA ACCEPTING DUPLICATE KEYS.

* Fill table BC430TABB
I_TABB-FIELD3 = '1'. I_TABB-FIELD4 = 'A'. I_TABB-FIELD5 = 'Text 3'.
APPEND I_TABB.
I_TABB-FIELD3 = '1'. I_TABB-FIELD4 = 'B'. I_TABB-FIELD5 = 'Text 4'.
APPEND I_TABB.
I_TABB-FIELD3 = '2'. I_TABB-FIELD4 = 'A'. I_TABB-FIELD5 = 'Text 5'.
APPEND I_TABB.
I_TABB-FIELD3 = '2'. I_TABB-FIELD4 = 'B'. I_TABB-FIELD5 = 'Text 6'.
APPEND I_TABB.

INSERT BC430TABB FROM TABLE I_TABB ACCEPTING DUPLICATE KEYS.

* Fill table DANGER_NO
ADD_DANGER_NO 1 HIGH.
ADD_DANGER_NO 2 MEDIUM.
ADD_DANGER_NO 3 LOW.
ADD_DANGER_NO 4 HIGH.
ADD_DANGER_NO 5 MEDIUM.
ADD_DANGER_NO 6 LOW.
ADD_DANGER_NO 7 HIGH.
ADD_DANGER_NO 8 MEDIUM.
ADD_DANGER_NO 9 LOW.
ADD_DANGER_NO 10 HIGH.
ADD_DANGER_NO 11 MEDIUM.
ADD_DANGER_NO 12 LOW.

INSERT DANGER_NO FROM TABLE I_DANGER_NO ACCEPTING DUPLICATE KEYS.

* Fill table DANGER_NOT with english and german texts
ADD_DANGER_NOT 1 D 'BENZIN'.
ADD_DANGER_NOT 2 D 'LEBENDE TIERE'.
ADD_DANGER_NOT 3 D 'BAKTERIEN'.
ADD_DANGER_NOT 4 D 'VIREN'.
ADD_DANGER_NOT 5 D 'NITRO-GLYZERIN'.
ADD_DANGER_NOT 6 D 'DYNAMIT'.
ADD_DANGER_NOT 7 D 'SCHWARZPULVER'.
ADD_DANGER_NOT 8 D 'URAN'.
ADD_DANGER_NOT 9 D 'KORSISCHER KAESE'.
ADD_DANGER_NOT 10 D 'FLUGBENZIN'.
ADD_DANGER_NOT 11 D 'PHOSPHOR'.
ADD_DANGER_NOT 12 D 'CHLOR'.

ADD_DANGER_NOT 1 E 'PETROL'.
ADD_DANGER_NOT 2 E 'LIVING ANIMALS'.
ADD_DANGER_NOT 3 E 'BACTERIA'.
ADD_DANGER_NOT 4 E 'VIRUSES'.
ADD_DANGER_NOT 5 E 'NITRO-GLYCERINE'.
ADD_DANGER_NOT 6 E 'DYNAMITE'.
ADD_DANGER_NOT 7 E 'BLACK POWDER'.
ADD_DANGER_NOT 8 E 'URANIUM'.
ADD_DANGER_NOT 9 E 'CORSIC CHESE'.
ADD_DANGER_NOT 10 E 'FLIGHT PETROL'.
ADD_DANGER_NOT 11 E 'PHOSPHOR'.
ADD_DANGER_NOT 12 E 'CLORIDE'.

INSERT DANGER_NOT FROM TABLE I_DANGER_NOT ACCEPTING DUPLICATE KEYS.

* Fill table SCARGO with data

* A) Find all flights of American Airlines and Lufthansa
SELECT * FROM SFLIGHT INTO I_SFLIGHT
  WHERE CARRID = 'AA' OR CARRID = 'LH'.

  APPEND I_SFLIGHT.
ENDSELECT.

* B) Read customer numbers from SCUSTOM
SELECT * FROM SCUSTOM INTO I_SCUSTOM UP TO 100 ROWS.
  CUST-NUMBER = I_SCUSTOM-ID.

  APPEND CUST.
ENDSELECT.

* C) Fill in the cargo data
ADD_FRACHT 'TOMATOS' M 534 EUR.
ADD_FRACHT 'ORANGES' M 2545 EUR.
ADD_FRACHT 'GRAPEFRUITS' M 1677 EUR.
ADD_FRACHT 'ELEPHANTS' S 32289 EUR.
ADD_FRACHT 'MOTOR BIKES' S 45783 EUR.
ADD_FRACHT 'HORSES' M 47889 EUR.
ADD_FRACHT 'FIREWORK' C 34829 EUR.
ADD_FRACHT 'CHEMICAL SUBSTANCES' C 334782 EUR.
ADD_FRACHT 'MUSICAL INSTRUMENT' S 2359 EUR.
ADD_FRACHT 'COMPUTERS' S 38959 EUR.
ADD_FRACHT 'MEDICAL EQUIPEMENT' C 78937 EUR.
ADD_FRACHT 'VIDEO PLAYERS' S 56671 EUR.
ADD_FRACHT 'PIANO' S 34159 EUR.
ADD_FRACHT 'MUSIC CD' M 2155 EUR.
ADD_FRACHT 'BOOKS' M 5159 EUR.
ADD_FRACHT 'BICYCLES' S 2455 EUR.
ADD_FRACHT 'LASER PRINTERS' S 23449 EUR.
ADD_FRACHT 'HANDYS' S 56981 EUR.
ADD_FRACHT 'FLOWERS' M 6759 EUR.


* D) Create the data from the sources
DATA: CUST_COUNT TYPE I,
      FRACHT_COUNT TYPE I,
      COUNTER TYPE I.

COUNTER = 0. CUST_COUNT = 1. FRACHT_COUNT = 1.

LOOP AT I_SFLIGHT.
  I_SCARGO-CLIENT = I_SFLIGHT-MANDT.
  I_SCARGO-CARRID = I_SFLIGHT-CARRID.
  I_SCARGO-CONNID = I_SFLIGHT-CONNID.
  I_SCARGO-FLDATE = I_SFLIGHT-FLDATE.

  DO 10 TIMES.
    ADD 1 TO COUNTER.
    I_SCARGO-CARGO_ID = COUNTER.
    READ TABLE CUST INDEX CUST_COUNT.
      ADD 1 TO CUST_COUNT.
      CUST_COUNT = CUST_COUNT MOD 51.
      I_SCARGO-CUSTOMER_NO = CUST-NUMBER.
    READ TABLE FRACHT INDEX FRACHT_COUNT.
      ADD 1 TO FRACHT_COUNT.
      FRACHT_COUNT = FRACHT_COUNT MOD 20.
      I_SCARGO-CARGO_DESC = FRACHT-CARGO_DESC.
      I_SCARGO-CARGOTYPE = FRACHT-CARGOTYPE.
      I_SCARGO-VALUE = FRACHT-VALUE.
      IF I_SCARGO-CARRID = 'AA'.
        I_SCARGO-CURRENCY = 'USD'.
      ELSE.
        I_SCARGO-CURRENCY = FRACHT-CURRENCY.
      ENDIF.
    APPEND I_SCARGO.
  ENDDO.

  COUNTER = 0.
ENDLOOP.

INSERT SCARGO FROM TABLE I_SCARGO ACCEPTING DUPLICATE KEYS.

* Give Success Message
MESSAGE ID 'BC430' TYPE 'I' NUMBER '001'.
