import { Settings } from "./settings";

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

    // if (settings.locationMethod === 'gps') {
    // Try geolocation (currently not working on KaiOS)
    // if ('geolocation' in navigator) {
    //     navigator.geolocation.watchPosition(
    //         ({ coords }) => ob.next(geoLocation(coords)), (err) => ob.error(err)
    //     );
    // }
    // }
};
