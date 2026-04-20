// src/lib/wizard-types.ts
// Shared types for the decision-tree wizard.

export type Answer = 'yes' | 'no' | 'maybe';

export type ComputedKey = 'mutterschutzStart' | 'mutterschutzEnd';

export interface VideoRef {
  youtubeId: string;
  title: string;
}

export interface SourceLink {
  label: string;
  url: string;
}

export interface Callout {
  label: string;
  body: string;
}

export interface ChoiceOption {
  value: string;
  label: string;
  next: string;
}

interface NodeBase {
  id: string;
  video?: VideoRef;
  sources?: SourceLink[];
}

export interface QuestionNode extends NodeBase {
  kind: 'question';
  text: string;
  help?: string;
  next: Record<Answer, string>;
}

export interface ChoiceNode extends NodeBase {
  kind: 'choice';
  text: string;
  help?: string;
  options: ChoiceOption[];
}

export interface InfoNode extends NodeBase {
  kind: 'info';
  title: string;
  body: string;
  callout?: Callout;
  computed?: ComputedKey;
  computedLabel?: string;
  next: string;
}

export interface DateNode extends NodeBase {
  kind: 'date';
  text: string;
  help?: string;
  storeAs: string;
  next: string;
}

export interface ResultNode extends NodeBase {
  kind: 'result';
  title: string;
  body: string;
}

export type WizardNode =
  | QuestionNode
  | ChoiceNode
  | InfoNode
  | DateNode
  | ResultNode;

export interface Wizard {
  start: string;
  nodes: WizardNode[];
}

export type HistoryEntry = {
  nodeId: string;
  answer?: Answer;
  value?: string;
};
