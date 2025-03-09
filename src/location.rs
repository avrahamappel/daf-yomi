pub struct Location {
    longitude: f64,
    latitude:f64,
}

pub struct Position {
    name: Option<String>,
    location: Location,
    altitude:Option<f64>,
}
