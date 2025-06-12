use leptos::*;
use wasm_bindgen::prelude::*;

mod app;
use app::App;

#[wasm_bindgen(start)]
fn run() {
    console_error_panic_hook::set_once();
    leptos::mount_to_body(|| view! { <App/> });
}
