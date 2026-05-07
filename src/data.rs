use hdate::Hdate;
use jiff::Zoned;

use crate::location::{Latitude, Longitude};

pub type Time = Zoned;

struct Zeman {
    name: String,
    value: Time,
}

struct Zemanim {
    zemanim: Vec<Zeman>,
    latitude: Latitude,
    longitude: Longitude,
    location_name: Option<String>,
}

enum ZemanimState {
    GeoError(String),
    HasZemanim(Zemanim),
}

pub struct Data {
    date: Time,
    hdate: Hdate,
    zemanim_state: ZemanimState,
    // shiurim
    parsha: String,
}
