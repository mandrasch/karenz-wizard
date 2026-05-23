// Ratgeber: Wie man als Vater mehr als 2 Monate Karenz nimmt
// Outline-Stufe: Inhalte nur als Bullet Points mit TODO-Markierung.
// Quelle der Inhalte: src/data/steps.ts (Schritte 4, 5, 5.1–5.4)
// und src/pages/eakbg-anspruch.astro (182-Tage-Regel).
// Kompilieren: typst compile typst/ratgeber-vaeterkarenz.typ

// ============================================================
//  PREAMBLE
// ============================================================

#set document(
  title: "Wie man als Vater mehr als 2 Monate Karenz nimmt",
  author: "karenz-wizard.at",
)

#set page(
  paper: "a4",
  margin: (x: 2.2cm, top: 2.4cm, bottom: 3.4cm),
  footer: context [
    #line(length: 100%, stroke: 0.5pt + luma(205))
    #v(4pt)
    #set text(size: 7pt, fill: luma(105))
    #set par(leading: 0.5em, justify: true)
    *Keine Rechtsberatung:* Dieser Ratgeber ist ein privates,
    nichtkommerzielles Hobbyprojekt. Alle Angaben ohne Gewähr,
    unverbindlich und ggf. unvollständig, fehlerhaft oder veraltet —
    keine individuelle Rechts-, Steuer- oder Sozialberatung. Für
    verbindliche Auskünfte und vor jeder Antragstellung wende dich an
    die zuständigen Stellen (Arbeiterkammer, ÖGK, Gewerkschaft /
    Betriebsrat, Finanzamt).
    #v(5pt)
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      link("https://karenz-wizard.at")[karenz-wizard.at],
      counter(page).display(),
    )
  ],
)

#set text(
  lang: "de",
  size: 11pt,
  // "Inter" = Brand-Schrift der Website (gevendored in typst/fonts,
  // per --font-path eingebunden). "Noto Emoji" (statisch, monochrom)
  // liefert die 💰 / ⚠️ Glyphen im PDF.
  font: ("Inter", "Noto Emoji"),
)

// Mehr Luft: groesseres Zeilen- und Absatz-Spacing
// (par.spacing ist der moderne Absatz-Abstand ab Typst 0.11)
#set par(leading: 0.8em, spacing: 1.4em, justify: true)

#set heading(numbering: none)
// Mehr Abstand unter Ueberschriften
#show heading: set block(above: 1.4em, below: 1em)
#show heading.where(level: 1): set text(size: 16pt)
#show heading.where(level: 2): set text(size: 13pt)
#set list(indent: 6pt)

// Stand des Dokuments (auch auf dem Cover verwendet)
#let dokument-stand = "Letzter Stand: 23.05.2026"

// ---- DEINE CUSTOM INFOBOXEN ----

// 1. Deine gewünschte Finanzbox mit Geldsack-Emoji
#let finanzbox(titel, inhalt) = {
  block(
    width: 100%,
    fill: rgb("#f0fdf4"), // Sanftes Grün
    inset: 12pt,
    radius: 4pt,
    stroke: (left: 4pt + rgb("#16a34a")), // Grüner Balken links
    [
      #text(weight: "bold", fill: rgb("#16a34a"))[💰 #titel] \
      #v(4pt)
      #inhalt
    ]
  )
}

// 2. Eine Fristen- / Warnungs-Box (Rot)
#let fristbox(titel, inhalt) = {
  block(
    width: 100%,
    fill: rgb("#fef2f2"), // Sanftes Rot
    inset: 12pt,
    radius: 4pt,
    stroke: (left: 4pt + rgb("#dc2626")), // Roter Balken links
    [
      #text(weight: "bold", fill: rgb("#dc2626"))[⚠️ #titel] \
      #v(4pt)
      #inhalt
    ]
  )
}

// ============================================================
//  COVERSEITE (modern, oranger Rahmen #F99435)
// ============================================================

