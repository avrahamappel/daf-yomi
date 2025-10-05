mod location;
mod settings;

enum SwitchEvent {
    Right, Left, Middle }

    /// An HTML group consisting of a middle field with a right and left pointing
    /// arrow to increment and decrement the value
#[component]
fn Switcher(line1:String,line2:String, onSwitch: fn(SwitchEvent)) -> Element {
rsx! { div { class: "switcher-group",
        button { class: "switcher-left", onclick: move |_| onSwitch(SwitchEvent::Left), "<" },
        button { class: "switcher-middle", onclick: move |_| onSwitch(SwitchEvent::Middle), line1, br {}, line2 },
        button { class: "switcher-right", onclick: move |_| onSwitch(SwitchEvent::Right), ">" }
    }
}
