import { GeoLocation } from "@hebcal/core";
import { Observable } from "rxjs";

// TODO move this entire thing into Elm except the native browser part

type Position = {
    name?: string,
    longitude: number,
    latitude: number,
    altitude?: number
};

const STORAGE_KEY = 'app.location';

export const getLocation = (): Observable<GeoLocation> =>
    new Observable((ob) => {
        // Try local storage
        const cached = localStorage.getItem(STORAGE_KEY);
        if (cached) {
            ob.next(geoLocation(JSON.parse(cached)));
        }

        // Try ip location
        fetch("http://ip-api.com/json", { mode: 'cors' })
            .then((res) => res.json())
            .then((json) => {
                const { lat, lon, city, region } = json;
                const position = {
                    longitude: lon,
                    latitude: lat,
                    name: `${city}, ${region}`,
                };
                localStorage.setItem(STORAGE_KEY, JSON.stringify(position));
                ob.next(geoLocation(position));
            });

        // Try geolocation (currently not working on KaiOS)
        // if ('geolocation' in navigator) {
        //     navigator.geolocation.watchPosition(
        //         ({ coords }) => ob.next(geoLocation(coords)), (err) => ob.error(err)
        //     );
        // }
    });

const geoLocation = ({ latitude, longitude, name, altitude }: Position) =>
    new GeoLocation(
        name,
        latitude,
        longitude,
        altitude || 0,
        Intl.DateTimeFormat().resolvedOptions().timeZone
    );
