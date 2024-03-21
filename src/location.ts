import { Observable } from "rxjs";

// TODO move this entire thing into Elm except the native browser part

export type Position = {
    name?: string,
    longitude: number,
    latitude: number,
    altitude?: number
};

const STORAGE_KEY = 'app.location';

export const getLocation = (): Observable<Position> =>
    new Observable((ob) => {
        // Try local storage
        const cached = localStorage.getItem(STORAGE_KEY);
        if (cached) {
            ob.next(JSON.parse(cached));
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
                ob.next(position);
            });

        // Try geolocation (currently not working on KaiOS)
        // if ('geolocation' in navigator) {
        //     navigator.geolocation.watchPosition(
        //         ({ coords }) => ob.next(geoLocation(coords)), (err) => ob.error(err)
        //     );
        // }
    });
