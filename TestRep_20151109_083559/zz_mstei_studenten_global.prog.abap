*&---------------------------------------------------------------------*
*& Report  ZZ_MSTEI_STUDENTEN_GLOBAL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zz_mstei_studenten_global.

PARAMETERS: lc_fnr TYPE zz_mstei_st_fach.

DATA: lt_stud_tab TYPE zz_mstei_stud_tab,
      ls_stud     LIKE LINE OF lt_stud_tab
      .

ls_stud-matrikelnummer    = 0430855.
ls_stud-nachname          = 'Steinhöfler'.
ls_stud-vorname           = 'Michael'.
ls_stud-fachnummer        = '011000'.
INSERT ls_stud INTO TABLE lt_stud_tab.

ls_stud-matrikelnummer    = 0530966.
ls_stud-nachname          = 'Mustermann'.
ls_stud-vorname           = 'Maximillian'.
ls_stud-fachnummer        = '012000'.
INSERT ls_stud INTO TABLE lt_stud_tab.

ls_stud-matrikelnummer    = 0631077.
ls_stud-nachname          = 'Beliebig'.
ls_stud-vorname           = 'Johanna'.
ls_stud-fachnummer        = '021000'.
INSERT ls_stud INTO TABLE lt_stud_tab.

ls_stud-matrikelnummer    = 0731188.
ls_stud-nachname          = 'Huber'.
ls_stud-fachnummer        = '022000'.
INSERT ls_stud INTO TABLE lt_stud_tab.

ls_stud-matrikelnummer    = 0831299.
ls_stud-nachname          = 'Maier'.
ls_stud-vorname           = 'Sabine'.
ls_stud-fachnummer        = '023000'.
INSERT ls_stud INTO TABLE lt_stud_tab.

data cond type c length 20.
CONCATENATE lc_fnr '*' into cond.

LOOP AT lt_stud_tab
  INTO ls_stud
  WHERE fachnummer cp cond
  .
  WRITE: / sy-tabix, ': ', ls_stud-matrikelnummer, ', ', ls_stud-nachname, ' ', ls_stud-vorname.
ENDLOOP.