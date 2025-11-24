// Example Oraysa program for hebcal-learning
// - Adapt imports to match your repo structure (date utility, daf list, Program type).
// - This file is intentionally self-contained to show the algorithm and helpers.

import { differenceInCalendarDays, eachDayOfInterval, isSameDay, parseISO } from 'date-fns';

// Replace this with the repo's canonical DafYomi sequence (array of { tractate, dafNumber, maybeId })
type DafEntry = { tractate: string; daf: number }; // minimal shape used here

// Example placeholder: import the actual array used by the Daf Yomi program
// import { DAF_SEQUENCE } from '../data/daf-sequence';
const DAF_SEQUENCE: DafEntry[] = [
  // ... real daf list here; this placeholder must be replaced
  { tractate: 'Berakhot', daf: 2 },
  /* ... */
];

export type AmudResult = {
  date: string; // ISO date
  kind: 'study' | 'review';
  amudIndex?: number; // linear amud counter since start (0-based)
  daf?: string; // e.g. "Chagigah 25"
  side?: 'a' | 'b';
  tractate?: string;
};

export const ORAYSA = {
  id: 'oraysa',
  title: 'Oraysa (amud-a-day with weekend review)',
  description:
    'Study one amud every study day (Mon–Fri). Saturday and Sunday are reserved as review days for that week.',
  // Configure start date (set to your best-guess; keep configurable)
  // defaultStartDate: '2022-11-15', // YYYY-MM-DD (update if you confirm a different start)
  defaultStartDate: '2020-01-05',
  // Which weekdays are considered study days? 0=Sunday, 1=Monday, ... 6=Saturday
  studyWeekdays: [1, 2, 3, 4, 5], // Mon-Fri
  reviewWeekdays: [6, 0], // Sat, Sun
  // Public helpers:
  isStudyDay(date: Date) {
    const wd = date.getDay();
    return (this.studyWeekdays as number[]).includes(wd);
  },

  // Count study-days between startDate (inclusive) and targetDate (inclusive).
  // Returns 0-based amud index for the first study day (startDate if study) -> 0
  getAmudIndexForDate(startIso: string, date: Date): number | null {
    const start = parseISO(startIso);
    if (date < start) return null;
    // iterate days and count only study days
    const days = eachDayOfInterval({ start, end: date });
    let count = 0;
    for (const d of days) {
      if (this.isStudyDay(d)) {
        // count this study day as one amud
        count++;
      }
    }
    // If the target date is not a study day, it's a review day; return the last study amudIndex
    const isStudy = this.isStudyDay(date);
    if (isStudy) return count - 1; // 0-based
    return count - 1; // review days map to last studied amud index (same amud during review)
  },

  // Map linear amud index to daf + side using an existing daf sequence.
  // amudIndex: 0 => first amud (first daf, side 'a')
  amudIndexToDaf(amudIndex: number): { tractate: string; dafLabel: string; side: 'a' | 'b' } {
    const dafIndex = Math.floor(amudIndex / 2); // two amudim per daf
    const side = amudIndex % 2 === 0 ? 'a' : 'b';
    const dafEntry = DAF_SEQUENCE[dafIndex];
    if (!dafEntry) {
      return { tractate: 'UNKNOWN', dafLabel: String(dafIndex + 1), side };
    }
    return {
      tractate: dafEntry.tractate,
      dafLabel: `${dafEntry.tractate} ${dafEntry.daf}`,
      side,
    };
  },

  // Compute the amud / review info for a given date.
  getForDate(startIso: string, date: Date): AmudResult {
    const amudIndex = this.getAmudIndexForDate(startIso, date);
    const iso = date.toISOString().slice(0, 10);
    if (amudIndex == null || amudIndex < 0) {
      return { date: iso, kind: 'review' };
    }
    const isStudy = this.isStudyDay(date);
    const kind: 'study' | 'review' = isStudy ? 'study' : 'review';
    const mapping = this.amudIndexToDaf(amudIndex);
    return {
      date: iso,
      kind,
      amudIndex,
      daf: mapping.dafLabel,
      side: mapping.side,
      tractate: mapping.tractate,
    };
  },

  // Generate a schedule array for a date range (inclusive).
  generateSchedule(startIso: string, rangeStart: string, rangeEnd: string): AmudResult[] {
    const start = parseISO(rangeStart);
    const end = parseISO(rangeEnd);
    const days = eachDayOfInterval({ start, end });
    return days.map((d) => this.getForDate(startIso, d));
  },
};

export default ORAYSA;
