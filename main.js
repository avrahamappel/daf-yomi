import './style.css'
import { Elm } from './src/Main.elm'
import { getData, getLocation } from './data'
import { Observable, combineLatest } from 'rxjs';

const app = Elm.Main.init({ node: document.getElementById('app') });

const position$ = getLocation();
const getDataPort$ = new Observable((ob) => {
    // TODO this is now an object
    app.ports.getData.subscribe(args => {
        ob.next(args);
    });
});

// Update when either app fires or location changes
combineLatest([getDataPort$, position$])
    .subscribe(([dataArgs, pos]) => {
        const data = getData(dataArgs, pos);
        app.ports.returnData.send(data);
    })
