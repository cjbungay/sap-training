REPORT SAPBC460D_TEXT1.

* global datas
DATA: BEGIN OF LINES OCCURS 100.       "TABLE FOR DETAIL LINES
        INCLUDE STRUCTURE  TLINE.
DATA: END OF LINES.

DATA: BEGIN OF HEADER.                 "TEXT HEADER
        INCLUDE STRUCTURE THEAD.
DATA: END OF HEADER.

DATA: NAME   LIKE THEAD-TDNAME,
      OBJECT LIKE THEAD-TDOBJECT,
      ID     LIKE THEAD-TDID,
      LANG   LIKE THEAD-TDSPRAS,
      EDITFUNCTION(1).

* commit count like sy-index.
PARAMETERS: TEXTNAME(20),
            LANGUAGE(1) DEFAULT SY-LANGU.
* construct text key
  NAME = TEXTNAME.
  OBJECT = 'TEXT'.
  ID = 'ST '.
  LANG = LANGUAGE.
*** be sure to include authority checking
CALL FUNCTION 'READ_TEXT'
     EXPORTING
          OBJECT          = OBJECT
          NAME            = NAME
          ID              = ID
          LANGUAGE        = LANG
     IMPORTING
          HEADER          = HEADER
     TABLES
          LINES           = LINES
     EXCEPTIONS
          NOT_FOUND       = 1
          ID              = 2
          LANGUAGE        = 3
          OBJECT          = 4
          REFERENCE_CHECK = 5
          NAME            = 6.

CASE SY-SUBRC.
  WHEN 0.
    WRITE: 'Text existiert'(001).
  WHEN 1.
    WRITE: 'Text existiert nicht, wird aber hinzugefügt'(002).

    CALL FUNCTION 'INIT_TEXT'
         EXPORTING
              ID       = ID
              LANGUAGE = LANG
              NAME     = NAME
              OBJECT   = OBJECT
         IMPORTING
              HEADER   = HEADER
         TABLES
              LINES    = LINES
         EXCEPTIONS
              OTHERS   = 1.

    IF SY-SUBRC <> 0.
      WRITE: / 'Fehler bei INIT_TEXT'(003).
      EXIT.
    ENDIF.
  WHEN OTHERS.
    WRITE: / 'Fehler bei READ_TEXT'(004).
    EXIT.
ENDCASE.
* now call the editor to create the text if was not originally created
CALL FUNCTION 'EDIT_TEXT'
     EXPORTING
          DISPLAY   = ' '              " OK TO UPDATE, X IF DISPLAY ONLY
          HEADER    = HEADER
          SAVE      = 'X'              " SAVE OK, BLANK IF ONLY DISPLAY
     IMPORTING
          NEWHEADER = HEADER
          FUNCTION  = EDITFUNCTION
     TABLES
          LINES     = LINES
     EXCEPTIONS
          OTHERS    = 1.
IF SY-SUBRC <> 0.
  WRITE: /  'Fehler bei EDIT_TEXT'(005).
  EXIT.
ENDIF.
