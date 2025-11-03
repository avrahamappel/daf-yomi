use dioxus::prelude::*;

mod data;
mod location;
mod settings;
mod switcher;

use crate::{
    data::Data,
    location::{get_location, Position},
    settings::{update_settings, use_settings},
    switcher::Switcher,
};

enum Page {
    Main,
    Settings,
}

enum State {
    LoadingData,
    Error(String),
    HasPosition(Position),
    HasData(Data, Position),
}

struct Model {
    page: Page,
    state: State,
}

static CSS: Asset = asset!("/style.css");
static LOGO: Asset = asset!("/public/logo.svg");

#[component]
fn MainView(model: Model) -> Element {
    match &model.read().state {
        State::LoadingData => rsx! { "Fetching position..." },
        State::Error(e) => rsx! {
            span { style: "color: red", "{e}" }
        },
        State::HasPosition(_) => rsx! { "Loading data..." },
        State::HasData(_, _) => todo!(),
    }
}

#[component]
fn Main() -> Element {
    let model = use_signal(|| {
        let settings = use_settings();
        let location = get_location(settings);

        let state = match location {
            Ok(None) => State::LoadingData,
            Ok(Some(position)) => State::HasPosition(position),
            Err(e) => State::Error(e),
        };

        Model {
            state,
            page: Page::Main,
        }
    });

    let open_settings = move |_| model.page = Page::Settings;
    let close_settings = move |_| model.page = Page::Main;
    let save_settings = move |_| {
        let location = get_location(model.settings);
        update_settings(model.settings);
        model.page = Page::Main;
    };

    match &model.read().page {
        Page::Main => {
            rsx! {
                MainView { model }
                br {}
                br {}
                br {}
                button { class: "ctl-button", onclick: open_settings, "Settings" }
            }
        },
        Page::Settings => {
            rsx! {
                SettingsView { settings: model.settings }
                br {}
                button { class: "ctl-button", onclick: save_settings, "Save" }
                button { class: "ctl-button", onclick: close_settings, "Close" }
            }
        },
    }
}

#[component]
fn App() -> Element {
    rsx! {
        document::Title { "Daf Yomi and local Zemanim" }
        document::Link { rel: "icon", href: LOGO, r#type: "image/svg+xml" }
        document::Stylesheet { href: CSS }

        div { id: "app", Main {} }
    }
}

fn main() {
    dioxus::launch(App);
}
