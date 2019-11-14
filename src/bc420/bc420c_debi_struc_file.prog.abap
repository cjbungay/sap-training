*----------------------------------------------------------------------*
*   INCLUDE BC420C_DEBI_STRUC_FILE                                     *
*----------------------------------------------------------------------*




 DATA: BEGIN OF REC_CONVERT,

       KUNNR(10),                      "Customer Number

*      KTOKD(4) VALUE 'KUNA',         "Account Group

       NAME1(35),                      "Customer Name

       SORTL(10),                      "Sort Field

       STRAS(35),                      "Street and House Number

       ORT01(35),                      "City

       PSTLZ(10),                      "Postal code

       LAND1(3),                       "Country Key

       SPRAS(2),                       "Language Key

       TELF1(16),                      "Telephone Number

       STCEG(20).                      "VAT Registration Number

 DATA: END OF REC_CONVERT.








