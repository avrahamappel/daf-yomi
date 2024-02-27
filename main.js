import { HDate, Zmanim, GeoLocation } from '@hebcal/core'
import { DafYomi } from '@hebcal/learning'
import './style.css'
import { Elm } from './src/Main.elm'

let gloc;
let gerror = '';

if ('geolocation' in location) {
    location.geolocation.getCurrentPosition(
        position => {
            gloc = new GeoLocation(
                null,
                position.coords.latitude,
                position.coords.longitude
            );
        },
        error => {
            gerror = error;
        }
    );
}

// TODO generate a calendar and use for getting parsha, yom tov etc.

const getData = (date) => {
    const hdate = new HDate(date);
    const daf = new DafYomi(hdate);

    let zemanim = [];

    if (gloc) {
        const zmn = new Zmanim(gloc, hdate);
        zemanim = [
            { label: 'ס"ז ק"ש מ"א', value: zmn.sofZmanShmaMGA().toTimeString() },
            { label: 'חצות היום', value: zmn.chatzot().toTimeString() },
            { label: 'שקיעת החמה', value: zmn.shkiah().toTimeString() },
            { label: 'צאת הכוכבים', value: zmn.sunsetOffset(72).toTimeString() },
        ];
    }

    return {
        hdate: hdate.renderGematriya(true),
        // TODO day of week
        dafYomi: daf.render('he'),
        zemanim,
        zemanimError: gerror,
    };
};

const app = Elm.Main.init({ node: document.getElementById('app') });

app.ports.getData.subscribe(timestamp => {
    const date = new Date(timestamp ?? 0);
    app.ports.returnData.send(getData(date));
});
