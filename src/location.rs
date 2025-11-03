use dioxus::{hooks::use_resource, signals::Signal};
use dioxus_geolocation::{init_geolocator, use_geolocation, PowerMode};
use gloo_storage::{LocalStorage, Storage};
use serde::{Deserialize, Serialize};

use crate::settings::{use_settings, LocationMethod, Settings};

#[derive(Default, Serialize, Deserialize)]
pub struct Position {
    name: Option<String>,
    longitude: f64,
    latitude: f64,
    altitude: Option<f64>,
}

const STORAGE_KEY: &str = "app.location";

enum PositionError {}

struct UseLocation {
    inner: Signal<Result<Position, PositionError>>,
}

struct IpApiResponse {
    city: String,
    state: String,
    latitude: f64,
    longitude: f64,
}

pub fn get_location(settings: Settings) -> Result<Option<Position>, PositionError> {
    todo!()
}

pub fn use_location() -> UseLocation {
    let settings = use_settings();

    match settings.location_method {
        LocationMethod::Manual => {
            // TODO: location mocking on Android
            Ok(Position {
                latitude: settings.latitude.unwrap_or_default(),
                longitude: settings.longitude.unwrap_or_default(),
                ..Default::default()
            })
        },
        LocationMethod::IP => {
            let cached = LocalStorage::get(STORAGE_KEY).ok();

            let inner = use_resource(async || {
                reqwest::get("https://ipapi.co/json/")
                    .and_then(|resp| {
                        let response = resp.json::<IpApiResponse>();
                        let position = Position {
                            name: format!("{}, {}", response.city, response.state),
                            latitude: response.latitude,
                            longitude: response.longitude,
                            ..Default::default()
                        };
                        LocalStorage::set(STORAGE_KEY, &position).ok();
                        position
                    })
                    .await
            });

            UseLocation { inner }
        },
        LocationMethod::GPS => {
            let geolocator = init_geolocator(PowerMode::Low)?;
            let coords = use_geolocation()?;

            Ok(Position {
                latitude: coords.latitude,
                longitude: coords.longitude,
                altitude: coords.altitude,
                ..Default::default()
            })
        },
    }
}
