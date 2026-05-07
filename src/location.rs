pub type Longitude = f64;
pub type Latitude = f64;

pub struct Position {
    name: Option<String>,
    longitude: Longitude,
    latitude: Latitude,
}
