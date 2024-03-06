import { HDate, Zmanim, GeoLocation } from '@hebcal/core'
import { DafYomi } from '@hebcal/learning'

const getLocation = async (): Promise<GeoLocation> => {
    if (!('geolocation' in navigator)) {
        throw new Error('GPS not supported');
    }

    return new Promise((res, rej) => {
        navigator.geolocation.getCurrentPosition(
            position => res(geoLocation(
                position.coords.latitude,
                position.coords.longitude,
                position.coords.altitude || 0
            )),
            error => rej(error)
        );
    })
};

const geoLocation = (latitude: number, longitude: number, altitude?: number) =>
    new GeoLocation(
        null,
        latitude,
        longitude,
        altitude || 0,
        Intl.DateTimeFormat().resolvedOptions().timeZone
    );

// TODO generate a calendar and use for getting parsha, yom tov etc.

const getZemanim = async (hdate: HDate) => {
    try {
        const gloc = await getLocation();
        const zmn = new Zmanim(gloc, hdate);
        const zemanim = [
            { name: 'ס"ז ק"ש מ"א', value: zmn.sofZmanShmaMGA().toTimeString() },
            { name: 'חצות היום', value: zmn.chatzot().toTimeString() },
            { name: 'שקיעת החמה', value: zmn.shkiah().toTimeString() },
            { name: 'צאת הכוכבים', value: zmn.sunsetOffset(72).toTimeString() },
        ];

        return {
            zemanim,
            zemanimError: null,
            latitude: gloc.getLatitude().toFixed(2),
            longitude: gloc.getLongitude().toFixed(2)
        };
    } catch (error) {
        return {
            zemanimError: error.message ?? error,
            zemanim: []
        };
    }
};

export const getData = async (timestamp?: number) => {
    const date = new Date(timestamp ?? 0);
    const hdate = new HDate(date);
    const daf = new DafYomi(hdate);

    let { zemanim, zemanimError, latitude, longitude } = await getZemanim(hdate);

    return {
        date: date.toDateString(),
        hdate: hdate.renderGematriya(true),
        // TODO day of week
        dafYomi: daf.render('he'),
        zemanim,
        zemanimError,
        latitude,
        longitude
    };
};
