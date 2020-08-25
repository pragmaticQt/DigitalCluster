import QtQuick 2.12
import QtQml 2.12
import QtStudio3D 2.3

Item {
    //Statusline information
    property var locale: Qt.locale()
    property date currentTime: new Date()
    property string displayTime: "--:--"
    property real maxCarRange: 840
    property string distance: maxCarRange
    property bool speedLimitWarning: false

    //Gauges properties
    property vector3d inputRpmValue: Qt.vector3d(0, 0, 120)

    property vector3d inputSpeedValue: Qt.vector3d(0, 0, 120)

    property real speedKmH : 0.0

    //Left progressbar
    property vector3d leftProbarScale: Qt.vector3d(0.8, 0.1, 0.2)
    readonly property vector3d leftProgressbarOptimal: Qt.vector3d(0.658823529, 0.42745098, 0.047058824)
    readonly property vector3d leftProgressbarOverheat: Qt.vector3d(0.7, 0, 0)
    readonly property vector3d leftProgressbarCold: Qt.vector3d(0, 0, 0.7)
    readonly property vector3d leftProgressbarDefault: Qt.vector3d(1, 1, 1)
    property vector3d leftProgressbarColor: leftProgressbarDefault

    //Right progressbar
    property vector3d rightProbarScale: Qt.vector3d(0.8, 0.1, 0.2)
    property vector3d rightProgressbarColor: leftProgressbarCold

    //Turn sign indicators
    property bool turnOnLeftIndicator: false
    property bool turnOnRightIndicator: false

    property string rpmText: "0"
    property string speedText: "0"

    property real songIndex: 0
    property var songList: ["N'to - Alter Ego", "Occams Laser - Quarantine", "Joachim Pastor - Reykjavik", "Gigi D'Agostino - In My Mind"]
    property string currentSongName: songList[0]

    property bool runLoop: false

    // 1. Engine
    Timer {
        id: simulationLoop
        interval: 16; running: runLoop; repeat: true
        onTriggered:
        {
            engine()
            temperatureProcess()
            timeAndDate()
            checkSpeedLimit()
        }
    }

    // 2. Lights
    Timer {
        interval: 7000; running: true; repeat: true
        onTriggered:
        {
            toggleTurnIndicator()
            runLoop = true
       }
    }

    // 3. Infotainment and other
    Timer {
        interval: 3000; running: true; repeat: true
        onTriggered:
        {
            switchSong()
            carRange()
        }
    }

    function switchSong()
    {
        if(songIndex < 4) {
            currentSongName = songList[songIndex]
            songIndex++
        }
        else
            songIndex = 0
    }

    function toggleTurnIndicator()
    {
        turnOnRightIndicator = !turnOnRightIndicator
        turnOnLeftIndicator = !turnOnLeftIndicator
    }

    function carRange()
    {
        maxCarRange--
        distance = Math.floor(maxCarRange)
    }

    function checkSpeedLimit()
    {
        if(speedKmH>50)
            speedLimitWarning = true
        else
            speedLimitWarning = false
    }

    function engine()
    {
        var rightNeedleOffset = 120
        var gearFactor = 2.82
        var gearRpm = 800

        speedKmH = -Math.floor(inputSpeedValue.z-120)*0.66 //multiply by 0.66 to match graphic on speed gauge
        speedText = Math.floor(speedKmH)

        // Top speed limiters
        if(speedKmH < 170)
            inputSpeedValue.z -= 0.2
        else
            inputSpeedValue.z = 120

        //Simulate behaviour of RPM according to current speed
        if (speedKmH <= 0) {
            rpmText = "P"
            inputRpmValue.z = rightNeedleOffset
        } else if (speedKmH > 0 && speedKmH < 40) {
            // 120 -> -60
            rpmText = "D1"
            inputRpmValue.z = (-600+inputSpeedValue.z-rightNeedleOffset) *  gearFactor
        }
        else if (speedKmH >= 40 && speedKmH < 70) {
            //45 -> -60
            rpmText = "D2"
            gearFactor = 1.9
            inputRpmValue.z = (-1650+(inputSpeedValue.z-rightNeedleOffset) *  gearFactor)
        }
        else if (speedKmH >= 70 && speedKmH < 110) {
            rpmText = "D3"
            gearFactor = 1.81
            inputRpmValue.z = (-2360 + (inputSpeedValue.z+rightNeedleOffset) *  gearFactor)
        }
        else if (speedKmH >= 110 && speedKmH < 140) {
            rpmText = "D4"
            gearFactor = 2.0
            inputRpmValue.z = (-2630 + (inputSpeedValue.z+rightNeedleOffset) *  gearFactor)
        }
        else if (speedKmH >= 140 && speedKmH < 170) {
            rpmText = "D5"
            gearFactor = 3
            inputRpmValue.z = (-2880 + (inputSpeedValue.z+rightNeedleOffset) * gearFactor)
        }
    }

    function timeAndDate()
    {
        displayTime = currentTime.toLocaleTimeString(locale, Locale.ShortFormat);
    }

    function temperatureProcess()
    {
        if(leftProbarScale.y > 0 && leftProbarScale.y < 2)
        {
            leftProbarScale.y += 0.005
        }

        if(rightProbarScale.y > 0 && rightProbarScale.y < 2.6)
        {
            rightProbarScale.y += 0.005
        }
    }
}
