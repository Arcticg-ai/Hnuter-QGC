import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

Item {
    id: root

    implicitWidth:  panel.implicitWidth + (panelMargin * 2)
    implicitHeight: panel.implicitHeight + (panelMargin * 2)
    visible:        servoMonitor.servoCount > 0

    readonly property real panelMargin: ScreenTools.defaultFontPixelWidth * 0.75

    QGCPalette {
        id: qgcPal
        colorGroupEnabled: enabled
    }

    ServoOutputMonitorController {
        id: servoMonitor
    }

    Rectangle {
        anchors.fill:   parent
        color:          qgcPal.window
        radius:         ScreenTools.defaultFontPixelWidth / 2
        opacity:        0.75
    }

    ColumnLayout {
        id:                 panel
        anchors.margins:    panelMargin
        anchors.fill:       parent
        spacing:            ScreenTools.defaultFontPixelHeight * 0.25

        QGCLabel {
            Layout.fillWidth:   true
            text:               qsTr("Servos")
            font.bold:          true
            color:              qgcPal.text
        }

        GridLayout {
            Layout.fillWidth:   true
            columns:            Math.min(Math.max(servoMonitor.servoCount, 1), 4)
            rowSpacing:         0
            columnSpacing:      ScreenTools.defaultFontPixelWidth

            Repeater {
                model: Math.min(servoMonitor.servoCount, 8)

                RowLayout {
                    id: row
                    spacing: ScreenTools.defaultFontPixelWidth * 0.35

                    property int servoIndex: index
                    property int pwmValue: servoMonitor.servoValue(servoIndex)

                    Connections {
                        target: servoMonitor

                        function onServoValueChanged(servo, pwmValue) {
                            if (servo === row.servoIndex) {
                                row.pwmValue = pwmValue
                            }
                        }
                    }

                    QGCLabel {
                        text:                   "S" + (servoIndex + 1)
                        color:                  qgcPal.text
                        Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * 2.2
                        horizontalAlignment:    Text.AlignRight
                    }

                    QGCLabel {
                        text:                   pwmValue >= 0 ? pwmValue : "--"
                        color:                  pwmValue >= 0 ? qgcPal.text : qgcPal.textGrey
                        Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * 4.4
                        horizontalAlignment:    Text.AlignRight
                    }
                }
            }
        }
    }
}
