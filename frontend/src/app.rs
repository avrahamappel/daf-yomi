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
pub struct Data;

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
    let model = model.get(); // Snapshot for now; later use reactivity.

    let main_view = match &model.state {
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
        State::HasData(_data, _pos) => {
            view! { <>{} <span>"Zemanim/Shiurim/Location view placeholder"</span></> }
        }
    };

    match model.page {
        Page::Main => view! {
            <>
                {main_view} <br /> <br /> <br /> <button class="ctl-button" on:click=move |_| {}>
                    "Settings"
                </button>
            </>
        },
        Page::Settings => view! { <>{} <span>"Settings page placeholder"</span></> },
    }
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
