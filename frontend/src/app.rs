use leptos::*;
use leptos_router::*;
use serde::{Deserialize, Serialize};

// --- Model Types ---

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub enum Page {
    Main,
    Settings,
}

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub enum State {
    LoadingData,
    Error(String),
    HasPosition(Position),
    HasData(Data, Position),
}

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub struct Model {
    pub cur_time: i64,
    pub cur_shiur_index: usize,
    pub cur_zeman_index: usize,
    pub disp_time: i64,
    pub timezone: String, // You may want a chrono::FixedOffset or similar
    pub page: Page,
    pub state: State,
    pub settings: Settings,
}

// TODO: Replace with actual structs you define later
#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub struct Position;

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub struct Data {
    pub date: String,
    pub hdate: String,
    pub zemanim_state: ZemanimState,
    pub shiurim: Vec<Shiur>,
    pub parsha: String,
}

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub enum ZemanimState {
    GeoError(String),
    HasZemanim(Zemanim),
}

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub struct Zemanim {
    pub zemanim: Vec<Zeman>,
    pub latitude: String,
    pub longitude: String,
    pub location_name: Option<String>,
}

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub struct Zeman {
    pub name: String,
    pub value: i64, // POSIX millis
}

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub struct Shiur {
    pub name: String,
    pub value: String,
}

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub struct Settings;

// --- Messages ---

#[derive(Clone, Debug)]
pub enum Msg {
    None,
    AdjustTime,         // (Zone, Posix)
    SetLocation,        // Json value
    SetData,            // Json value
    ChangeDate,         // SwitcherMsg
    ChangeZeman,        // SwitcherMsg
    ChangeShiur,        // SwitcherMsg
    ReceiveError(String),
    OpenSettings,
    CloseSettings,
    UpdateSettings,     // Settings.Msg
    SaveSettings,
    UpdateTime,         // i64
}

// --- Leptos App ---
#[component]
pub fn MainView(model: RwSignal<Model>) -> impl IntoView {
    let set_page = {
        move |page: Page| {
            model.update(|m| m.page = page);
        }
    };

    let main_view = move || {
        let model = model.get(); // Snapshot for now; later use reactivity.
        match &model.state {
            State::LoadingData => {
                view! { <>"Fetching position..."</> }
            }
            State::Error(e) => {
                view! {
                    <>
                        <span style="color:red;">{e}</span>
                    </>
                }
            }
            State::HasPosition(_) => {
                view! { <>"Loading data..."</> }
            }
            State::HasData(data, _pos) => {
                // Render zemanim line, shiurim line, and location
                let (zemanim_line1, zemanim_line2, location) = match &data.zemanim_state {
                    ZemanimState::HasZemanim(zmnm) => {
                        let location_string = zmnm
                            .location_name
                            .clone()
                            .unwrap_or_else(|| format!("{}, {}", zmnm.latitude, zmnm.longitude));
                        if let Some(zm) = zmnm.zemanim.get(model.cur_zeman_index) {
                            (
                                zm.name.clone(),
                                posix_to_time_string(&model.timezone, zm.value),
                                location_string,
                            )
                        } else {
                            (
                                "Error".to_string(),
                                format!("No entry for index {}", model.cur_zeman_index),
                                location_string,
                            )
                        }
                    }
                    ZemanimState::GeoError(e) => ("Error".to_string(), e.clone(), "".to_string()),
                };

                let (shiurim_line1, shiurim_line2) =
                    if let Some(shiur) = data.shiurim.get(model.cur_shiur_index) {
                        (shiur.name.clone(), shiur.value.clone())
                    } else {
                        (
                            "Error".to_string(),
                            format!("No entry for index {}", model.cur_shiur_index),
                        )
                    };

                let week_and_day = week_and_day(&model.timezone, model.disp_time, &data.parsha);

                view! {
                    <>
                        // Replace these with your switcher components as you port them
                        <div>{data.hdate.clone()} {week_and_day.clone()}</div>
                        <div class="sub-text">{data.date.clone()}</div>
                        <div>{shiurim_line1} {shiurim_line2}</div>
                        <br />
                        <div>{zemanim_line1} {zemanim_line2}</div>
                        <div class="sub-text">{location}</div>
                    </>
                }
            }
        }
    };

    move || {
        let model = model.get();
        match model.page {
            Page::Main => view! {
                <>
                    {main_view} <br /> <br /> <br />
                    <button class="ctl-button" on:click=move |_| set_page(Page::Settings)>
                        "Settings"
                    </button>
                </>
            },
            Page::Settings => {
                view! {
                    <>
                        <span>"Settings page placeholder"</span>
                        <br />
                        <button class="ctl-button" on:click=move |_| set_page(Page::Main)>
                            "Close Settings"
                        </button>
                    </>
                }
            }
        }
    }
}

fn posix_to_time_string(_timezone: &str, millis: i64) -> String {
    // TODO: Port actual timezone logic, this is a placeholder
    use chrono::{DateTime, Timelike};
    let secs = millis / 1000;
    let dt = DateTime::from_timestamp(secs, 0).unwrap_or_default();
    format!("{:02}:{:02}", dt.hour(), dt.minute())
}

fn week_and_day(_zone: &str, _time: i64, parsha: &str) -> String {
    // TODO: Port weekday logic, this is a placeholder
    format!("יום א׳ {}", parsha)
}

#[component]
pub fn App() -> impl IntoView {
    // Placeholder state for now; you will replace this with signals and logic as you migrate more logic
    let model = create_rw_signal(Model {
        cur_time: 0,
        cur_shiur_index: 0,
        cur_zeman_index: 0,
        disp_time: 0,
        timezone: "UTC".to_string(),
        page: Page::Main,
        state: State::LoadingData,
        settings: Settings, // Replace with decode logic as needed
    });

    view! {
        <Router>
            <main>
                <h1>"Leptos Scaffold"</h1>
                <MainView model=model />
            </main>
        </Router>
    }
}
