*----------------------------------------------------------------------*
*   INCLUDE SAPBC420_SEQI_DEBI_FORMATSTRUC                             *
*  legacy fields converted into SAP-format
*----------------------------------------------------------------------*
 DATA: BEGIN OF REC_CONVERT,
       KUNNR(10),                      "Customer number
       ALTKN(10),                      "Old customer number
*      KTOKD(4) VALUE 'KUNA',         "Account Group
       NAME1(35),                      "Customer name
       SORTL(10),                      "Sort field
       STRAS(35),                      "Street and house number
       ORT01(35),                      "City
       PSTLZ(10),                      "Postal code
       LAND1(3),                       "Country key
       SPRAS(2),                       "Language key
       TELF1(16),                      "Telephone number
       STCEG(20),                      "VAT registration number
       END OF REC_CONVERT.
