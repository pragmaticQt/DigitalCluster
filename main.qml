import QtQuick 2.11
import QtQuick.Window 2.11
import QtStudio3D 2.0
import QtLocation 5.9
import QtPositioning 5.8

Rectangle {
    id: root
    color: "lightGray"

    Navigation {
        anchors.centerIn: parent

        width: 600
        height: 300
    }

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
                currentSlideIndex: 1
            }

            SubPresentationSettings {
                        qmlStreams: [
                            QmlStream {
                                presentationId: "sub-presentation-id"
                                Item {
                                    Rectangle {
                                        width: 100
                                        height: 100
                                        color: "red"
                                        border.color: "black"
                                        border.width: 5
                                        radius: 10
                                    }
                                }
                            }
                        ]
                    }
        }
        ViewerSettings {
            showRenderStats: true
        }

        onRunningChanged: {
            console.log("Presentation readly!")
        }
    }
}
