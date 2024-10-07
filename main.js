import './style.css'
import { Elm } from './src/Main.elm'
import { getData } from './src/data'
import { getLocation } from './src/location'
import { getSettings, updateSettings } from './src/settings';

const app = Elm.Main.init({ node: document.getElementById('app') });

const sendLocationToElm = (settings) => getLocation(
    settings,
    (pos) => app.ports.setLocation.send(pos),
    (error) => app.ports.receiveError.send(error)
);

app.ports.getData.subscribe(({ settings, timestamp, position }) => {
    const data = getData(settings, timestamp, position);
    app.ports.returnData.send(data);
})

// If location method changes, app will re-request location
app.ports.getLocation.subscribe(settings => sendLocationToElm(settings));
app.ports.storeSettings.subscribe(updateSettings)

const initialSettings = getSettings();
sendLocationToElm(initialSettings);
