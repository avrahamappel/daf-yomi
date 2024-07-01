import { Settings } from "./settings";
import { Geolocation } from '@capacitor/geolocation';

export type Position = {
    name?: string,
    longitude: number,
    latitude: number,
    altitude?: number
};

const STORAGE_KEY = 'app.location';

export const getLocation = (settings: Settings, next: (pos: Position) => void, error: (message: string) => void): void => {
    if (settings.locationMethod === 'manual') {
        next(settings.manualPosition);
    }

    if (settings.locationMethod === 'ip') {
        // Try local storage
        const cached = localStorage.getItem(STORAGE_KEY);
        if (cached) {
            next(JSON.parse(cached));
        }

        // Try ip location
        fetch("https://api.ipapi.is", { mode: 'cors' })
            .then((res) => res.json())
            .then((json) => {
                const { latitude, longitude, city, state } = json.location;
                const position = {
                    longitude,
                    latitude,
                    name: `${city}, ${state}`,
                };
                localStorage.setItem(STORAGE_KEY, JSON.stringify(position));
                next(position);
            }).catch(e => {
                error(e.message || "Could not fetch location");
                console.error(e)
            });
    }

    if (settings.locationMethod === 'gps') {
        Geolocation.watchPosition({}, (geoPos, err) => {
            if (err) {
                error(err.code ? `GPS Error ${err.code}: ${err.message}` : err.message || "Geolocation error")
            }
            if (!geoPos) return;

            const { longitude, latitude, altitude } = geoPos.coords;
            const pos: Position = { longitude, latitude };

            if (altitude !== null) {
                pos.altitude = altitude;
            }

            next(pos);
        });
    }
};
