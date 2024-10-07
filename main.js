import './style.css'
import { Elm } from './src/Main.elm'
import { getData } from './src/data'
import { getLocation } from './src/location'
import { getSettings, updateSettings } from './src/settings';

const initialSettings = getSettings();
const app = Elm.Main.init({
    node: document.getElementById('app'),
    flags: initialSettings,
});

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
app.ports.getLocation.subscribe(sendLocationToElm);
app.ports.storeSettings.subscribe(updateSettings)

sendLocationToElm(initialSettings);
