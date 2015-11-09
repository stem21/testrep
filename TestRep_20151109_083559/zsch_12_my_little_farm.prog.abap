*&---------------------------------------------------------------------*
*& Report  ZSCH_12_MY_LITTLE_FARM
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zsch_12_my_little_farm.

TYPE-POOLS icon.
TYPE-POOLS sym.

DATA:
* Für Select-option und RTTI
      gd_beet TYPE zsch_12_td_beet,
      gd_icon TYPE icon_d,
* Die Beschreibung für die Festwerte der Beete
      gr_beet_descr TYPE REF TO cl_abap_elemdescr,
* Die Festwerte
      gt_beet_fixvalues TYPE ddfixvalues,
      gs_beet_fixvalue LIKE LINE OF gt_beet_fixvalues,
* Textpool Werte
      gt_textpool TYPE TABLE OF textpool,
      gs_textpool LIKE LINE OF gt_textpool,
* Diverse Arbeitsvariablen
      gt_beete TYPE stringtab,
      gs_beet LIKE LINE OF gt_beete,
      gd_nr_beet TYPE i,
      gd_tabix TYPE i,

      gt_frutis TYPE stringtab,
      gt_vegis TYPE stringtab,
      gs_plant LIKE LINE OF gt_beete,

      gd_val TYPE c length 80,
      gd_line TYPE i,
      gd_offset TYPE i

      .

*---------------------------------------------------------
* Zeichnen des Selektionsbildes
*---------------------------------------------------------

* Gartenfreude
SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE text-f01.

PARAMETERS:       pa_gdat TYPE dats DEFAULT sy-datum OBLIGATORY
                  .
SELECT-OPTIONS:   so_beet FOR gd_beet.

SELECTION-SCREEN END OF BLOCK bl1.
* Gartenfreude: END

*---------------------------------------------------------
*Pflanzen
SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE text-f02.

PARAMETERS:   pa_fruti RADIOBUTTON GROUP plat USER-COMMAND chng
              .

* ---------------------------------------------------------
* Pflanzen: Obst
SELECTION-SCREEN BEGIN OF BLOCK bl21 WITH FRAME TITLE text-f03.

PARAMETERS:     pa_stra AS CHECKBOX,
                pa_bana AS CHECKBOX,
                pa_jelly AS CHECKBOX
              .

SELECTION-SCREEN END OF BLOCK bl21.
* Pflanzen: Obst: END
* ---------------------------------------------------------

PARAMETERS:   pa_vegi RADIOBUTTON GROUP plat
              .

* ---------------------------------------------------------
* Pflanzen: Gemüse
SELECTION-SCREEN BEGIN OF BLOCK bl22 WITH FRAME TITLE text-f04.

PARAMETERS:   pa_caro AS CHECKBOX,
              pa_cucu AS CHECKBOX,
              pa_sala AS CHECKBOX
            .
.
SELECTION-SCREEN END OF BLOCK bl22.
* Pflanzen: Gemüse: END
* ---------------------------------------------------------

SELECTION-SCREEN END OF BLOCK bl2.
*Pflanzen: END
*---------------------------------------------------------
*---------------------------------------------------------


*---------------------------------------------------------
* Initialisierung:  wird nur einmal pro ausführbarem Programm verarbeiten
*                   Hier kann man Vorschlagswerte für dei Selektionsbildfelder setzen bzw. Variablen initialisieren
*---------------------------------------------------------
INITIALIZATION.
* Werte setzen
  pa_fruti = pa_stra = pa_bana = pa_jelly = abap_true.

  gd_icon = icon_selection+1(2).

  READ TEXTPOOL sy-cprog
  INTO gt_textpool
  LANGUAGE sy-langu.
*---------------------------------------------------------
*---------------------------------------------------------


*---------------------------------------------------------
* Reagieren auf Anwender-Eingaben (Nach Ausführen/F8) oder USER-COMMAND
*---------------------------------------------------------
AT SELECTION-SCREEN.

  CASE sy-ucomm.
*   Bei Mehrfachselektions-Auswahl nichts machen
    WHEN '%002'.
      EXIT.
