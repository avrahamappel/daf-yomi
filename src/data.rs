use jiff::civil::DateTime;

use crate::location::Location;

struct Zeman {
    name: String,
    value: DateTime,
}

struct Zemanim {
    zemanim: Vec<Zeman>,
    location: Location,
    locationName: Option<String>,
}

enum ZemanimState {
    GeoError(String),
    HasZemanim(Zemanim),
}

pub struct Shiur {
    name: String,
    value: String,
}

type Shiurim = Vec<Shiur>;

pub struct Data {
    date: String,
    hdate: String,
    zemanim_state: ZemanimState,
    shiurim: Shiurim,
    parsha: String,
}
