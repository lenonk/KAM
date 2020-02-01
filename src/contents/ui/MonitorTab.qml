import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Layouts 1.4
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.13 as Controls
import QtQuick.Controls 1.4

Item {
    id: monitorTab
    CpuRect {
        id: cpuRect
        anchors {
            left: parent.left
            top: parent.top
            topMargin: 10
            rightMargin: 5
        }
    }
    GpuRect {
        id: gpuRect
        anchors {
            right: parent.right
            top: parent.top
            topMargin: 10
            leftMargin: 5
        }
    }
    Rectangle {
        id: ramRect
        anchors {
            left: parent.left
            top: cpuRect.bottom
            topMargin: 10
        }

        implicitWidth: (parent.width * 0.33) - netRect.anchors.leftMargin / 2
        height:150
        color: Kirigami.Theme.backgroundColor
        border.color: Kirigami.Theme.alternateBackgroundColor
        border.width: 1
        radius: 3
        antialiasing: true
        Text {
            font.bold: true
            font.pointSize: 14
            color: Kirigami.Theme.textColor
            anchors { top: parent.top; left: parent.left; margins: 10 }
            text: qsTr("RAM")
        }
        KAMRadialBar {
            id: ramRadialBar
            anchors.centerIn: parent
            dialWidth: 5
            value: backend.ramUsage
            textFont {
                family: "MrEavesXLModOT-Book"
                pointSize: 18
            }
        }
    }
    Rectangle {
        id: netRect
        anchors {
            left: ramRect.right
            right: storRect.left
            top: cpuRect.bottom
            topMargin: 10
            rightMargin: 10
            leftMargin: 10
        }

        implicitWidth: (parent.width * 0.33)
        height:150
        color: Kirigami.Theme.backgroundColor
        border.color: Kirigami.Theme.alternateBackgroundColor
        border.width: 1
        radius: 3
        antialiasing: true
    }
    StorRect {
        id: storRect
        anchors {
            right: parent.right
            top: gpuRect.bottom
            topMargin: 10
        }
    }
    
    KAMProcTable {
        anchors {
            left: parent.left
            top: netRect.bottom
            right: parent.right
            topMargin: 10
        }
        model: ProcessModel {}
    }
    
    /*ListModel {
        id: tableModel
        // All of these should go away when the backend is written
        ListElement {
            process: "Microsoft Teams"
            cpu: "0.0%"
            gpu: "1%"
            ram: "733.5MB"
            upload: "568 b/s"
            download: "45 kb/s"
        }
        ListElement {
            process: "Deepin System Monitor"
            cpu: "10.1%"
            gpu: "17.4%"
            ram: "24.7MB"
            upload: ""
            download: ""
        }
        ListElement {
            process: "GMail/Inbox - Kontact"
            cpu: "5.5%"
            gpu: "1%"
            ram: "176.3MB"
            upload: "46 kb/s"
            download: "4598 kb/s"
        }
    }*/
}
