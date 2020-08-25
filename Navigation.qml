import QtQuick 2.0
import QtLocation 5.6
import QtPositioning 5.6

Rectangle {
    id: naviFrame
//    width: 512
//    height: 512
    visible: true

    Plugin {
        id: mapboxglPlugin
        name: "mapboxgl"
        PluginParameter {
            name: "mapboxgl.access_token"
            value: "pk.eyJ1Ijoic2Myb2xld2FuZG93c2tpIiwiYSI6ImNqaW9xb3FpcTBxaHozcW1wNm1vMXpjc2gifQ.aPR3Ig7t6FbvGzwGvTT3GQ"
        }
        PluginParameter {
            name: "mapboxgl.mapping.additional_style_urls"
            value: "mapbox://styles/sc2olewandowski/cjj2tijrw2rn82so11ti8t6k9"
        }
        PluginParameter {
            name: "mapboxgl.mapping.cache.directory"
            value: "./"
        }
    }

    Map {
        anchors.fill: parent
        plugin: mapboxglPlugin
        center: QtPositioning.coordinate(53.431268, 14.568822);
        zoomLevel: 14
    }
}
