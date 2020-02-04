import QtQuick 2.14
import CustomControls 1.0
import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls 2.14 

Rectangle {
    id: cpuRect
    
    height: 200
    implicitWidth: (parent.width / 2) - anchors.rightMargin
    color: Kirigami.Theme.backgroundColor
    border.color: Kirigami.Theme.alternateBackgroundColor
    //color: PlasmaCore.Theme.backgroundColor
    //border.color: PlasmaCore.Theme.textColor
    border.width: 1
    radius: 3
    antialiasing: true

    Launcher {
        id: qprocess
    }
    
    Text {
        id: cpuText
        text: qsTr("CPU")
        font.bold: true
        font.pointSize: 14
        color: Kirigami.Theme.textColor
        anchors { top: parent.top; left: parent.left; margins: 10 }
    }
    KAMRadialBar {
        id: cpuRadialBar
        value: backend.cpuUsage
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            margins: 10
        }
    }
    Text {
        id: loadText
        text: qsTr("Minimal Load")
        color: Kirigami.Theme.textColor
        anchors { bottom: parent.bottom; left: parent.left; margins: 10 }
    }
    ComboBox {
        id: control
        model: ListModel {
            id: cbItems
            ListElement { text: "Powersave"; value: "powersave" }
            ListElement { text: "Ondemand"; value: "ondemand" }
            ListElement { text: "Performance"; value: "performance" }
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
                elide: Text.EideRight
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
        
        onCurrentIndexChanged: qprocess.launch('kdesu -c "cpupower frequency-set -g ' + cbItems.get(currentIndex).value)
    }
    KAMProgressBar {
        id: cpuTempProgress
        value: backend.cpuTemp / 100.0;
        anchors {
            top: parent.top
            left: cpuRadialBar.right
            right: parent.right
            leftMargin: 15
            rightMargin: 10
            topMargin: (parent.height * 0.33) - height
        }
        
        leftText: qsTr("Temperature")
        rightText: qsTr(Number(backend.cpuTemp).toString() + "\u2103")
    }
    KAMProgressBar {
        id: cpuClockProgress
        value: backend.cpuFreq
        anchors {
            top: cpuTempProgress.bottom
            left: cpuRadialBar.right
            right: parent.right
            leftMargin: 15
            rightMargin: 10
            topMargin: 30
        }
        
        leftText: qsTr("Clock")
        rightText: qsTr(backend.cpuFreqText + "MHz")
    }
    KAMProgressBar {
        id: cpuFanProgress
        value: backend.cpuFan
        anchors {
            top: cpuClockProgress.bottom
            left: cpuRadialBar.right
            right: parent.right
            leftMargin: 15
            rightMargin: 10
            topMargin: 30
        }
        
        leftText: qsTr("Fan")
        rightText: qsTr(backend.cpuFanText + "RPM")
    }
}
