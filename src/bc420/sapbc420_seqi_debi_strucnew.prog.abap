*----------------------------------------------------------------------*
*   INCLUDE SAPBC420_SEQI_DEBI_STRUCNEW                                *
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*  fields of targetstructure for first demo in bc420
*----------------------------------------------------------------------*
 DATA: BEGIN OF REC_CONVERT,
       KUNNR(10),                      "Customer number
       ALTNR(10),                      "Old customer number
*      KTOKD(4) VALUE 'KUNA',         "Account Group
       NAME1(35),                      "Customer name
       STRAS(35),                      "Street and house number
       ORT01(35),                      "City
       PSTLZ(10),                      "Postal code
       LAND1(3),                       "Country key
       SPRAS(2),                       "Language key
       TELF1(16),                      "Telephone number
       SORTL(10),                      "Sort field
       STCEG(20),                      "VAT registration number
       END OF REC_CONVERT.
