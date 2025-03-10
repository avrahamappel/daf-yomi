import { registerPlugin } from '@capacitor/core';

export interface MockLocationPlugin {
    setMockLocation(options: { latitude: number; longitude: number }): Promise<void>;
}

const MockLocation = registerPlugin<MockLocationPlugin>('MockLocation');

export { MockLocation };
