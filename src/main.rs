use iced::Task;

mod data;
mod location;
mod settings;

use crate::{
    data::{Data, Time},
    location::Position,
    settings::Settings,
};

struct Model {
    cur_time: Time,
    cur_shiur_index: usize,
    cur_zeman_index: usize,
    disp_time: Time,
    page: Page,
    state: State,
    settings: Settings,
}

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

fn init() -> (Model, Task) {
    let settings = todo!();
    let model = Model {
        cur_time: 0,
        cur_shiur_index: 0,
        cur_zeman_index: 0,
        disp_time: 0,
        page: Page::Main,
        state: State::LoadingData,
        settings: Settings::from(settings),
    };
    (model, get_current_time)
}

// TODO: how to do this with iced?
fn get_current_time() -> Task {
    todo!()
}

enum Msg {
    None,
    AdjustTime(Time),
    SetLocation(Result<Position, String>),
    SetData(Result<Data, String>),
    ChangeDate(switcher::Msg),
    ChangeZeman(switcher::Msg),
    ChangeShiur(switcher::Msg),
    ReceiveError(String),
    OpenSettings,
    CloseSettings,
    UpdateSettings(settings::Msg),
    SaveSettings,
    UpdateTime(Time),
}

fn update(msg: Msg, model: Model) -> (Model, Task) {
    use Msg::*;

    match msg {
        None => (mode, Task::None),
        AdjustTime(time) => {
            fn is_viewing_current_zeman() {
                todo!();
            }

            let new_time = time;
            let disp_time = if model.disp_time == 0 {
                new_time
            } else if is_viewing_current_zeman() {
                new_time
            } else {
                model.disp_time
            };

            let task = todo!();

            *model = Model {
                disp_time,
                cur_time,
                cur_zeman_index,
                ..model
            };

            (model, task)
        },
        SetLocation(position) => match position {
            Err(e) => {
                *model.state = State::Error(e);
                (model, Task::None)
            },
            Ok(pos) => {
                *model.state = State::HasPosition(pos);
                let task = get_data(GetDataArgs {
                    timestamp: model.disp_time,
                    position: pos,
                    settings: model.settings,
                });
                (mode, task)
            },
        },
        SetData(data) => {
            fn is_same_date(time1: Time, time2: Time) -> bool {
                todo!();
            }
            let state = match model.state {
                State::HasPosition(pos) => match data {
                    Ok(d) => State::HasData(d, pos),
                    Err(e) => State::Error(e),
                },
                _ => model.state,
            };
            let is_displaying_current_date = is_same_date(model.cur_time, model.disp_time);

            *model.state = state;
            *model.cur_zeman_index = if is_displaying_current_date {
                upcomingZemanIndex(state, model.cur_time)
            } else {
                model.cur_zeman_index
            };

            (model, Task::None)
        },
        ChangeDate(msg) => {
            use switcher::Msg::*;
            // Get the same index of previous / next date (if exists), and
            // get the Time of that index for the previous day
            // (necessitates eagerly fetching data, which we should be able
            // to do anyway)
            let new_time = todo!();

            *model.disp_time = new_time;

            (mode, Task::None)
        },
        ChangeZeman(msg) => {
            use switcher::Msg::*;
            // Get the next/previous index and then get the Time corresponding
            // to that index, which will now become the new disp_time
            // If the index is 0, go to the prev day
            // If the index is len() - 1, go to the next day
            let new_zeman_index = todo!();
            let new_disp_time = todo!();

            *model.cur_zeman_index = new_zeman_index;
            *model.disp_time = new_disp_time;

            (mode, Task.none)
        },
        ChangeShiur(msg) => todo!(), // Are we hving shiurim in this version?
        ReceiveError(error) => {
            *model.state = State::Error(error);
            (model, Task.none)
        },
        OpenSettings => {
            *model.page = Page::Settings;
            (model, Task.none)
        },
        CloseSettings => {
            *model.page = Page::Main;
            (model, Task.none)
        },
        UpdateSettings(msg) => {
            *model.settings = settings::update(msg, model.settings);
            (model, Task.none)
        },
        SaveSettings => {
            let settings_json = settings::encode(model.settings);
            let task = Task.batch([
                location::get_location(settings_json),
                store_settings(settings_json),
            ]);
            *model.page = Page::Main;
            (model, task)
        },
        UpdateTime(_) => (model, get_current_time()),
    }
}

/// Figure out what the next upcoming zeman for the current time is
fn upcoming_zeman_index(state: State, cur_time: Time) -> usize {
    todo!() // FIgure out what this is
}

// TODO: subscriptions?

fn main() -> iced::Result {
    iced::application(init, update, view).run()
}
