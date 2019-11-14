*&---------------------------------------------------------------------*
*& Report  SAPBC480_PROCESS
*&
*&---------------------------------------------------------------------*
*& Creates two VBS files on the local file system that allow to kill
*& the OS processes for Adobe Reader and Designer.
*& Helpful in situations when course participants do not have rights
*& to call Windows Task Manager.
*&---------------------------------------------------------------------*

REPORT  sapbc480_process MESSAGE-ID bc480.

DATA:
  gt_file TYPE   TABLE OF text255,
  gv_full_path   TYPE string,
  gv_window_text TYPE string,
  gv_answer.

INITIALIZATION.
  AUTHORITY-CHECK OBJECT 'S_DEVELOP'
           ID 'DEVCLASS' FIELD 'ZBC480'
           ID 'OBJTYPE' FIELD 'DEBUG'
           ID 'OBJNAME' FIELD 'ZBC480'
           ID 'P_GROUP' DUMMY
           ID 'ACTVT' FIELD '02'.
  IF sy-subrc <> 0.
    MESSAGE e035 WITH 'S_DEVELOP'.
*   You have no authorization to perform this action (&1)
  ENDIF.

  IF sy-batch IS NOT INITIAL.
    MESSAGE e034.
* Function not possible in background processing
  ENDIF.

  gv_window_text = 'Select download folder'(fol).

START-OF-SELECTION.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
     titlebar                    = 'Creating VBS scripts'(tit)
      text_question               =
        'Do you want to create VBS scripts?'(q01)
*    text_button_1               = 'Yes'(yes)
*    text_button_2               = 'No'(noh)
     display_cancel_button       = space
     start_column                = 25
     start_row                   = 6
   IMPORTING
     answer                      = gv_answer
   EXCEPTIONS
     OTHERS                      = 2.

  IF gv_answer = 1.
    CALL METHOD cl_gui_frontend_services=>directory_browse
      EXPORTING
        window_title         = gv_window_text
      CHANGING
        selected_folder      = gv_full_path
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        not_supported_by_gui = 3
        OTHERS               = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    IF gv_full_path IS INITIAL.
      MESSAGE e010.
    ENDIF.

    PERFORM build_vbs
      USING 'FORMDESIGNER.EXE' 'FORMDE~1.EXE' 'FormDesigner.ex'.
    PERFORM down USING 'Kill Designer.vbs'. "#EC NOTEXT

   PERFORM build_vbs USING 'AcroRd32.exe' 'ACRORD32.EXE' 'ACRORD32.EXE'.
    PERFORM down USING 'Kill Reader.vbs'. "#EC NOTEXT
  ENDIF.

*---------------------------------------------------------------------*
FORM build_vbs
  USING ip_process1 TYPE text50
        ip_process2 TYPE text50
        ip_process3 TYPE text50.

  set extended check off.
* Depending on the operating system, the OS process for Designer has
* various names

  DATA:
    ls_file        LIKE LINE OF gt_file.

  REFRESH gt_file.

  APPEND 'on error resume next' TO gt_file.
  APPEND
   'Set WshShell    = Wscript.CreateObject("Wscript.Shell")' TO gt_file.
  APPEND 'Set WshSysEnv   = WshShell.Environment("PROCESS")' TO gt_file.
  APPEND 'USERNAME        = WshSysEnv("USERNAME")' TO gt_file.

  CONCATENATE
    'Programname = "'
    ip_process1 '"' INTO ls_file.
  APPEND ls_file TO gt_file.

  CONCATENATE
    'If msgbox ("'
    'You are about to kill the following process:'(war)
    '"&vbcr&vblf&vblf&"   - "&Programname&vbcr&vblf&vblf&"'
    INTO ls_file
    SEPARATED BY space.
  CONCATENATE
    ls_file
    'Are you sure?'(sur)
    '",36,"SAP IT") = 7 then wscript.quit'
    INTO ls_file.
  APPEND ls_file TO gt_file.

  APPEND 'strComputer = "."' TO gt_file.
  CONCATENATE
    'Set objWMIService = GetObject("winmgmts:" &'
  '"{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")'
    INTO ls_file.
  APPEND ls_file TO gt_file.

  CONCATENATE
    'Set colProcessList = objWMIService.ExecQuery ("SELECT * '
    'FROM Win32_Process")'
    INTO ls_file SEPARATED BY space.
  APPEND ls_file TO gt_file.

  APPEND 'For Each objProcess in colProcessList' TO gt_file.
  APPEND 'res= objprocess.GetOwner ( User, Domain )' TO gt_file.
  CONCATENATE
    'If User = USERNAME and (objprocess.name = "'
    ip_process1
    '" or objprocess.name = "'
    ip_process2
    '" or objprocess.name = "'
    ip_process3
    '") Then' INTO ls_file.
  APPEND ls_file TO gt_file.
  APPEND '''msgbox objProcess.name' TO gt_file.
  APPEND 'objProcess.Terminate()' TO gt_file.
  APPEND 'end if' TO gt_file.
  APPEND 'Next' TO gt_file.

  set extended check on.

ENDFORM.                    "build_vbs

************************************************************************
FORM down
  USING ip_file_name TYPE string.
  DATA:
    lv_file_name   TYPE string,
    lv_separator.

  IF gv_full_path CS '\'.
    lv_separator = '\'.
  ELSE.
    lv_separator = '/'.
  ENDIF.

  CONCATENATE gv_full_path lv_separator ip_file_name INTO lv_file_name.

  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename = lv_file_name
    CHANGING
      data_tab = gt_file
    EXCEPTIONS
      OTHERS   = 24.
  IF sy-subrc <> 0.
    WRITE: / 'File download failed'(fai).
  ELSE.
    WRITE: / 'Executable VBS created:'(vbs), lv_file_name.
  ENDIF.

ENDFORM.                    "down
