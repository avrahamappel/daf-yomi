import { HDate } from '@hebcal/core'
import { DafYomi } from '@hebcal/learning'
import './style.css'
import { Elm } from './src/Main.elm'

const getDafAndDate = (timestamp) => {
    const date = new Date(timestamp);
    const hdate = new HDate(date);
    const daf = new DafYomi(hdate);

    return {
        timestamp,
        date: date.toDateString(),
        hdate: hdate.toString(),
        dafYomi: daf.render(),
    };
};

const app = Elm.Main.init({ node: document.getElementById('app') });

app.ports.getDafAndDate.subscribe(timestamp => {
    app.ports.returnDafAndDate.send(getDafAndDate(timestamp));
});
