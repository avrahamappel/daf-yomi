use wasm_bindgen::prelude::*;

mod custom_events;

#[wasm_bindgen(module = "@capacitor/core")]
extern "C" {
    type Capacitor;
}
