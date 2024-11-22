import {
    HDate,
    Zmanim,
    GeoLocation,
    HebrewCalendar,
    flags,
    Location,
    CandleLightingEvent,
    Sedra
} from '@hebcal/core'
import { DafYomi, NachYomiEvent, NachYomiIndex } from '@hebcal/learning'
import { Position } from './location';
import { Settings } from './settings';

/**
 * Build an instance of hebcal's GeoLocation
 */
const getGeoLocation = ({ latitude, longitude, name, altitude }: Position) =>
    new GeoLocation(
        name || null,
        latitude,
        longitude,
        altitude || 0,
        // Don't need a time zone, we send a raw timestamp back to the Elm app
        'Utc'
    );

const getLocation = (gloc: GeoLocation) => {
    const location = new Location(
        gloc.getLatitude(),
        gloc.getLongitude(),
        false,
        gloc.getTimeZone()
    );
    location.setElevation(gloc.getElevation());
    return location;
};

type Zeman = { name: string, value: number };

const getZemanim = (settings: Settings, hdate: HDate, gloc: GeoLocation) => {
    try {
        const zmn = new Zmanim(gloc, hdate);
        const erevPesachZemanim = getErevPesachZemanim(hdate, zmn);
        const erevShabbosYtZemanim = getErevShabbosYtZemanim(settings, hdate, gloc, zmn);
        const zemanim = [
            { name: 'חצות הלילה', value: zmn.chatzotNight().getTime() },
            { name: 'עלות השחר', value: zmn.sunriseOffset(-72).getTime() },
            { name: 'הנץ החמה', value: zmn.neitzHaChama().getTime() },
            { name: 'סו״ז קריאת שמע', value: zmn.sofZmanShmaMGA().getTime() },
            ...erevPesachZemanim,
            { name: 'סו״ז תפילה (גר"א)', value: zmn.sofZmanTfilla().getTime() },
            { name: 'חצות היום', value: zmn.chatzot().getTime() },
            { name: 'מנחה קטנה', value: zmn.minchaKetanaMGA().getTime() },
            ...erevShabbosYtZemanim,
            { name: 'שקיעת החמה', value: zmn.shkiah().getTime() },
            { name: 'צאת הכוכבים', value: zmn.sunsetOffset(72).getTime() },
        ];

        return {
            zemanim,
            latitude: gloc.getLatitude().toFixed(2),
            longitude: gloc.getLongitude().toFixed(2),
            name: gloc.getLocationName() || null,
        };
    } catch (error) {
        return error.message ?? error;
    }
};

/**
 * Get the candle lighting times for this date (if erev shabbos or y"t)
 */
const getErevShabbosYtZemanim = (settings: Settings, hdate: HDate, gloc: GeoLocation, zmn: Zmanim) => {
    const events = HebrewCalendar.calendar({
        candlelighting: true,
        candleLightingMins: settings.candleLightingMinutes,
        mask: flags.EREV, // Include yom tov
        start: hdate,
        end: hdate,
        location: getLocation(gloc),
    });

    return events.reduce((acc, event) => {
        if (event instanceof CandleLightingEvent) {
            if (settings.showPlag) {
                // Calculate plag with MG"A hours
                // MG"A hours are 12 minutes longer than GR"A hours, and plag is 4.75 hours after chatzos
                const mgaOffset = 4.75 * 12 * 60 * 1000;
                const mgaPlag = zmn.plagHaMincha().getTime() + mgaOffset;
                // mincha is 40 minutes earlier
                // acc.push({ name: 'מנחה מוקדמת', value: mgaPlag - (40 * 60 * 1000) });
                acc.push({ name: 'פלג המנחה', value: mgaPlag });
            }
            acc.push({ name: 'הדלקת נרות', value: event.eventTime.getTime() });
        }
        return acc;
    }, [] as Zeman[]);
};

/**
 * Get zemanim for erev Pesach acc. to MG"A
 */
const getErevPesachZemanim = (hdate: HDate, zmn: Zmanim) => {
    if (!(hdate.getMonth() === 1 && hdate.getDate() === 14)) return [];

    const [alot72, temporalHour] = zmn.getTemporalHour72();
    const sofZmanAchila = Math.floor(alot72.getTime() + 4 * temporalHour);
    const sofZmanBiur = Math.floor(alot72.getTime() + 5 * temporalHour);

    return [
        { name: "ס״ז אכילת חמץ", value: sofZmanAchila },
        { name: "ס״ז ביאור חמץ", value: sofZmanBiur },
    ];
};

/**
 * Get the shiurim for the given date
 */
const getShiurim = (hdate: HDate) => {
    const dafShiur = {
        name: "דף היומי" + '',
        value: (new DafYomi(hdate)).render('he')
    };
    const nachYomi = new NachYomiEvent(hdate, (new NachYomiIndex()).lookup(hdate));
    const nachYomiShiur = {
        name: 'נ״ך יומי',
        value: nachYomi.render('he-x-NoNikud'),
    };

    return [
        dafShiur,
        nachYomiShiur,
    ]
};

/**
 * Get the parsha of the week
 */
const getParsha = (hdate: HDate, gloc: GeoLocation): string => {
    const chagEvents = HebrewCalendar.calendar({
        mask: flags.EREV
            | flags.CHAG
            | flags.CHOL_HAMOED
            | flags.SHABBAT_MEVARCHIM
            | flags.ROSH_CHODESH
            | flags.CHANUKAH_CANDLES
            | flags.MAJOR_FAST
            | flags.MINOR_FAST
            | flags.SPECIAL_SHABBAT
            | flags.MINOR_HOLIDAY
            | flags.OMER_COUNT
        ,
        start: hdate,
        end: hdate,
        location: getLocation(gloc),
    })
    const chagStrs = chagEvents.map(ev => ev.render('he-x-NoNikud'));

    const sedra = new Sedra(hdate.getFullYear());
    if (sedra.isParsha(hdate)) {
        const parsha = sedra.getString(hdate, 'he-x-NoNikud');
        chagStrs.unshift(parsha);
    }

    return chagStrs.join(', ');
};

export const getData = (settings: Settings, timestamp: number, pos: Position) => {
    const date = new Date(timestamp);
    const hdate = new HDate(date);
    const gloc = getGeoLocation(pos);

    const zemanim = getZemanim(settings, hdate, gloc);
    const shiurim = getShiurim(hdate);
    const parsha = getParsha(hdate, gloc);

    return {
        date: date.toDateString(),
        hdate: hdate.renderGematriya(true),
        zemanim,
        shiurim,
        parsha
    };
};
