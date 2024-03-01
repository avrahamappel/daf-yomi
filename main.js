import { HDate, Zmanim, GeoLocation } from '@hebcal/core'
import { DafYomi } from '@hebcal/learning'
import './style.css'
import { Elm } from './src/Main.elm'

const geoLocation = async () => {
    if (!'geolocation' in navigator) {
        throw 'GPS not supported';
    }

    return new Promise((res, rej) => {
        navigator.geolocation.getCurrentPosition(
            position => res(new GeoLocation(
                null,
                position.coords.latitude,
                position.coords.longitude,
                position.coords.altitude || 0
            )),
            error => rej(error.message)
        );
    })
};

// TODO generate a calendar and use for getting parsha, yom tov etc.

const getData = async (date) => {
    const hdate = new HDate(date);
    const daf = new DafYomi(hdate);

    let { zemanim, zemanimError } = await geoLocation().then((gloc) => {
        debugger
        const zmn = new Zmanim(gloc, hdate);
        zemanim = [
            { label: 'ס"ז ק"ש מ"א', value: zmn.sofZmanShmaMGA().toTimeString() },
            { label: 'חצות היום', value: zmn.chatzot().toTimeString() },
            { label: 'שקיעת החמה', value: zmn.shkiah().toTimeString() },
            { label: 'צאת הכוכבים', value: zmn.sunsetOffset(72).toTimeString() },
        ];

        return { zemanim, zemanimError: '' };
    }).catch(error => ({ zemanimError: error, zemanim: [] }));

    return {
        hdate: hdate.renderGematriya(true),
        // TODO day of week
        dafYomi: daf.render('he'),
        zemanim,
        zemanimError,
    };
};

const app = Elm.Main.init({ node: document.getElementById('app') });

app.ports.getData.subscribe(async timestamp => {
    const date = new Date(timestamp ?? 0);
    const data = await getData(date);
    app.ports.returnData.send(data);
});
