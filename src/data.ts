import { HDate, Zmanim, GeoLocation } from '@hebcal/core'
import { DafYomi, NachYomiEvent, NachYomiIndex } from '@hebcal/learning'
import { Position } from './location';

/**
 * Get timezone as a string.
 * Should be compatible across various browsers that don't necessarily support the full Intl API
 */
const getTimezone = (): string => {
    let timezone: string | undefined;

    try {
        timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    } catch (_) { }

    if (timezone === undefined) {
        let offset = (new Date()).getTimezoneOffset();

        let hours = Math.floor(Math.abs(offset) / 60);
        let minutes = Math.abs(offset) % 60;
        let sign = offset > 0 ? '+' : offset < 0 ? '-' : '';

        timezone = `${sign}${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
    }

    return timezone;
};

/**
 * Build an instance of hebcal's GeoLocation
 */
const geoLocation = ({ latitude, longitude, name, altitude }: Position) =>
    new GeoLocation(
        name || null,
        latitude,
        longitude,
        altitude || 0,
        getTimezone()
    );

// TODO generate a calendar and use for getting parsha, yom tov etc.

const getZemanim = (hdate: HDate, pos: Position) => {
    try {
        const gloc = geoLocation(pos);
        const zmn = new Zmanim(gloc, hdate);
        const zemanim = [
            { name: 'ס"ז ק"ש מ"א', value: zmn.sofZmanShmaMGA().getTime() },
            { name: 'חצות היום', value: zmn.chatzot().getTime() },
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
 * Get the shiurim for the given date
 */
const getShiurim = (hdate: HDate) => {
    const dafShiurim = [
        hdate,
        hdate.subtract(1, 'year'),
        hdate.subtract(2, 'years')
    ].map((hd) => ({
        name: "דף היומי" + (hd.isSameDate(hdate) ? '' : ` - ${hd.renderGematriya().split(' ').slice(-1)}`),
        value: (new DafYomi(hd)).render('he')
    }));
    const nachYomi = new NachYomiEvent(hdate, (new NachYomiIndex()).lookup(hdate));
    const nachYomiShiur = {
        name: 'נ"ך יומי',
        value: nachYomi.render('he'),
    };

    return  [
            ...dafShiurim,
            nachYomiShiur,
        ]
};

export const getData = (timestamp: number, pos: Position) => {
    const date = new Date(timestamp);
    const hdate = new HDate(date);
    const daf = new DafYomi(hdate);

    let zemanim = getZemanim(hdate, pos);
    let shiurim = getShiurim(hdate);

    return {
        date: date.toDateString(),
        hdate: hdate.renderGematriya(true),
        // TODO day of week
        dafYomi: daf.render('he'),
        zemanim,
        shiurim
    };
};
