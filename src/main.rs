use dioxus::prelude::*;

mod location;
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
        div {
            class: "switcher-group",
            button {
                class: "switcher-left",
                onclick: move |_| on_switch(SwitchEvent::Left),
                "<"
            }
            button {
                class: "switcher-middle",
                onclick: move |_| on_switch(SwitchEvent::Middle),
                "{line1}",
                br {},
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

#[component]
fn App() -> Element {
    rsx! {
        Switcher {
            line1: "Line 1",
            line2: "Line 2",
            on_switch: move |event| match event {
                SwitchEvent::Left => println!("Left"),
                SwitchEvent::Middle => println!("Middle"),
                SwitchEvent::Right => println!("Right"),
            },
        }
    }
}

fn main() {
    dioxus::launch(App);
}