*   Wurde Radio-Button gewechselt?
    WHEN 'CHNG'.
      IF pa_fruti = abap_true.
        pa_caro = pa_cucu = pa_sala = abap_false.
        pa_stra = pa_bana = pa_jelly = abap_true.
*     Lob-nachricht
        MESSAGE s001(zsch_12) WITH sy-uname text-s01.
      ELSE.
        pa_caro = pa_cucu = pa_sala = abap_true.
        pa_stra = pa_bana = pa_jelly = abap_false.
*     Lob-nachricht
        MESSAGE s001(zsch_12) WITH sy-uname text-s01.
      ENDIF.

*   Anwender will weiter zur Liste
*   unten: Blockweise realisiert
    WHEN OTHERS.
*      IF pa_fruti = abap_true
*        AND pa_stra = abap_false
*        AND pa_bana = abap_false
*        AND pa_jelly = abap_false.
*        MESSAGE e002(zsch_12) WITH sy-uname.
*      ELSEIF pa_vegi = abap_true
*        AND pa_cucu = abap_false
*        AND pa_sala = abap_false
*        AND pa_caro = abap_false.
*        MESSAGE e002(zsch_12) WITH sy-uname.
*      ENDIF.
  ENDCASE.

* Anzahl und Texte zu gewählten Beeten ermitteln
  CLEAR gt_beete.
  gd_nr_beet = 0. "Starte mit 0 ausgewählten

* Reagieren auf Anwender-Eingaben (Nach Ausführen/F8) im Block 21
AT SELECTION-SCREEN ON BLOCK bl21.
  CHECK sy-ucomm <> 'CHNG' AND sy-ucomm <> '%002'.
  IF pa_fruti = abap_true
    AND pa_stra = abap_false
    AND pa_bana = abap_false
    AND pa_jelly = abap_false.
    MESSAGE e002(zsch_12) WITH sy-uname.
  ENDIF.

* Reagieren auf Anwender-Eingaben (Nach Ausführen/F8) im Block 21
AT SELECTION-SCREEN ON BLOCK bl22.
  CHECK sy-ucomm <> 'CHNG' AND sy-ucomm <> '%002'.
  IF pa_vegi = abap_true
    AND pa_cucu = abap_false
    AND pa_sala = abap_false
    AND pa_caro = abap_false.
    MESSAGE e002(zsch_12) WITH sy-uname.
  ENDIF.

*---------------------------------------------------------
*---------------------------------------------------------

*---------------------------------------------------------
* Für die Erzeugung von Listeinhalten gedacht: Ausgabe der Grundliste, also das Beet-Layout
*---------------------------------------------------------
END-OF-SELECTION.

  SET TITLEBAR 'TITLELIST'.

* Alle Beet-Texte aus dem Datenelement ermitteln
  gr_beet_descr ?= cl_abap_typedescr=>describe_by_data( gd_beet ).
* Die Festwerte holen
  gt_beet_fixvalues = gr_beet_descr->get_ddic_fixed_values( ).

* Ermitteln der Texte zu Beeten, die vom Anwender gewählt wurden
  LOOP AT gt_beet_fixvalues INTO gs_beet_fixvalue "Alle Beete
    WHERE low IN so_beet.
    ADD 1 TO gd_nr_beet.
    APPEND gs_beet_fixvalue-ddtext TO gt_beete.
  ENDLOOP.


* Eine schöne Blume
  WRITE: / icon_selection AS ICON.
* Textausgabe
  WRITE: 'Gartendatum: '(t02), pa_gdat DD/MM/YYYY.
* Zeile auslassen
  SKIP.


* Früchtchen-Text in eigene Tabelle geben
  LOOP AT gt_textpool
    INTO gs_textpool
    WHERE key = 'PA_STRA' OR key = 'PA_BANA' OR key = 'PA_JELLY'.
    "write: / gs_textpool-entry, gs_textpool-id, gs_textpool-key.
    IF gs_textpool-key = 'PA_STRA' AND pa_stra = abap_true.
      APPEND gs_textpool-entry TO gt_frutis.
    ELSEIF gs_textpool-key = 'PA_BANA' AND pa_bana = abap_true.
      APPEND gs_textpool-entry TO gt_frutis.
    ELSEIF gs_textpool-key = 'PA_JELLY' AND pa_jelly = abap_true.
      APPEND gs_textpool-entry TO gt_frutis.
    ENDIF.
  ENDLOOP.

