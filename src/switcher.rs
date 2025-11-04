use leptos::prelude::*;

enum SwitchEvent {
    Right,
    Left,
    Middle,
}

/// An HTML group consisting of a middle field with a right and left pointing
/// arrow to increment and decrement the value
#[component]
pub fn Switcher(line1: String, line2: String, on_switch: fn(SwitchEvent)) -> impl IntoView {
    view! {
        <div class="switcher-group">
            <button
                class="switcher-left"
                on:click=move |_| on_switch(SwitchEvent::Left)>
                "<"
            </button>
            <button
                class="switcher-middle"
                on:click=move |_| on_switch(SwitchEvent::Middle)>
                "{line1}"
                <br />
                "{line2}"
            </button>
            <button
                class="switcher-right"
                on:click=move |_| on_switch(SwitchEvent::Right)>
                ">"
            </button>
        </div>
    }
}
