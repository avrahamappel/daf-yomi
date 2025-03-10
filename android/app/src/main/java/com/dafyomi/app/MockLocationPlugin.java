package com.dafyomi.app;

import android.location.Location;
import android.location.LocationManager;
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
        locationManager.setTestProviderEnabled(LocationManager.GPS_PROVIDER, true);

        try {
            locationManager.setTestProviderLocation(LocationManager.GPS_PROVIDER, mockLocation);
        } catch (SecurityException e) {
            // Need to register the app as mock location provider
        }

        JSObject result = new JSObject();
        call.resolve(result);
    }
}
