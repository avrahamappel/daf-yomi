import './style.css'
import { Elm } from './src/Main.elm'
import { getData } from './src/data'
import { getLocation } from './src/location'

const app = Elm.Main.init({ node: document.getElementById('app') });

getLocation((pos) => app.ports.setLocation.send(pos));

app.ports.getData.subscribe(({ timestamp, position }) => {
    const data = getData(timestamp, position);
    app.ports.returnData.send(data);
})
