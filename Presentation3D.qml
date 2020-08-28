import QtQuick 2.12
import QtStudio3D 2.3

Item {

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
                currentSlideIndex: 0
            }

            //Mapping for dataInputs to Simulation
            DataInput {
                name: "LeftGaugeScale"
                value: simulation.leftGaugeScale
            }
            DataInput {
                name: "turnSignalRight"
                value: simulation.turnedOnRightIndicator
            }
            DataInput {
                name: "turnSignalLeft"
                value: simulation.turnedOnRightIndicator
            }

            DataInput {
                name: "speedValue"
                value: simulation.inputSpeedValue
            }

            DataInput {
                name: "rpmValue"
                value: simulation.inputRpmValue
            }
            DataInput {
                name: "unitTypeValue"
                value: "km"
            }
            DataInput {
                name: "rpmText"
                value: simulation.rpmText
            }
            DataInput {
                name: "speedText"
                value: simulation.speedText
            }
            DataInput {
                name: "distanceValue"
                value: simulation.distance
            }
            DataInput {
                name: "leftProgressbarScale"
                value: simulation.leftProbarScale
            }
            DataInput {
                name: "leftProgressbarColor"
                value: simulation.leftProgressbarColor
            }
            DataInput {
                name: "rightProgressbarScale"
                value: simulation.rightProbarScale
            }
            DataInput {
                name: "rightProgressbarColor"
                value: simulation.rightProgressbarColor
            }
            DataInput {
                name: "songName"
                value: simulation.currentSongName
            }
        }
//        Studio3DProfiler {
//            id: profiler3d
//            visible: true
//            anchors.fill: parent
//            anchors.topMargin: 40
//        }

        Timer {
            interval: 60000; running: true; repeat: true
            property string switchSlide: "MergeIn"

            onTriggered:
            {
                s3d.presentation.goToSlide("Scene", switchSlide)

                if(switchSlide == "MergeOut")
                    switchSlide = "MergeIn"
                else
                    switchSlide = "MergeOut"
            }
        }
    }
}
