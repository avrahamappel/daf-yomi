import { HDate, Zmanim, GeoLocation } from '@hebcal/core'
import { DafYomi } from '@hebcal/learning'
import { Position } from './location';

export * from './location';

type DataArgs = { timezone: string, timestamp: number };

const geoLocation = ({ latitude, longitude, name, altitude }: Position, timezone: string) =>
    new GeoLocation(
        name || null,
        latitude,
        longitude,
        altitude || 0,
        timezone
    );

// TODO generate a calendar and use for getting parsha, yom tov etc.

const getZemanim = (hdate: HDate, pos: Position, timezone: string) => {
    try {
        const gloc = geoLocation(pos, timezone);
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

export const getData = ({ timestamp, timezone }: DataArgs, pos: Position) => {
    const date = new Date(timestamp);
    const hdate = new HDate(date);
    const daf = new DafYomi(hdate);

    let zemanim = getZemanim(hdate, pos, timezone);

    return {
        date: date.toDateString(),
        hdate: hdate.renderGematriya(true),
        // TODO day of week
        dafYomi: daf.render('he'),
        zemanim,
    };
};
