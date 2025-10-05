export type Person = 'Mutter' | 'Vater';

export type InputBlock = {
	enabled: boolean;
	person: Person;
	months: number; // 0..24
};

export type PlacedBlock = {
	person: Person;
	start: number; // in Monaten ab Geburt
	end: number; // in Monaten ab Geburt
	color: string;
};
