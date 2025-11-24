import ORAYSA from '../oraysa';

const TEST_DAF_SEQUENCE = [
  { tractate: 'Chagigah', daf: 25 },
  { tractate: 'Chagigah', daf: 26 },
  { tractate: 'Berakhot', daf: 2 },
];

beforeAll(() => {
  // Replace the amudIndexToDaf method for deterministic tests that don't depend on the repo's daf list.
  // @ts-ignore - override for testing
  ORAYSA.amudIndexToDaf = (amudIndex: number) => {
    const dafIndex = Math.floor(amudIndex / 2);
    const side = amudIndex % 2 === 0 ? 'a' : 'b';
    const entry = TEST_DAF_SEQUENCE[dafIndex];
    if (!entry) {
      return { tractate: 'UNKNOWN', dafLabel: String(dafIndex + 1), side };
    }
    return {
      tractate: entry.tractate,
      dafLabel: `${entry.tractate} ${entry.daf}`,
      side,
    };
  };
});

describe('Oraysa program basic behavior', () => {
  const startIso = '2022-11-15';

  test('first study day maps to first amud (a)', () => {
    const res = ORAYSA.getForDate(startIso, new Date('2022-11-15'));
    expect(res.kind).toBe('study');
    expect(res.amudIndex).toBe(0);
    expect(res.daf).toBe('Chagigah 25');
    expect(res.side).toBe('a');
  });

  test('second study day maps to first amud (b)', () => {
    const res = ORAYSA.getForDate(startIso, new Date('2022-11-16'));
    expect(res.kind).toBe('study');
    expect(res.amudIndex).toBe(1);
    expect(res.daf).toBe('Chagigah 25');
    expect(res.side).toBe('b');
  });

  test('weekend day is review and maps to last studied amud index', () => {
    // 2022-11-19 is Saturday; with Mon-Fri study days the last study before it is 2022-11-18
    const res = ORAYSA.getForDate(startIso, new Date('2022-11-19'));
    expect(res.kind).toBe('review');
    expect(res.amudIndex).toBe(3); // Tue(0),Wed(1),Thu(2),Fri(3)
    expect(res.daf).toBe('Chagigah 26');
    expect(res.side).toBe('b');
  });

  test('generateSchedule produces 5 study + 2 review for a Tue-Mon week', () => {
    const schedule = ORAYSA.generateSchedule(startIso, '2022-11-15', '2022-11-21');
    expect(schedule).toHaveLength(7);

    const studyDays = schedule.filter((s) => s.kind === 'study');
    const reviewDays = schedule.filter((s) => s.kind === 'review');

    expect(studyDays).toHaveLength(5);
    expect(reviewDays).toHaveLength(2);

    // Confirm amudIndex increases on study days and final amudIndex is 4 for that 7-day span
    const studyIndices = studyDays.map((s) => s.amudIndex);
    expect(studyIndices).toEqual([0, 1, 2, 3, 4]);
    expect(schedule[schedule.length - 1].amudIndex).toBe(4);
  });

  test('dates before start return null amud index via getAmudIndexForDate', () => {
    const before = ORAYSA.getAmudIndexForDate(startIso, new Date('2022-11-14'));
    expect(before).toBeNull();
  });
});
