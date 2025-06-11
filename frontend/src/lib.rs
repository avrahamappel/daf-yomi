use leptos::*;
use leptos_meta::*;
use leptos_router::*;
use wasm_bindgen::prelude::*;

#[wasm_bindgen(start)]
fn main() {
    console_error_panic_hook::set_once();
    leptos::mount_to_body(|| view! { <App/> });
}

#[component]
pub fn App() -> impl IntoView {
    view! {
        <Stylesheet id="leptos" href="/main.css"/>
        //<Router>
            <main>
                <h1>"Leptos Scaffold"</h1>

            </main>
        //</Router>
    }
}
