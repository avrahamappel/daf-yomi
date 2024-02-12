import { HDate } from '@hebcal/core'
import { DafYomi } from '@hebcal/learning'
import './style.css'
import { Elm } from './src/Main.elm'

const getData = (date) => {
    const hdate = new HDate(date);
    const daf = new DafYomi(hdate);

    return {
        timestamp: date.getTime(),
        date: date.toDateString(),
        hdate: hdate.render('he'),
        dafYomi: daf.render('he'),
    };
};

const app = Elm.Main.init({ node: document.getElementById('app') });

app.ports.getData.subscribe(timestamp => {
    const date = new Date(timestamp ?? 0);
    app.ports.returnData.send(getData(date));
});
