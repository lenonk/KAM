import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import CustomControls 1.0
import QtGraphicalEffects 1.0

import "../../../controls"

Rectangle {
    id: rectTop
    Rectangle {
        id: rectGPULeft

        anchors {
            top: parent.top
            left: parent.left
        }

        width: parent.width / 2

        Label {
            id: lblGPUModel
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 10
                leftMargin: 10
            }

            text: "Model: "
            font.pointSize: 10
            font.bold: true

            Label {
                anchors.top: parent.top
                anchors.left: parent.right
                anchors.leftMargin: 5
                text: backend.gpuName
                font.pointSize: 10
                font.bold: false
                color: PlasmaCore.Theme.disabledTextColor
            }
        }

        Label {
            id: lblGPUTDP
            anchors {
                top: lblGPUModel.bottom
                left: parent.left
                topMargin: 15
                leftMargin: 10
            }

            text: "Average Power: "
            font.pointSize: 10
            font.bold: true

            Label {
                anchors.top: parent.top
                anchors.left: parent.right
                anchors.leftMargin: 5
                text: backend.hasRadeon ? backend.gpuPower + " W" : "Unknown"
                font.pointSize: 10
                font.bold: false
                color: PlasmaCore.Theme.disabledTextColor
            }
        }
    }

    Rectangle {
        id: rectGPURight

        anchors {
            top: parent.top
            left: rectGPULeft.right
            right: parent.right
        }

        Label {
            id: lblGPUStockFrequency
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 10
                leftMargin: 10
            }

            text: "Stock Frequency: "
            font.pointSize: 10
            font.bold: true

            Label {
                anchors.top: parent.top
                anchors.left: parent.right
                anchors.leftMargin: 5
                text: backend.gpuFreqMax
                font.pointSize: 10
                font.bold: false
                color: PlasmaCore.Theme.disabledTextColor
            }
        }

        Label {
            id: lblGPUCurrentFrequency
            anchors {
                top: lblGPUStockFrequency.bottom
                left: parent.left
                topMargin: 15
                leftMargin: 10
            }
            text: "Current Frequency: "
            font.pointSize: 10
            font.bold: true

            Label {
                anchors.top: parent.top
                anchors.left: parent.right
                anchors.leftMargin: 5
                text: backend.gpuFreqText
                font.pointSize: 10
                font.bold: false
                color: PlasmaCore.Theme.disabledTextColor
            }
        }
    }
}
