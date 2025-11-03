use dioxus::prelude::*;

enum SwitchEvent {
    Right,
    Left,
    Middle,
}

/// An HTML group consisting of a middle field with a right and left pointing
/// arrow to increment and decrement the value
#[component]
pub fn Switcher(line1: String, line2: String, on_switch: fn(SwitchEvent)) -> Element {
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
