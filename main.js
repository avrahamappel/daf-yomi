import './style.css'
import { Elm } from './src/Main.elm'
import { getData, getLocation } from './data'
import { Observable, combineLatest } from 'rxjs';

const app = Elm.Main.init({ node: document.getElementById('app') });

const geoLocation$ = getLocation();
const getDataPort$ = new Observable((ob) => {
    app.ports.getData.subscribe(timestamp => {
        ob.next(timestamp);
    });
});

// Update when either app fires or location changes
combineLatest([getDataPort$, geoLocation$])
    .subscribe(([timestamp, gloc]) => {
        const data = getData(timestamp, gloc);
        app.ports.returnData.send(data);
    })
