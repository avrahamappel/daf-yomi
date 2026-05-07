use crate::location::{Latitude, Longitude};

enum LocationMethod {
    Ip,
    Gps,
    Manual,
}

pub struct Settings {
    location_method: LocationMethod,
    longitude: Option<Longitude>,
    latitude: Option<Latitude>,
    candle_lighting_minutes: u32,
    show_plag: bool,
}
