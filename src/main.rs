use dioxus::prelude::*;

mod data;
use data::Data;
mod location;
use location::{use_location, Position};
mod settings;

enum SwitchEvent {
    Right,
    Left,
    Middle,
}

/// An HTML group consisting of a middle field with a right and left pointing
/// arrow to increment and decrement the value
#[component]
fn Switcher(line1: String, line2: String, on_switch: fn(SwitchEvent)) -> Element {
    rsx! {
        div { class: "switcher-group",
            button {
                class: "switcher-left",
                onclick: move |_| on_switch(SwitchEvent::Left),
                "<"
            }
            button {
                class: "switcher-middle",
                onclick: move |_| on_switch(SwitchEvent::Middle),
                "{line1}"
                br {}
                "{line2}"
            }
            button {
                class: "switcher-right",
                onclick: move |_| on_switch(SwitchEvent::Right),
                ">"
            }
        }
    }
}

enum State {
    LoadingData,
    Error(String),
    HasPosition(Position),
    HasData(Data, Position),
}

struct Model {
    state: State,
}

static CSS: Asset = asset!("/style.css");
static LOGO: Asset = asset!("/public/logo.svg");

#[component]
fn Main() -> Element {
    let model = use_signal(|| {
        let location = use_location();

        let state = match location {
            Ok(None) => State::LoadingData,
            Ok(Some(position)) => State::HasPosition(position),
            Err(e) => State::Error(e),
        };

        Model { state }
    });

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