#page(footer: none, margin: 1.4cm)[
  #block(
    width: 100%,
    height: 100%,
    radius: 0pt,
    stroke: 4pt + rgb("#F99435"),
    inset: 2.4cm,
  )[
    #set align(center)
    #grid(
      rows: (1fr, auto, 1fr),
      // --- oben: Kicker ---
      align(top + center)[
        #text(size: 12pt)[
          Mini-Ratgeber für Väter
        ]
      ],
      // --- Mitte: Titel ---
      align(horizon + center)[
        #text(size: 26pt, weight: "bold")[
          Wie man als Vater mehr als 2 Monate Karenz nimmt
        ]
        // Abstand Titel <-> Untertitel: hier den Wert anpassen
        #v(2pt)
        //#line(length: 30%, stroke: 2pt + rgb("#F99435"))
        #text(size: 14pt, fill: luma(80))[
         \- oder anderweitig mehr Verantwortung übernimmt
          in den ersten Jahren mit Kind
        ]
        // TODO: optionalen dezenten Untertitel beim Durchgehen pruefen
      ],
      // --- unten: Logo + Link (ganz unten) ---
      align(bottom + center)[
        #image("../src/lib/assets/logo.png", width: 4.5cm)
        #v(8pt)
        #link("https://karenz-wizard.at")[
          #text(fill: rgb("#F99435"), weight: "bold")[karenz-wizard.at]
        ]
      ],
    )
  ]
]

// ============================================================
//  IMPRESSUM / STAND (eigene Seite nach dem Cover)
// ============================================================

#page(footer: none, margin: 2.4cm)[
  #set align(start + bottom)
  #set par(leading: 0.7em, justify: false)

  #v(16pt)
  *+++ ENTWURF +++*

  #v(10pt)
  Dies ist noch ein Entwurfstext, um Feedback einzuholen. Kritisches Anmerkungen, allgemeines Feedback oder weitere Cases / Möglichkeiten sehr gerne an mich per Mail schicken. Vielen Dank! 

  E-Mail: #link("mailto:matthias-andrasch-kontakt@mailbox.org")[matthias-andrasch-kontakt\@mailbox.org]

  #text(size: 11pt)[#dokument-stand]

  #v(16pt)
  *Lizenz: CC0 / Public Domain*

  #link("https://creativecommons.org/publicdomain/zero/1.0/")[
    #image("assets/cc-zero.png", width: 2.6cm)
  ]
  #v(10pt)
  Autor: Matthias Andrasch für karenz-wizard.at \
  Freigeben als #link("https://creativecommons.org/publicdomain/zero/1.0/")[https://\u{200B}creativecommons.org/\u{200B}publicdomain/\u{200B}zero/\u{200B}1.0]
]

#pagebreak()
#counter(page).update(1)

// ============================================================
//  EINLEITUNG
// ============================================================

= Einleitung

- Der Zwiespalt / die Challenge — Viele Väter wollen gleichberechtigt Verantwortung übernehmen. Aktuell werden sie medial stark kritisiert, „nur” zwei Monate Karenz zu nehmen. Und dies obwohl beim eaKBG (max. 14 Monate ab Geburt) bspw. nur 2 Monate für den Vater übrig bleiben, wenn die Mutter das erste Jahr mit dem Baby daheim sein möchte.
- Zielsetzung des Ratgebers — Optionen aufzeigen, wie man mehr als zwei Monate Karenz nimmt - oder anderweitig mehr Verantwortung mitträgt, bspw. durch Eltern-Teilzeit o.ä.

== Hacks im bestehenden Sozialsystem Österreichs

- TODO: Es geht hier um Möglichkeiten und "Hacks" innerhalb des bestehenden (Förder-)Systems rund um das Kinderbetreuungsgeld in Österreich.
- TODO: Politische / systemische Veränderungen sind das andere, ebenso wichtige Thema — diese 
  werden hier nicht behandelt. 