* Gemüse-Text in eigene Tabelle geben
  LOOP AT gt_textpool
    INTO gs_textpool
    WHERE key = 'PA_CARO' OR key = 'PA_CUCU' OR key = 'PA_SALA'.
    "write: / gs_textpool-entry, gs_textpool-id, gs_textpool-key.
    IF gs_textpool-key = 'PA_CARO' AND pa_caro = abap_true.
      APPEND gs_textpool-entry TO gt_vegis.
    ELSEIF gs_textpool-key = 'PA_CUCU' AND pa_cucu = abap_true.
      APPEND gs_textpool-entry TO gt_vegis.
    ELSEIF gs_textpool-key = 'PA_SALA' AND pa_sala = abap_true.
      APPEND gs_textpool-entry TO gt_vegis.
    ENDIF.
  ENDLOOP.

* Für jeden Eintrag in der Beet Tabelle ein Beet zeichnen
* mit Name des Beetes und der Pflanze
  LOOP AT gt_beete INTO gs_beet.

*   Pflanze zum Beet lesen, dafür den Beet-Index speichern und als Pflanzenindex verwenden
    gd_tabix = sy-tabix.

*   Arbeitssturktur für Pflanzennamen initialisieren
    CLEAR gs_plant.

*   Früchtchen oder Grünzeug
    IF pa_fruti = abap_true.
      READ TABLE gt_frutis INTO gs_plant INDEX gd_tabix.
    ELSEIF pa_vegi = abap_true.
      READ TABLE gt_vegis INTO gs_plant INDEX gd_tabix.
    ENDIF.

*  Keine Anbau-Auswahl mehr?
    IF sy-subrc = 4. "Letzer Loop (=Read Table) wurde nie durchlaufen
      CONTINUE.
    ENDIF.

*   Beet zeichnen
    PERFORM draw_beet USING gs_beet gs_plant.

  ENDLOOP.

*&---------------------------------------------------------------------*
*&      Form  draw_beet
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->ID_NAME    text
*      -->ID_PNAME   text
*----------------------------------------------------------------------*
FORM draw_beet USING  id_name TYPE string
                      id_pname TYPE string.

* Ein Beet

* Farbe an für Beet
  FORMAT COLOR COL_GROUP.

* Ausgefüllte Checkbox, Beet-Name und Pflanzenname
  WRITE: / sym_checkbox AS SYMBOL, id_name, id_pname.

* Farbe auf positiv für Beet
  FORMAT COLOR COL_POSITIVE.

* Der obere Rand des Beetes
  WRITE / '-------------------------------------------------------------------'.

* Vier Pflanzenreihen.
  DO 4 TIMES.

* Der linke rand
    WRITE: / '|'.

*  Die Pflanzenpositionen
    DO 32 TIMES.
*     Ein grüner Fleck ohne Leerzeichen als Hotspot (Mauszeiger ändert sich)
      WRITE icon_led_green AS ICON NO-GAP HOTSPOT.
    ENDDO.

* Der rechte Rand
    WRITE: '|'.
  ENDDO.

* Der untere Rand
  WRITE / '-------------------------------------------------------------------'.

* Farbe aus
  FORMAT COLOR OFF.

ENDFORM. "draw_beet
*---------------------------------------------------------
*---------------------------------------------------------


*---------------------------------------------------------
* Verabeitung des Doppelklickes (Hotspot): Interaktion mit der Liste
*---------------------------------------------------------
AT LINE-SELECTION.

* Die Informationen ermitteln, die der Anwender angeklickt hat
  GET CURSOR VALUE gd_val LINE gd_line OFFSET gd_offset.

* Blümchen malen
  sy-lisel+gd_offset(2) = gd_icon.

* Und in der Liste ändern
  MODIFY CURRENT LINE.

*---------------------------------------------------------
*---------------------------------------------------------



*---------------------------------------------------------
* Vor dem Anzeigen des Selektions-Bildes
*---------------------------------------------------------
AT SELECTION-SCREEN OUTPUT.
* Titlebar setzen
  SET TITLEBAR 'TITLELIST'.
*---------------------------------------------------------
*---------------------------------------------------------