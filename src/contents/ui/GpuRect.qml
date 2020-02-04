import QtQuick 2.14
import CustomControls 1.0
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.14

Rectangle {
    id: gpuRect
    
    height: 200
    implicitWidth: (parent.width / 2) - anchors.leftMargin
    color: Kirigami.Theme.backgroundColor
    border.color: Kirigami.Theme.alternateBackgroundColor
    border.width: 1
    radius: 3
    antialiasing: true
    
    Launcher {
        id: qprocess
    }
    
    Text {
        id: gpuText
        text: qsTr("GPU")
        font.bold: true
        font.pointSize: 14
        color: Kirigami.Theme.textColor
        anchors { top: parent.top; left: parent.left; margins: 10 }
    }
    KAMRadialBar {
        id: gpuRadialBar
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            margins: 10
        }

        value: backend.gpuUsage
    }
    Text {
        id: loadText
        text: qsTr("obs64")
        color: Kirigami.Theme.textColor
        anchors { bottom: parent.bottom; left: parent.left; margins: 10 }
    }
    ComboBox {
        id: control
        model: ListModel {
            id: cbItems
            ListElement { text: "Auto"; value: 2}
            ListElement { text: "Adaptive"; value: 0}
            ListElement { text: "Prefer Max Performance"; value: 1}
        }
        anchors { top: parent.top; right: parent.right; margins: 10 }
        width: 148
        height: 30
        
        delegate: ItemDelegate {
            width: control.width
            contentItem: Text {
                text: model.text
                color: Kirigami.Theme.textColor
                font: control.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            highlighted: control.highlightedIndex === index
        }
        
        contentItem: Text {
            text: cbItems.get(parent.currentIndex).text
            color: Kirigami.Theme.textColor
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        
        onCurrentIndexChanged: qprocess.launch('nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=' + cbItems.get(currentIndex).value)
    }
    KAMProgressBar {
        id: gpuTempProgress
        value: backend.gpuTemp / 100.0
        anchors {
            top: parent.top
            left: gpuRadialBar.right
            right: parent.right
            leftMargin: 15
            rightMargin: 10
            topMargin: (parent.height * 0.33) - height
        }
        
        leftText: qsTr("Temperature")
        rightText: qsTr(Number(backend.gpuTemp).toString() + "\u2103")
    }
    KAMProgressBar {
        id: gpuClockProgress
        value: backend.gpuFreq
        anchors {
            top: gpuTempProgress.bottom
            left: gpuRadialBar.right
            right: parent.right
            leftMargin: 15
            rightMargin: 10
            topMargin: 30
        }
        
        leftText: qsTr("Clock")
        rightText: qsTr(backend.gpuFreqText + "MHz")
    }
    KAMProgressBar {
        id: gpuFanProgress
        value: backend.gpuFan
        anchors {
            top: gpuClockProgress.bottom
            left: gpuRadialBar.right
            right: parent.right
            leftMargin: 15
            rightMargin: 10
            topMargin: 30
        }
        
        leftText: qsTr("Fan")
        rightText: qsTr(backend.gpuFanText + "RPM")
    }
}
