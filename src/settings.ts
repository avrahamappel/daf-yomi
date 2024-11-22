export type Settings = {
    locationMethod: 'ip' | 'gps' | 'manual',
    longitude?: number;
    latitude?: number;
    elevation?: number;
    candleLightingMinutes: number;
    showPlag: boolean;
}

const STORAGE_KEY = 'app.settings';

/**
 * Get cached settings or default
 */
export const getSettings = (): Settings => {
    return JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}');
}

/**
 * Update settings and store
 */
export const updateSettings = (settings: Settings): void => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(settings));
}
