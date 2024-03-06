import { HDate, Zmanim, GeoLocation } from '@hebcal/core'
import { DafYomi } from '@hebcal/learning'
import './style.css'
import { Elm } from './src/Main.elm'

const geoLocation = async () => {
    if (!'geolocation' in navigator) {
        throw new Error('GPS not supported');
    }

    return new Promise((res, rej) => {
        navigator.geolocation.getCurrentPosition(
            position => res(new GeoLocation(
                null,
                position.coords.latitude,
                position.coords.longitude,
                position.coords.altitude || 0,
                Intl.DateTimeFormat().resolvedOptions().timeZone
            )),
            error => rej(error.message)
        );
    })
};

// TODO generate a calendar and use for getting parsha, yom tov etc.

const getData = async (date) => {
    const hdate = new HDate(date);
    const daf = new DafYomi(hdate);

    let { zemanim, zemanimError, latitude, longitude } = await geoLocation().then((gloc) => {
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
    }).catch(error => ({ zemanimError: error, zemanim: [] }));

    return {
        date: date.toDateString(),
        hdate: hdate.renderGematriya(true),
        // TODO day of week
        dafYomi: daf.render('he'),
        // TODO maybe combine into single key
        zemanim,
        zemanimError,
        latitude,
        longitude
    };
};

const app = Elm.Main.init({ node: document.getElementById('app') });

app.ports.getData.subscribe(async timestamp => {
    const date = new Date(timestamp ?? 0);
    const data = await getData(date);
    app.ports.returnData.send(data);
});
