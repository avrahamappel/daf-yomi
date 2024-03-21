import './style.css'
import { Elm } from './src/Main.elm'
import { getData, getLocation } from './data'
import { Observable, combineLatest } from 'rxjs';

const app = Elm.Main.init({ node: document.getElementById('app') });

const position$ = getLocation();
const getDataPort$ = new Observable((ob) => {
    app.ports.getData.subscribe(timestamp => {
        ob.next(timestamp);
    });
});

// Update when either app fires or location changes
combineLatest([getDataPort$, position$])
    .subscribe(([timestamp, pos]) => {
        const data = getData(timestamp, pos);
        app.ports.returnData.send(data);
    })
