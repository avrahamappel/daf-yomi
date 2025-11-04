use leptos::prelude::*;

//mod data;
//mod location;
//mod settings;
//mod switcher;

//use crate::{
//data::Data,
//location::{get_location, Position},
//settings::{update_settings, use_settings, Settings},
//switcher::Switcher,
//};

#[derive(Clone, Copy)]
enum Page {
    Main,
    //Settings,
}

enum State {
    LoadingData,
    //Error(String),
    //HasPosition(Position),
    //HasData(Data, Position),
}

//struct Model {
//    page: Page,
//    state: State,
//    //settings: Settings,
//}

//static CSS: Asset = asset!("/style.css");
//static LOGO: Asset = asset!("/public/logo.svg");

#[component]
fn MainView(#[prop(into)] state: Signal<State>) -> impl IntoView {
    match *state.read() {
        State::LoadingData => view! { "Fetching position..." }.into_any(),
        //State::Error(e) => view! {
        //    <span style="color:red">e</span>
        //}
        //.into_any(),
        //State::HasPosition(_) => view! { "Loading data..." },
        //State::HasData(_, _) => todo!(),
    }
}

#[component]
fn Main() -> impl IntoView {
    //let settings = use_settings();
    //let location = get_location(settings);
    //
    //let state = match location {
    //    Ok(None) => State::LoadingData,
    //    Ok(Some(position)) => State::HasPosition(position),
    //    Err(e) => State::Error(e),
    //};

    //Model {
    //    state: State::LoadingData,
    //    page: Page::Main,
    //}

    let (page, set_page) = signal(Page::Main);
    let (state, set_state) = signal(State::LoadingData);

    //let open_settings = move |_| set_model.write().page = Page::Settings;
    //let close_settings = move |_| set_model.write().page = Page::Main;
    //let save_settings = move |_| {
    //    let location = get_location(model.read().settings);
    //    update_settings(model.read().settings);
    //    set_model.write().page = Page::Main;
    //};

    match page.get() {
        Page::Main => {
            view! {
                <MainView state />
                <br />
                <br />
                <br />
                //<button class="ctl-button" on:click=open_settings>
                //    Settings
                //</button>
            }
        },
        //Page::Settings => {
        //    view! {
        //        <SettingsView settings=model.read().settings />
        //        <br />
        //        <button class="ctl-button" on:click=save_settings>
        //            Save
        //        </button>
        //        <button class="ctl-button" on:click=close_settings>
        //            Close
        //        </button>
        //    }
        //},
    }
}

#[component]
fn App() -> impl IntoView {
    view! {
    //        document::Title { "Daf Yomi and local Zemanim" }
    //        document::Link { rel: "icon", href: LOGO, r#type: "image/svg+xml" }
    //        document::Stylesheet { href: CSS }

            <div id="app">
              <Main />
            </div>
        }
}

fn main() {
    console_error_panic_hook::set_once();

    leptos::mount::mount_to_body(Main);
}