== Eine Frage der (finanziellen) Möglichkeiten

- Natürlich ist das alles eine Frage der finanziellen Möglichkeiten und
  sehr individuell.
- Einige Optionen stehen nur privilegierten Personen zur Verfügung.
-   Nicht zuletzt berichten auch Männer von Diskriminierungen im Job

== Gleichberechtigte Elternschaft ist mehr als strikte 50:50-Aufteilung

- Gleichberechtigte Elternschaft ist so viel mehr als die mathematisch
  korrekte 50:50-Aufteilung der Elternzeit/Karenz-Monate.
- Lass dich nicht stressen!

// ============================================================
//  CRASHKURS KINDERBETREUUNGSGELD
// ============================================================

= Crashkurs Kinderbetreuungsgeld

In Österreich gibt es zwei Fördermodelle: Einkommensabhängiges
Kinderbetreuungsgeld (eaKBG) für Erwerbstätige und das pauschale
Kinderbetreuungsgeld-Konto, was allen offen steht. Als Paar muss man
sich für eins entscheiden. Das Einkommensabhängige ist an die
182-Tage-Regel geknüpft, siehe unten.

*Grobe Faustregel:* Falls ihr Anspruch auf das einkommensabhängige
Kinderbetreuungsgeld habt, bekommt ihr in den meisten Fällen deutlich
mehr Geld raus. Während der Gesamttopf beim pauschalen
Kinderbetreuungsgeld-Konto für beide Elternteile bei ca. 18.760 €
gedeckelt ist (maximal 41,14 € pro Tag), könnt ihr beim eaKBG insgesamt
bis zu ca. 34.130 € an Transferleistungen abholen, da der Höchstsatz
hier bei stolzen 80,12 € pro Tag liegt (abhängig vom Gehalt).

Daher lohnt es sich finanziell oft mehr, die 14 Monate des eaKBG voll
auszuschöpfen und danach noch einige Monate unbezahlte Karenz
dranzuhängen, da ihr selbst nach Abzug der Lebenshaltungskosten in den
angehängten, unbezahlten Karenzmonaten unterm Strich eine deutlich
höhere Gesamtsumme zur Verfügung habt als im langgestreckten
Pauschalmodell (bis zu 2 Jahre möglich).

#v(6pt)
*Die wichtigsten Unterschiede*
#v(4pt)

