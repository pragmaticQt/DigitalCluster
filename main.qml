import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.VirtualKeyboard 2.3
import QtStudio3D 2.0
import QtLocation 5.9
import QtPositioning 5.8

Rectangle {
    id: root
    color: "lightGrey"

//    Navigation {
//        id: navi
//        anchors.centerIn: parent
//        anchors.fill: parent
//    }

    Studio3D {
        id: s3d
        focus: true
        anchors.margins: 0
        anchors.fill: parent

        Presentation {
            id: s3dpres
            source: "qrc:/Cluster/SampleProject.uip"

            SceneElement {
                id: scene
                elementPath: "Scene"
                currentSlideIndex: 2
            }
        }

        onRunningChanged: {
            console.log("Presentation readly!")
        }
    }
}
