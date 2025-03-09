use crate::location::Location;

enum LocationMethod {
    Ip,
    Gps,
    Manual
}

pub struct Settings {
    location_method: LocationMethod,
    location: Option<Location>,
    candle_lighting_minutes: u16,
    show_plag: bool,
}
