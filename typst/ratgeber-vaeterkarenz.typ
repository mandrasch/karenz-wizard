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
  author: "Matthias Andrasch für karenz-wizard.at",
)

#set page(
  paper: "a4",
  margin: (x: 2.2cm, top: 2.4cm, bottom: 4.0cm),
  footer: context [
    #line(length: 100%, stroke: 0.5pt + luma(205))
    #v(4pt)
    #set text(size: 8pt, fill: luma(105))
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      link("https://karenz-wizard.at")[karenz-wizard.at],
      [Seite: #counter(page).display()],
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

#set heading(numbering: "1.")
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
//  COVERSEITE (typografisch, viel Weissraum, sparsam Farbe)
//  Option A: kein Vollrahmen, duenne Akzentlinie, Maskottchen
//  klein in der Fusszeile. Augenschonend & toner-sparsam druckbar.
// ============================================================

#page(footer: none, margin: (left: 3cm, right: 3cm, top: 3.2cm, bottom: 3cm))[
  #set par(justify: false, leading: 0.6em)
  #grid(
    rows: (1fr, auto, 1fr),
    // --- oben: Kicker ---
    align(top + left)[
      #text(size: 11pt, fill: rgb("#F99435"), weight: "bold", tracking: 1.2pt)[
        MINI-RATGEBER FÜR VÄTER
      ]
    ],
    // --- Mitte: Titel + Akzentlinie + Untertitel (linksbuendig) ---
    align(horizon + left)[
      #text(size: 30pt, weight: "bold")[
        Wie man als Vater mehr als 2 Monate Karenz nimmt
      ]
      // Untertitel direkt unter dem Titel (kleiner + leichter, linksbuendig)
      #v(10pt)
      #text(size: 16pt, fill: luma(95), weight: "regular")[
        … oder anderweitig mehr Verantwortung übernimmt
        in den ersten Jahren mit Kind
      ]
      // Akzentlinie als Abschluss unter Titel + Untertitel
      #v(20pt)
      #line(length: 16%, stroke: 3pt + rgb("#F99435"))
    ],
    // --- unten: Wortmarke + kleines Maskottchen ---
    align(bottom + left)[
      #grid(
        columns: (1fr, auto),
        align: (left + horizon, right + horizon),
        link("https://karenz-wizard.at")[
          #text(fill: rgb("#F99435"), weight: "bold", size: 13pt)[karenz-wizard.at]
        ],
        image("../src/lib/assets/logo.png", width: 2cm),
      )
    ],
  )
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
  Dies ist noch ein Entwurfstext. Kritisches Anmerkungen, allgemeines Feedback oder weitere Cases / Möglichkeiten sehr gerne an mich per Mail schicken. Vielen Dank! 

  E-Mail: #link("mailto:matthias-andrasch-kontakt@mailbox.org")[matthias-andrasch-kontakt\@mailbox.org]

  #text(size: 11pt)[#dokument-stand]

  #v(16pt)
  *Keine Rechtsberatung*
  
  #v(10pt)
  Dieser Ratgeber ist ein privates,
    nichtkommerzielles Hobbyprojekt. Alle Angaben ohne Gewähr. Die Informationen sind 
    unverbindlich und ggf. unvollständig, fehlerhaft oder veraltet. Es handelt sich nicht um eine  individuelle Rechts-, Steuer- oder Sozialberatung. Für
    verbindliche Auskünfte und vor jeder Antragstellung wende dich bitte unbedingt an
    die zuständigen Stellen (Arbeiterkammer, ÖGK, Gewerkschaft /
    Betriebsrat, etc.).

  #v(16pt)
  *Lizenz: CC0 / Public Domain*

  #link("https://creativecommons.org/publicdomain/zero/1.0/")[
    #image("assets/cc-zero.png", width: 2.6cm)
  ]
  #v(10pt)
  Autor: Matthias Andrasch für karenz-wizard.at \
  Freigeben als #link("https://creativecommons.org/publicdomain/zero/1.0/")[https://\u{200B}creativecommons.org/\u{200B}publicdomain/\u{200B}zero/\u{200B}1.0]
]

