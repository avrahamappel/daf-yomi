import './style.css'
import { Elm } from './src/Main.elm'
import { getData } from './src/data'
import { getLocation } from './src/location'
import { getSettings } from './src/settings';

const app = Elm.Main.init({ node: document.getElementById('app') });
const initialSettings = getSettings();

getLocation(initialSettings, (pos) => app.ports.setLocation.send(pos));

app.ports.getData.subscribe(({ settings, timestamp, position }) => {
    const data = getData(settings, timestamp, position);
    app.ports.returnData.send(data);
})
