enum LocationMethod {
    IP,
    GPS,
    Manual,
}

struct Settings {
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
