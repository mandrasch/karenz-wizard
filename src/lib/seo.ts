export type SeoMeta = {
	title: string;
	description: string;
};

type SeoEntry = {
	match: string;
	meta: SeoMeta;
};

const defaultMeta: SeoMeta = {
	title: 'Karenz Wizard – Der Karenzplaner für Österreich',
	description:
		'Tools und Infos rund um Karenzplanung, Familienzeitbonus, Kinderbetreuungsgeld und Beratungsstellen in Österreich. Für mehr Gleichberechtigung!'
};

const seoEntries: SeoEntry[] = [
	{
		match: '/',
		meta: {
			title: 'Karenz Wizard – Der Karenzplaner für Österreich',
			description:
				'Überblick über Karenzmodelle, Papamonat und Familienzeitbonus. Erhalte verständliche Infos und Tools für eure Karenzplanung.'
		}
	},
	{
		match: '/blog/',
		meta: {
			title: 'Blog – Karenz Wizard',
			description:
				'Aktuelle Hinweise zu Kinderbetreuungsgeld, Karenzplanung, Papamonat und neue Funktionen des Karenz Wizard.'
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
		match: '/eakbg-anspruch/',
		meta: {
			title: 'eaKBG Anspruch prüfen – Karenz Wizard',
			description:
				'Checkliste für das einkommensabhängige Kinderbetreuungsgeld: Voraussetzungen, Fristen und Tipps für Mutter und Vater.'
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
