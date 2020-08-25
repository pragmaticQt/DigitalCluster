import QtQuick 2.12
import QtQuick.Window 2.12

Image {
    width: 80
    height: 80

    Rectangle {
        x: 480; y: 0; width: 860; height: 480
        rotation: 90
        gradient: Gradient {
            GradientStop { position: 0.0; color: "lightsteelblue" }
            GradientStop { position: 1.0; color: "blue" }
        }
        Row {
            Repeater {
                model: 3
                Rectangle {
                    width: 120; height: 40
                    border.width: 1
                    color: "yellow"
                }
            }
        }
    }
}
