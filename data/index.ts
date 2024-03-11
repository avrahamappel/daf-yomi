import { HDate, Zmanim, GeoLocation } from '@hebcal/core'
import { DafYomi } from '@hebcal/learning'

export * from './location';

// TODO generate a calendar and use for getting parsha, yom tov etc.

const getZemanim = (hdate: HDate, gloc: GeoLocation) => {
    try {
        const zmn = new Zmanim(gloc, hdate);
        const zemanim = [
            { name: 'ס"ז ק"ש מ"א', value: zmn.sofZmanShmaMGA().toTimeString() },
            { name: 'חצות היום', value: zmn.chatzot().toTimeString() },
            { name: 'שקיעת החמה', value: zmn.shkiah().toTimeString() },
            { name: 'צאת הכוכבים', value: zmn.sunsetOffset(72).toTimeString() },
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

export const getData = (timestamp: number, gloc: GeoLocation) => {
    const date = new Date(timestamp);
    const hdate = new HDate(date);
    const daf = new DafYomi(hdate);

    let zemanim = getZemanim(hdate, gloc);

    return {
        date: date.toDateString(),
        hdate: hdate.renderGematriya(true),
        // TODO day of week
        dafYomi: daf.render('he'),
        zemanim,
    };
};
