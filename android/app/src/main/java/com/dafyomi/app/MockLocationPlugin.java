package com.dafyomi.app;

import android.location.Location;
import android.location.LocationManager;
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

        LocationManager locationManager = (LocationManager) getContext().getSystemService(getContext().LOCATION_SERVICE);
        locationManager.setTestProviderLocation(LocationManager.GPS_PROVIDER, mockLocation);

        JSObject result = new JSObject();
        call.resolve(result);
    }
}