#table(
  columns: (auto, 1fr, 1fr),
  inset: 8pt,
  align: left + top,
  stroke: 0.5pt + luma(210),
  fill: (col, row) => if row == 0 { luma(238) },

  // table.header (ab Typst 0.11): Kopfzeile wiederholt sich
  // automatisch bei Seitenumbruch der Tabelle.
  table.header(
    [],
    [*Pauschales KBG (KBG-Konto)*],
    [*Einkommensabhängiges KBG (eaKBG)*],
  ),

  [*Anspruch*],
  [Alle Eltern, unabhängig von vorheriger Erwerbstätigkeit],
  [Nur wenn mind. ein Elternteil vor Geburt/Mutterschutz erwerbstätig
   war (182-Tage-Regel)],

  [*Bezugsdauer\ (beide in Karenz)*],
  [15–35 Monate. Obacht: Recht auf Karenz beim Arbeitgeber nur bis zum
   2. Lebensjahr],
  [Max. 14 Monate ab Geburt; der Vater muss davon mind. 2 Monate
   (61 Tage) in Karenz gehen],

  [*Max. Förderungs\ summe*],
  [Bis zu *18.760 €* gesamt (max. 41,14 €/Tag; Stand 2025)],
  [Bis zu *ca. 33.600 €* (max. 80,12 €/Tag, ca. 2.400 €/Monat, ca. 80 %
   des Gehalts; Stand 2025). Hat nur ein Elternteil Anspruch, erhält der
   andere Sonderleistung I (41,14 €/Tag, ca. 1.200 €/Monat)],

  [*Rechner*],
  [#link("https://services.bundeskanzleramt.gv.at/KBG-Rechner/index.html#kbgKonto")[KBG-Konto-Rechner (bundeskanzleramt.gv.at)]],
  [#link("https://services.bundeskanzleramt.gv.at/KBG-Rechner/index.html#eaKbg")[eaKBG-Rechner (bundeskanzleramt.gv.at)]],
)

// ============================================================
//  VORAUSSETZUNG: 182-TAGE-REGEL
// ============================================================

= Voraussetzung prüfen: Die 182-Tage-Regel (eaKBG-Anspruch)

- TODO: eaKBG vs. pauschales KBG-Konto — eaKBG ca. 80% des letzten
  Gehalts, max. 14 Monate ab Geburt, deutlich höhere Fördersumme
  (Höchstsatz ~80,12 €/Tag) als das pauschale Konto.
- TODO: 182-Tage-Regel — ca. 6 Monate durchgehend erwerbstätig vor
  Geburt/Mutterschutz, kein AMS-/Notstands-/Weiterbildungsgeld in
  diesem Zeitraum (Lücken bis 14 Tage unschädlich).
- TODO: Stichtag ist für Mutter (Beginn Mutterschutz) und Vater
  (Geburtsdatum) unterschiedlich!
- TODO: Nur ein Elternteil muss den Anspruch erfüllen; der andere
  erhält für seine Karenzmonate Sonderleistung 1 (~1.200 €/Monat).

Prüft euren Anspruch und den jeweiligen Stichtag mit dem interaktiven
Rechner: #link("https://karenz-wizard.at/eakbg-anspruch/")[karenz-wizard.at/eakbg-anspruch].

// ============================================================
//  OPTION 1
// ============================================================

= 1. Mutter nimmt weniger als 12 Monate — „gibt an Vater ab"

- TODO: Staatliche Förderung ≠ Recht auf Karenz — 2 Jahre Recht auf
  (unbezahlte) Freistellung beim Arbeitgeber, eaKBG aber nur 14 Monate.
- TODO: Nimmt die Mutter im ersten Teil weniger Monate, bleiben dem
  Vater mehr eaKBG-Monate.
- TODO: Bedingung für die vollen 14 Monate eaKBG: Der Vater nimmt
  mindestens 2 Monate.
- TODO: Aufteilung der Monate relativ flexibel; ein gemeinsamer
  eaKBG-Monat ist möglich (Checkbox im Planer).
- TODO: Case ergänzen — Mutter 3 Monate, Vater 12 Monate (LinkedIn-Beitrag
  von Ines Eschenbacher).

Interaktiv durchspielen:
#link("https://karenz-wizard.at/eakbg-planer/")[karenz-wizard.at/eakbg-planer].

// ============================================================
//  OPTION 2
// ============================================================

= 2. Option: Unbezahlte Karenzmonate anhängen — länger in Karenz als Vater

- TODO: Unbezahlte Karenz-Monate nach den 14 eaKBG-Monaten dranhängen;
  Recht auf (unbezahlte) Freistellung besteht bis zum 2. Lebensjahr.
- TODO: Lebensunterhalt in dieser Zeit aus Ersparnissen und/oder
  Einkommen des anderen Elternteils.
- TODO: Krankenversicherung über ÖGK-Mitversicherung bei der Partnerin;
  bei Kindererziehung meist beitragsfrei — vorher bei der ÖGK abklären
  (Regelungen unterschiedlich bei verheiratet / unverheiratet).

#finanzbox("Leben von einem Gehalt")[
  TODO: In den unbezahlten Karenz-Monaten gibt es keine Förderung und
  kein Gehalt — die Familie lebt von einem Gehalt bzw. von Ersparnissen.
  Anzahl Monate × Fixkosten gegen Budget/Ersparnisse rechnen.
]

