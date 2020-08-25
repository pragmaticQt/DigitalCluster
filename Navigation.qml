import QtQuick 2.12
import QtLocation 5.12
import QtPositioning 5.12

Item {
    id: naviFrame
    visible: true

    property real naviTilt: 30
    property real zoom: 16.0

    property real carPositionX: 40.755
    property real carPositionY: -73.995

    Simulation {
        id: simulation
    }

    Plugin {
        id: mapboxglPlugin
        name: "mapboxgl"

        PluginParameter {
            name: "mapboxgl.access_token"
            value: "pk.eyJ1Ijoib2xld2FuZG93c2tpMiIsImEiOiJjampqdnQ4MWIwdzlnM2ttZGVqcnYza2xvIn0.ni1y0Hj_mm8B0YYfX3BW9g"
        }

        PluginParameter {
            name: "mapboxgl.mapping.cache.size"
            value: 2000
        }

        PluginParameter {
            name: "mapboxgl.mapping.additional_style_urls"
            value: "mapbox://styles/olewandowski2/cjrakjdzm2jf12sp9rdgwncmh"
            //value: "mapbox://styles/olewandowski2/cjn5sohnz0nr42suv510nrw4l"
            //value: "mapbox://styles/olewandowski2/cjrp872n3bo7i2slfyx8jlv75"
        }
    }

    Map {
        id: myMap
        anchors.fill: parent
        plugin: mapboxglPlugin
        center: QtPositioning.coordinate(carPositionX, carPositionY)
        zoomLevel: zoom
        bearing: 30
        tilt: naviTilt
    }

    function tiltIn()
    {
        if(naviTilt<89.5)
            naviTilt+=0.1
    }
    function zoomIn()
    {
        if(zoom < 17.0)
            zoom+=0.001
    }

    function moveCamera()
    {
        carPositionX += 0.000007
        carPositionY += 0.000005
    }

    Timer {
        id: navigtionLoop
        interval: 16
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            tiltIn()
            zoomIn()
            moveCamera()
        }
    }
}
