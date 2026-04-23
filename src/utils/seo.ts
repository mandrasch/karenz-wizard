export type SeoMeta = {
	title: string;
	description: string;
	/** Optional per-route og:image path, relative to the site root (e.g. '/my-og.png'). Falls back to default. */
	image?: string;
};

type SeoEntry = {
	match: string;
	meta: SeoMeta;
};

const defaultMeta: SeoMeta = {
	title: 'Karenz Wizard – Der Elternzeitplaner für Österreich',
	description:
		'Tools und Infos rund um Karenzplanung, Familienzeitbonus, Kinderbetreuungsgeld und Beratungsstellen in Österreich. Für mehr Gleichberechtigung und Väterkarenz!'
};

const seoEntries: SeoEntry[] = [
	{
		match: '/',
		meta: {
			title: 'Karenz Wizard – Der Elternzeitplaner für Österreich',
			description:
				'Tools und Infos rund um Karenzplanung, Familienzeitbonus, Kinderbetreuungsgeld und Beratungsstellen in Österreich. Für mehr Gleichberechtigung und Väterkarenz!'
		}
	},
	{
		match: '/blog/',
		meta: {
			title: 'Blog – Karenz Wizard',
			description:
				'Aktuelle Hinweise zu Kinderbetreuungsgeld, Karenzplanung, Papamonat und neuen Funktionen des Karenz Wizard.'
		}
	},
	{
		match: '/ak-beratung/',
		meta: {
			title: 'AK Beratung & Kontaktstellen – Karenz Wizard',
			description:
				'Links zur Arbeiterkammer und anderen Beratungsstellen für Karenz, Familienzeitbonus und Mitversicherung.'
		}
	},
	{
		match: '/buecher-broschueren/',
		meta: {
			title: 'Bücher & Broschüren zur Elternkarenz – Karenz Wizard',
			description:
				'Empfehlungen zu Literatur, Broschüren und Ratgebern rund um Elternkarenz in Österreich.'
		}
	},
	{
		match: '/schritte-im-ueberblick/',
		meta: {
			title: 'Die Schritte im Überblick – Karenz Wizard',
			description:
				'Einstieg in die Karenzplanung für werdende Eltern in Österreich — Papamonat, eaKBG, Karenzaufteilung, Eltern-Teilzeit, unbezahlte Karenz und Fremdbetreuung auf einen Blick.'
		}
	},
	{
		match: '/eakbg-anspruch/',
		meta: {
			title: 'eaKBG Anspruch prüfen – Karenz Wizard',
			description:
				'Checkliste für das einkommensabhängige Kinderbetreuungsgeld: Voraussetzungen, Fristen und Tipps für Mutter und Vater.'
		}
	},
	{
		match: '/oegk-beratung/',
		meta: {
			title: 'ÖGK-Beratung – Karenz Wizard',
			description:
				'Kontaktstellen und Informationen der Österreichischen Gesundheitskasse (ÖGK) zu Kinderbetreuungsgeld, Krankenversicherung und Mitversicherung während der Karenz.'
		}
	},
	{
		match: '/eakbg-planer/',
		meta: {
			title: 'eaKBG Karenz-Planer – Karenz Wizard',
			description:
				'Plane euren Karenzverlauf Schritt für Schritt: Monate kombinieren, Papamonat berücksichtigen und Fristen im Blick behalten.'
		}
	},
	{
		match: '/elternteilzeit-20-20/',
		meta: {
			title: 'Eltern-Teilzeit 20h/20h Woche – Karenz Wizard',
			description:
				'Aufteilung nach den 14 Monaten eaKBG: beide Elternteile in Eltern-Teilzeit mit je ca. 20 Stunden pro Woche. Voraussetzungen, Anspruch und AK-Beratung.'
		}
	},
	{
		match: '/online-berater/',
		meta: {
			title: 'Online-Berater (Beta) – Karenz Wizard',
			description:
				'Interaktiver Schritt-für-Schritt-Assistent durch Mutterschutz und Karenz. Beta-Version, noch nicht öffentlich freigegeben.'
		}
	},
	{
		match: '/faq/',
		meta: {
			title: 'FAQ zu Papamonat & Karenz – Karenz Wizard',
			description:
				'Häufige Fragen zu Familienzeitbonus, Papamonat, Karenzmodellen und Krankenversicherung kompakt beantwortet.'
		}
	},
	{
		match: '/fzb-anspruch/',
		meta: {
			title: 'Familienzeitbonus Anspruch – Karenz Wizard',
			description:
				'Checkliste für Väter: Prüfe, ob du Anspruch auf den Familienzeitbonus im Papamonat hast und was dafür nötig ist.'
		}
	},
	{
		match: '/impressum-datenschutz/',
		meta: {
			title: 'Impressum & Datenschutz – Karenz Wizard',
			description:
				'Rechtliche Informationen, Haftungsausschluss und Hinweise zum Datenschutz für den Karenz Wizard.'
		}
	},
	{
		match: '/infothek/',
		meta: {
			title: 'Infothek & Ressourcen – Karenz Wizard',
			description:
				'Kuratiertes Wissen zu Gleichberechtigung, Karenz, Tools und Videos – alles auf einen Blick für eure Planung.'
		}
	},
	{
		match: '/pauschales-kbg/',
		meta: {
			title: 'Pauschales Kinderbetreuungsgeld – Karenz Wizard',
			description:
				'Grundlagen zum KBG-Konto: Bezugsdauer, Aufteilung, Unterschiede zum einkommensabhängigen Modell und wo es Beratung gibt.'
		}
	},
	{
		match: '/reaktionen-und-feedback/',
		meta: {
			title: 'Reaktionen & Feedback – Karenz Wizard',
			description:
				'Stimmen aus der Community, Rückmeldungen von Eltern und Hinweise, wie du Feedback zum Karenz Wizard geben kannst.'
		}
	},
	{
		match: '/tools/',
		meta: {
			title: 'Tools & Rechner – Karenz Wizard',
			description:
				'Praktische Werkzeuge für Eltern: Rechner, Vorlagen und Links rund um Karenz, Papamonat und Mitversicherung.'
		}
	},
	{
		match: '/ueber/',
		meta: {
			title: 'Über den Karenz Wizard',
			description:
				'Warum dieses Hobbyprojekt entstanden ist, wer dahinter steckt und welche Ziele der Karenz Wizard verfolgt.'
		}
	},
	{
		match: '/videos/',
		meta: {
			title: 'Videos & Erklärungen – Karenz Wizard',
			description:
				'Verlinkte Videoressourcen zur Elternkarenz, Meldungen, Papamonat und Kinderbetreuungsgeld.'
		}
	},
	{
		match: '/unbezahlte-karenz/',
		meta: {
			title: 'Unbezahlte Karenz planen – Karenz Wizard',
			description:
				'Infos zur Verlängerung nach eaKBG: Mitversicherung, finanzielle Planung und mögliche Stolperfallen.'
		}
	},
	{
		match: '/antrag-stellen/',
		meta: {
			title: 'Antrag stellen – Karenz Wizard',
			description:
				'Schritt-für-Schritt: Welche Anträge ihr für Karenz und Kinderbetreuungsgeld stellen müsst.'
		}
	},
	{
		match: '/pensionssplitting/',
		meta: {
			title: 'Pensionssplitting – Karenz Wizard',
			description:
				'Pensionssplitting während der Karenz: Was es ist und wie ihr es als Paar angehen könnt.'
		}
	},
	// TODO: use description from markdown files?
	{
		match: '/blog/*',
		meta: {
			title: 'Blog & Updates – Karenz Wizard',
			description:
				'Aktuelle Gedanken und Hinweise zum Kinderbetreuungsgeld, Karenzplanung und politischen Entwicklungen.'
		}
	}
];

const normalizePath = (pathname: string) => {
	if (!pathname) return '/';
	return pathname.endsWith('/') ? pathname : `${pathname}/`;
};

export const getSeoMeta = (pathname: string): SeoMeta => {
	const normalized = normalizePath(pathname);

	for (const entry of seoEntries) {
		if (entry.match.endsWith('*')) {
			const base = entry.match.slice(0, -1);
			if (normalized.startsWith(base)) {
				return entry.meta;
			}
			continue;
		}

		if (entry.match === normalized) {
			return entry.meta;
		}
	}

	return defaultMeta;
};
