import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.FactControls
import QGroundControl.Controls

Item {
    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight
    width: parent.width  // grows when Loader is wider than implicitWidth

    AirframeComponentController { id: controller; }

    property Fact sysIdFact:        controller.getParameterFact(-1, "MAV_SYS_ID")
    property Fact sysAutoStartFact: controller.getParameterFact(-1, "SYS_AUTOSTART")

    property bool autoStartSet: sysAutoStartFact ? (sysAutoStartFact.value !== 0) : false
    property bool gitHashAvailable: globals.activeVehicle.gitHash && globals.activeVehicle.gitHash.length > 0
    property string gitHashText: globals.activeVehicle.gitHash && globals.activeVehicle.gitHash.length > 0 ?
                                     globals.activeVehicle.gitHash :
                                     qsTr("Unknown")
    property bool firmwareVersionValid: globals.activeVehicle.firmwareMajorVersion !== -1 &&
                                        (globals.activeVehicle.firmwareMajorVersion !== 0 ||
                                         globals.activeVehicle.firmwareMinorVersion !== 0 ||
                                         globals.activeVehicle.firmwarePatchVersion !== 0)
    property string firmwareVersionText: firmwareVersionValid ?
                                             globals.activeVehicle.firmwareMajorVersion + "." +
                                             globals.activeVehicle.firmwareMinorVersion + "." +
                                             globals.activeVehicle.firmwarePatchVersion +
                                             globals.activeVehicle.firmwareVersionTypeString :
                                             (gitHashAvailable ? qsTr("Git ") + gitHashText : qsTr("Unknown"))

    ColumnLayout {
        id: mainLayout
        spacing: 0

        VehicleSummaryRow {
            labelText: qsTr("System ID")
            valueText: sysIdFact ? sysIdFact.valueString : ""
        }
        VehicleSummaryRow {
            labelText: qsTr("Airframe type")
            valueText: autoStartSet ? controller.currentAirframeType : qsTr("Setup required")
        }
        VehicleSummaryRow {
            labelText: qsTr("Vehicle")
            valueText: autoStartSet ? controller.currentVehicleName : qsTr("Setup required")
        }

        VehicleSummaryRow {
            labelText: qsTr("Firmware Version")
            valueText: firmwareVersionText
        }
        VehicleSummaryRow {
            visible: globals.activeVehicle.px4Firmware
            labelText: qsTr("Git Hash")
            valueText: gitHashText
        }
    }
}