// ============================================================
//  INHALTSVERZEICHNIS (eigene Seite)
// ============================================================

#page(footer: none, margin: (x: 2.2cm, top: 2.4cm, bottom: 4.0cm))[
  #heading(outlined: false, numbering: none)[Inhalt]
  #v(6pt)
  #outline(title: none, depth: 2, indent: auto)
]

#counter(page).update(1)

// TODO: Größtes Problem noch - ist für eaKBG geschrieben, für alle schreiben? Oder vom "Durchschnittsfall" ausgehen?

// ============================================================
//  EINLEITUNG
// ============================================================

#set quote(block: true)
#quote(
  attribution: link("https://typst.app/home")[Zitat aus der Eltern-Umfrage von Bernhard Herzog,  2026]
)[
  „Vieles von dem, was Väter heute erstmals als Hürde erleben, ist für Frauen am Arbeitsmarkt seit Jahrzehnten Realität.“
]

#pagebreak()
#heading(numbering: none)[Prolog]




Wie verdammt nochmal nimmt man als Vater mehr als zwei Monate Karenz?  Diese Frage hat mir einige schlaflose Nächte bereitet.

Angefangen hat alles mit einem Wunsch meiner Partnerin: Sie wollte das erste
Lebensjahr mit unserem Kind zu Hause zu erleben. Mit den Details zu
Kinderbetreuungsgeld und Karenz hatten wir uns da noch gar nicht
beschäftigt. 

Zur selben Zeit las ich immer wieder in Medienberichten: „Väter
nehmen nur zwei Monate Karenz in Österreich — wenn überhaupt.“.

Das saß. Ich wollte ein moderner Vater sein und gleichberechtigte
Elternschaft wirklich versuchen. Kein Super-Dad - aber eben einer, der seine Partnerin nicht allein mit Betreuung und Mental Load lässt.

 Mein Vorsatz war klar: Bloß nicht so ein Zwei-Monate-Vater werden!

Doch schnell stellte sich raus, dass das einkommensabhängige Kinderbetreuungsgeld nur
für maximal 14 Monate gut bezahlt (rund 80 % des Einkommens) wird. Nimmt
meine Partnerin davon zwölf Monate, bleiben mir — genau — die viel
kritisierten zwei Monate.

Heute weiß ich: Ruhig bleiben, die Karenzaufteilung ist nicht alles! Wer
es sich leisten kann, hat zwar Optionen wie unbezahlte Karenzmonate. Aber auch nach der Karenz gibt es Optionen wie die Eltern-Teilzeit, bei der man als Vater echte Verantwortung übernehmen kann. Neben vielen weiteren Optionen für mehr Väterbeteiligung.

Diese Möglichkeiten ich nun hier kurz & knackig versucht zu sammeln. Auch, weil ich genau so eine Übersicht damals schmerzlich vermisst
habe.

Viel Erfolg beim Finden deines/eures individuellen Weges!

