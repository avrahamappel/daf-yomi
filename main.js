import { HDate } from '@hebcal/core'
import { DafYomi } from '@hebcal/learning'
import './style.css'
import { Elm } from './src/Main.elm'

const app = Elm.Main.init({ node: document.getElementById('app') });

app.ports.getDafAndDate.subscribe(timestamp => {
    const date = new Date(timestamp);
    const hdate = new HDate(date);
    const daf = new DafYomi(hdate);

    app.ports.returnDafAndDate.send({
        date: date.toDateString(),
        hdate: hdate.toString(),
        dafYomi: daf.render(),
    });
});
