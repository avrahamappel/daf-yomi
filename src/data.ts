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
import { DafYomiEvent, NachYomiEvent, NachYomiIndex } from '@hebcal/learning'
import { Position } from './location';

/**
 * Build an instance of hebcal's GeoLocation
 */
const geoLocation = ({ latitude, longitude, name, altitude }: Position) =>
    new GeoLocation(
        name || null,
        latitude,
        longitude,
        altitude || 0,
        // Don't need a time zone, we send a raw timestamp back to the Elm app
        'Utc'
    );

type Zeman = { name: string, value: number };

const getZemanim = (hdate: HDate, pos: Position) => {
    try {
        const gloc = geoLocation(pos);
        const zmn = new Zmanim(gloc, hdate);
        const erevShabbosYtZemanim = getErevShabbosYtZemanim(hdate, gloc, zmn);
        const zemanim = [
            { name: 'חצות הלילה', value: zmn.chatzotNight().getTime() },
            { name: 'עלות השחר', value: zmn.sunriseOffset(-72).getTime() },
            { name: 'הנץ החמה', value: zmn.neitzHaChama().getTime() },
            { name: 'ס״ז קריאת שמע', value: zmn.sofZmanShmaMGA().getTime() },
            { name: 'חצות היום', value: zmn.chatzot().getTime() },
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

type Profile = 'to-w' | 'to-s' | 'mwk';

/**
 * Get the candle lighting times for this date (if erev shabbos or y"t)
 */
const getErevShabbosYtZemanim = (hdate: HDate, gloc: GeoLocation, zmn: Zmanim) => {
    // Get current profile
    const params = Object.fromEntries(
        window.location.search.slice(1).split('&').map(pair => pair.split('='))
    );
    const profile: Profile = params.p || 'mwk';
    const location = new Location(
        gloc.getLatitude(),
        gloc.getLongitude(),
        false,
        gloc.getTimeZone()
    );
    const events = HebrewCalendar.calendar({
        candlelighting: true,
        candleLightingMins: profile === 'mwk' ? 18 : 15,
        mask: flags.EREV, // Include yom tov
        start: hdate,
        end: hdate,
        location,
    });

    return events.reduce((acc, event) => {
        if (event instanceof CandleLightingEvent) {
            if (profile === 'to-s') {
                // Calculate plag with MG"A hours
                // MG"A hours are 12 minutes longer than GR"A hours, and plag is 4.75 hours after chatzos
                const mgaOffset = 4.75 * 12 * 60 * 1000;
                const mgaPlag = zmn.plagHaMincha().getTime() + mgaOffset;
                // mincha is 40 minutes earlier
                acc.push({ name: 'מנחה מוקדמת', value: mgaPlag - (40 * 60 * 1000) });
                acc.push({ name: 'פלג המנחה', value: mgaPlag });
            }
            acc.push({ name: 'הדלקת נרות', value: event.eventTime.getTime() });
        }
        return acc;
    }, [] as Zeman[]);
};


/**
 * Get the shiurim for the given date
 */
const getShiurim = (hdate: HDate) => {
    const dafShiurim = [
        hdate,
        hdate.subtract(1, 'year'),
        hdate.subtract(2, 'years')
    ].map((hd) => {
        let daf = new DafYomiEvent(hd);
        let url = daf.url();

        return {
            name: "דף היומי" + (hd.isSameDate(hdate) ? '' : ` - ${hd.renderGematriya().split(' ').slice(-1)}`),
            value: daf.renderBrief('he-x-NoNikud'),
            url
        };
    });
    const nachYomi = new NachYomiEvent(hdate, (new NachYomiIndex()).lookup(hdate));
    const nachYomiShiur = {
        name: 'נ״ך יומי',
        value: nachYomi.render('he-x-NoNikud'),
        url: nachYomi.url(),
    };

    return [
        ...dafShiurim,
        nachYomiShiur,
    ]
};

/**
 * Get the parsha of the week
 */
const getParsha = (hdate: HDate) => new Sedra(hdate.getFullYear()).getString(hdate, 'he-x-NoNikud');

export const getData = (timestamp: number, pos: Position) => {
    const date = new Date(timestamp);
    const hdate = new HDate(date);

    const zemanim = getZemanim(hdate, pos);
    const shiurim = getShiurim(hdate);
    const parsha = getParsha(hdate);

    return {
        date: date.toDateString(),
        hdate: hdate.renderGematriya(true),
        zemanim,
        shiurim,
        parsha
    };
};
