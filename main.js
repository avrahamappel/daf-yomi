import { HDate } from '@hebcal/core'
import { DafYomi, NachYomiEvent, NachYomiIndex } from '@hebcal/learning'
import './style.css'
import { Elm } from './src/Main.elm'

const getData = (date) => {
    const hdate = new HDate(date);
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

    return {
        date: date.toDateString(),
        hdate: hdate.renderGematriya(true),
        shiurim: [
            ...dafShiurim,
            nachYomiShiur,
        ]
    };
};

const app = Elm.Main.init({ node: document.getElementById('app') });

app.ports.getData.subscribe(timestamp => {
    const date = new Date(timestamp ?? 0);
    app.ports.returnData.send(getData(date));
});
