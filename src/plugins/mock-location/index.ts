import { registerPlugin } from '@capacitor/core';

export interface MockLocationPlugin {
    setMockLocation(options: { latitude: number; longitude: number }): Promise<void>;
}

const MockLocation = registerPlugin<MockLocationPlugin>('MockLocation', {
    // android: () => import('./android/MockLocationAndroid').then(m => m.MockLocationAndroid),
});

export { MockLocation };
