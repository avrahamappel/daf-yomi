type BaseSettings = {
    candleLightingMinutes: number;
    showPlag: boolean;
}

export type Settings = BaseSettings & ({
    locationMethod: 'ip' | 'gps';
    longitude?: number;
    latitude?: number;
} | {
    locationMethod: 'manual',
    longitude: number;
    latitude: number;
})

const STORAGE_KEY = 'app.settings';

/**
 * Get cached settings or default
 */
export const getSettings = (): Settings => {
    const stored = JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}');

    if (!('locationMethod' in stored)) {
        stored.locationMethod = 'ip';
    }

    if (!('profile' in stored)) {
        stored.profile = 'to-w';
    }

    return stored;
}

/**
 * Update settings and store
 */
export const updateSettings = (settings: Settings): void => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(settings));
}
