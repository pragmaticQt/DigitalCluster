import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    id: root
    width: 1280; height: 480
    visible: true

    Navigation {
        id: navigation
        anchors.centerIn: parent
        visible: true
        width: parent.width
        height: parent.height
    }

    Presentation3D {
        id: studio3d
        visible: true
        width: parent.width
        height: parent.height
    }

    Simulation {
        id: simulation
    }

}