// ===== ORIGINAL-VERSION (auskommentiert, Stand vor Prolog-Umbau) =====
/*
= Warum dieser Ratgeber?

Wie verdammt nochmal nimmt man als Vater mehr als zwei Monate Karenz? 🤯

Diese Frage klingt simpel - und dennoch bescherte sie mir viele schlaflöse Nächte. 

Aus dem Bauch heraus äußerte meine Partnerin den Wunsch, das erste Lebensjahr mit Kind daheim zu verbringen (und zu erleben). 

Wir hatten uns zu diesem Zeitpunkt noch nicht im Detail mit Kinderbetreuungsgeld oder Karenzregeln beschäftigt.

// TODO: relevant? (schon - zeigt, dass wir auf )
Auf Arbeit bekamen wir beide desöfteren mit, wie Mütter auch eine Bildungskarenz für das zweite Jahr mit Kind als "Brücke zurück ins Erwebsleben" nutzten nach dem ersten Jahr Karenz. Sie machten eine Online-Weiterbildung während sie das Kind daheim betreuten. Diese Möglichkeit gibt es inzwischen nicht mehr bzw. ist explizit untersagt.

Zeitgleich las ich die ersten Medienberichte zur Väterkarenz:

Väter nehmen nur zwei Monate Karenz, wenn überhaupt. \
Väter nehmen nur zwei Monate Karenz, wenn überhaupt. \
Väter nehmen nur zwei Monate Karenz, wenn überhaupt. \

Diese Kritik wurde immer und immer wieder wiederholt.

Natürlich brannte sich das bei mir ein: Ich wollte ein möglichst moderner Vater sein und gleichberechtige Elternschaft ("Halbe Halbe") versuchen. Kein Super-Dad, ein durchschnittlich guter reicht. Ein Vater, der seine Partnerin keineswegs allein mit der Betreuung, dem Mental Load & Co lässt. Diese Ziele hast sicher auch du, wenn du diesen Ratgeber liest.

Die einzig logische Schlussfolgerung war für mich damals: 

Ich darf auf keinen Fall ein weiterer Vater sein, der nur zwei Monate Karenz nimmt!

Beim Beschäftigen mit dem einkommensabhängigen Kinderbetreuungsgeld stellte sich dann  aber schnell heraus, dass maximal 14 Monate gut bezahlt werden vom Staat Österreich (mit 80% des bisherigen Einkommens). Nimmt meine Partnerin also 12 Monate, bleiben mir ... genau, die viel kritisierten zwei Monate. 

// Mir war nämlich damals nicht klar, welche Möglichkeiten es überhaupt gibt. Und so verschwendete ich (leider) auch viel Zeit meines Papamonats mit der Recherche und Beratungsgesprächen.

Heute weiß ich: Ruhig bleiben, die Karenzaufteilung ist nicht alles!

Wer es sich leisten kann, hat zwar Optionen wie unbezahlte Karenzmonate für mehr Väterkarenz. Eine (Eltern-)Teilzeit im Anschluss an die Karenz kann aber ebenso eine Option sein, um echte Verantwortung zu übernehmen. 

Dazu gibt es weitere Möglichkeiten, die ich in diesem kleinen Ratgeber aufgelistet habe.



// Verfasst habe ich diesen Ratgeber, weil ich eine solche Auflistung der Möglichkeiten damals sehr schmerzlich vermisst habe.
// Ich hoffe, er erspart dir einige Kopfschmerzen und mühsame Recherche.

//Daher habe ich nun diesen kleinen Ratgeber geschrieben, der die Möglichkeiten aufzeigen soll. Sodass du dir (hoffentlich) mühsame Recherchezeit und Kopfschmerzen ersparst.

// TODO: Sub-Kapitel ergänzen? Oder ist schon in Checkliste auf Webseite --> dorthin verweisen.
// Und die allerwichtigste Frage taucht oft auch viel zu spät auf: Ab wann wollen wir unser Kind eigentlich fremdbetreuen lassen, beispielsweise im Kindergarten oder bei einer Tagesmutter-Gruppe?

// Long story short: Daher habe ich nun diesen kleinen Ratgeber geschrieben, den ich damals so schmerzlich vermisst habe. Mir waren Optionen nämlich absolut nicht klar, Informationen waren oft verstreut, Beratungsgespräche waren auf Finanzen optimiert - statt auf "Halbe Halbe".

// TODO: remove - put in checklist
// Ein kleiner Tipp vorab noch: Die Frage "Ab wann möchten wir unser Kind fremdbetreuen lassen?" spielt eine ebenso zentrale Rolle bei der Planung der ersten Jahre mit Kind (& Job).


Viel Erfolg beim Finden deines/eures individuellen Weges!
*/
// ===== ENDE ORIGINAL-VERSION =====



// TODO: Ab wann in Kinderbetreuung



// Ich wollte kein Super-Dad werden, durchschnittlich gut würde mir reichen. Ehrlich gesagt hatte (und habe) ich ziemlich Schiss vor der riesigen Verantwortung.

// Ich wollte nur mein Bestmögliches versuchen, gleichberechtigt Verantwortung zu übernehmen. Wie so viele andere Väter heutzutage auch. 
 
 // Wohin das führen kann, konnte ich eindrucksvoll bei Mareike Fallwickl im Buch „Die Wut, die bleibt“ lesen. 

 // TODO: Windelwechsel Zitat - es ist schon viel passiert









