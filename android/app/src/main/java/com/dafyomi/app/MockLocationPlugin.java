package com.dafyomi.app;

// This is heavily inspired by https://github.com/lilstiffy/MockGps/blob/master/app/src/main/java/com/lilstiffy/mockgps/service/MockLocationService.kt

import android.location.Location;
import android.location.LocationManager;
import android.location.provider.ProviderProperties;
import android.os.SystemClock;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "MockLocation")
public class MockLocationPlugin extends Plugin {

    @PluginMethod()
    public void setMockLocation(PluginCall call) {
        double latitude = call.getDouble("latitude");
        double longitude = call.getDouble("longitude");

        Location mockLocation = new Location(LocationManager.GPS_PROVIDER);
        mockLocation.setLatitude(latitude);
        mockLocation.setLongitude(longitude);
        mockLocation.setAccuracy(2.0f);
        mockLocation.setTime(System.currentTimeMillis());
        mockLocation.setElapsedRealtimeNanos(SystemClock.elapsedRealtimeNanos());

        LocationManager locationManager = (LocationManager) getContext().getSystemService(getContext().LOCATION_SERVICE);

        try {
            locationManager.addTestProvider(
                LocationManager.GPS_PROVIDER,
                true,
                false,
                false,
                false,
                false,
                false,
                false,
                ProviderProperties.POWER_USAGE_HIGH,
                ProviderProperties.ACCURACY_FINE
            );
            locationManager.setTestProviderEnabled(LocationManager.GPS_PROVIDER, true);
            locationManager.setTestProviderLocation(LocationManager.GPS_PROVIDER, mockLocation);
        } catch (SecurityException e) {
            // Need to register the app as mock location provider
        }

        JSObject result = new JSObject();
        call.resolve(result);
    }
}