Mehr Infos:
#link("https://karenz-wizard.at/unbezahlte-karenz/")[karenz-wizard.at/unbezahlte-karenz].

// ============================================================
//  OPTION 3
// ============================================================

= 3. Option: Eltern-Teilzeit — das 20h/20h-Modell

- TODO: *Hinweis* — Möglichkeit, mehr Verantwortung zu übernehmen
  *ohne* (zusätzliche unbezahlte) Karenz: beide steigen nach dem eaKBG
  wieder ein, nur mit reduzierter Stundenzahl.
- TODO: 20h/20h-Modell — zeitlich abwechseln, z. B. Mutter 8–12 Uhr,
  Vater 13–17 Uhr.
- TODO: Mit gesetzlichem Anspruch auf Eltern-Teilzeit besteht
  mehrjähriger Kündigungsschutz.
- TODO: Voraussetzungen prüfen (Betriebsgröße, Dauer des
  Dienstverhältnisses); sonst freiwillige Teilzeit ohne Kündigungsschutz.
- TODO: Gemeinsame Betreuung bis zum Kindergarten-Einstieg möglich.

#finanzbox("Leben von Teilzeit-Gehältern")[
  TODO: Zwei reduzierte Teilzeit-Gehälter (bzw. Ersparnisse) müssen die
  Fixkosten der Familie decken — gegenrechnen.
]

Mehr Infos:
#link("https://karenz-wizard.at/elternteilzeit-20-20/")[karenz-wizard.at/elternteilzeit-20-20].

// ============================================================
//  OPTION 4
// ============================================================

= 4. Option: Bezahlter (oder unbezahlter) Urlaub — Väterkarenz verlängern

- TODO: Urlaubstage vorher ansammeln und nach den 14 eaKBG-Monaten
  verbrauchen → 100 % Gehalt statt Förderung.
- TODO: Nachteil — Urlaubsanspruch begrenzt, kein Rechtsanspruch auf den
  Zeitpunkt, mit dem Arbeitgeber zu vereinbaren.
- TODO: Variante unbezahlter Urlaub zur Verlängerung über die 2 Jahre
  Recht auf Karenz hinaus (falls der Arbeitgeber zustimmt).

#finanzbox("Bezahlter vs. unbezahlter Urlaub")[
  TODO: Bei bezahltem Urlaub volles Gehalt; bei *unbezahltem* Urlaub
  lebt die Familie von einem Gehalt — Monate gegen Budget rechnen.
]

Mehr Infos:
#link("https://karenz-wizard.at/urlaub-karenz-verlaengern/")[karenz-wizard.at/urlaub-karenz-verlaengern].

// ============================================================
//  OPTION 5
// ============================================================

= 5. AMS & Karenz — Infos zur „AMS-Karenz"

- TODO: Ist ein Elternteil arbeitssuchend, kann man trotzdem alle
  Entwicklungsschritte miterleben und Verantwortung im Haushalt
  übernehmen.
- TODO: Eine Art „Karenz" mit Sonderleistung 1 ist möglich, falls das
  andere Elternteil eaKBG-Anspruch hat (auch ohne Arbeitsverhältnis).
- TODO: Arbeitslosengeld — es gibt einen Familienzuschlag; Jobsuche nur
  für mindestens 20h/Woche erforderlich.

Mehr Infos:
#link("https://karenz-wizard.at/arbeitssuchend-karenz/")[karenz-wizard.at/arbeitssuchend-karenz].

// ============================================================
//  ABSCHLUSS
// ============================================================

= Abschluss

- TODO: Vor der Antragstellung individuell bei AK oder ÖGK beraten
  lassen — viele Regeln, jede Familiensituation ist anders.
- TODO: Quelle/Verweis auf #link("https://karenz-wizard.at")[karenz-wizard.at];
  #dokument-stand.
