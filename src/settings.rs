use dioxus::prelude::*;

#[derive(Clone, PartialEq)]
enum LocationMethod {
    IP,
    GPS,
    Manual,
}

#[derive(Clone, PartialEq)]
pub struct Settings {
    location_method: LocationMethod,
    longitude: Option<f64>,
    latitude: Option<f64>,
    elevation: Option<f64>,
    candle_lighting_minutes: i32,
    show_plag: bool,
}

pub fn get_settings() -> Settings {
    todo!()
}

pub fn update_settings(settings: Settings) {
    todo!()
}

#[component]
fn SettingsView(settings: Settings) -> Element {
    rsx! {
        div { style: "text-align: left",
            h1 { "Settings" }
            div {
                "Location Method: "
                div {
                    label {
                        input {
                            r#type: "radio",
                            checked: settings.location_method == LocationMethod::IP,
                        }
                    }
                }
            }
        }
    }
}
