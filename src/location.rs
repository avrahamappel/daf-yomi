struct Position {
    name: Option<String>,
    longitude: f64,
    latitude: f64,
    altitude: Option<f64>,
}

pub fn get_location(settings: Settings, next: fn(Position) -> (), error: fn(String) -> ()) {
    todo!()
}
