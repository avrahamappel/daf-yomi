import './style.css'
import { Elm } from './src/Main.elm'
import { getData } from './data'

const app = Elm.Main.init({ node: document.getElementById('app') });

app.ports.getData.subscribe(async timestamp => {
    const data = await getData(timestamp);
    app.ports.returnData.send(data);
});