// Diese Frage beschäftigte mich seit dem ersten Gespräch mit meiner Partnerin. Bei diesem äußerte sie den Wunsch, das erste Jahr mit Baby daheim zu erleben.


//- Der Zwiespalt / die Challenge — Viele Väter wollen gleichberechtigt Verantwortung übernehmen. Aktuell werden sie medial stark kritisiert, „nur” zwei Monate Karenz zu nehmen. Und dies obwohl beim eaKBG (max. 14 Monate ab Geburt) bspw. nur 2 Monate für den Vater übrig bleiben, wenn die Mutter das erste Jahr mit dem Baby daheim sein möchte.
// - Zielsetzung des Ratgebers — Optionen aufzeigen, wie man mehr als zwei Monate Karenz nimmt - oder anderweitig mehr Verantwortung mitträgt, bspw. durch Eltern-Teilzeit o.ä.


#heading(numbering: none, level: 2)[Disclaimer]

- Dieser Ratgeber zeigt nur *Möglichkeiten im bestehenden Sozialsystem Österreichs* auf.  Politische und systemische Veränderungen sind das andere, ebenso wichtige Thema, wofür es sich einzusetzen lohnt. 
- Eine *Frage der (finanziellen) Möglichkeiten*:  Natürlich ist auch die Karenzplanung auch eine Frage der finanziellen Ressourcen, einige Optionen stehen nur privilegierten Personen (mit finanziellem Puffer) zur Verfügung. Insbesondere bei steigenden Miet- und Lebenshaltungskosten verschärft sich diese Ungleichheit potenziell noch mehr. 
// - Gleichberechtigte Elternschaft bzw. "Halbe Halbe" / "Equal Care" ist so viel mehr als die mathematisch korrekte 50:50-Aufteilung der Elternzeit/Karenz-Monate.
- Nicht zuletzt berichten auch einige Väter von Diskriminierungen im Job, wenn sie ihre Elternzeit in Anspruch nehmen möchten. Es hängt also von vielen Faktoren ab:


// Prolog + Disclaimer sind unnummeriert (Frontmatter) -> Zaehler
// zuruecksetzen, damit das erste echte Kapitel mit "1." startet.
#counter(heading).update(0)

= Crashkurs Kinderbetreuungsgeld

Um die Möglichkeiten zu verstehen, benötigt man ein kleines Basis-Wissen zum Kinderbetreuungsgeld in Österreich. Aber keine Sorge, das ist absolut keine Raketenwissenschaft!

In Österreich gibt es zwei Fördermodelle: 

- das einkommensabhängiges Kinderbetreuungsgeld (eaKBG) für Erwerbstätige und 
- das pauschale Kinderbetreuungsgeld-Konto, was allen offen steht

Als Paar muss man sich gemeinsam für eins entscheiden, Mischen nicht erlaubt.

Das Einkommensabhängige ist jedoch an die
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

== Voraussetzung prüfen: Die 182-Tage-Regel für das einkommensabhängige Kinderbetreuungsgeld

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
//  DIE OPTIONEN
// ============================================================

= Die Optionen im Überblick

Im Folgenden die einzelnen Optionen, wie man als Vater mehr Zeit oder
Verantwortung übernehmen kann.

// ---- Option 1 ----

== Mutter nimmt weniger als 12 Monate — „gibt an Vater ab”

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

// ---- Option 2 ----

== Unbezahlte Karenzmonate anhängen — länger in Karenz als Vater

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

// ---- Option 3 ----

== Eltern-Teilzeit — das 20h/20h-Modell

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

// ---- Option 4 ----

== Bezahlter (oder unbezahlter) Urlaub — Väterkarenz verlängern

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

// ---- Option 5 ----

== AMS & Karenz — Infos zur „AMS-Karenz"

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

// TODO move up 
== TODO: Stunden reduzieren im ersten Jahr

= Abschluss

- TODO: Vor der Antragstellung individuell bei AK oder ÖGK beraten
  lassen — viele Regeln, jede Familiensituation ist anders!
- TODO: Schritte im Überblick auf karenz-wizard.at
- TODO: Fehlt eine Option?
