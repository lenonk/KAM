import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Layouts 1.4
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.13 as Controls
import QtQuick.Controls 1.4

TableView {
    implicitHeight: 150 - anchors.topMargin
    selectionMode: SelectionMode.NoSelection

    TableViewColumn { 
        title: "Top Processes"; 
        width: 252 
        delegate: Text {
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter 
            anchors.leftMargin: 10
            color: Kirigami.Theme.textColor
            text: (model != null) ? model.process : ""
        }
    }
    TableViewColumn { 
        title: "CPU"
        delegate: Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter 
            anchors.rightMargin: 10
            color: Kirigami.Theme.textColor
            text: (model != null) ? model.cpu : ""
        }
        width: 60 
    }
    TableViewColumn {
        title: "GPU"
        delegate: Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter 
            anchors.rightMargin: 10
            color: Kirigami.Theme.textColor
            text: (model != null) ? model.gpu : ""
        }
        width: 60
    }
    TableViewColumn { 
        title: "RAM"
        delegate: Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter 
            anchors.rightMargin: 10
            color: Kirigami.Theme.textColor
            text: (model != null) ? model.ram : ""
        }
        width: 60
    }
    TableViewColumn { 
        title: "Download"
        delegate: Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter 
            anchors.rightMargin: 10
            color: Kirigami.Theme.textColor
            text: (model != null) ? model.download : ""
        }
        width: 90
    }
    TableViewColumn { 
        title: "Upload"
        delegate: Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter 
            anchors.rightMargin: 10
            color: Kirigami.Theme.textColor
            text: (model != null) ? model.upload : ""
        }
        width: 90
    }
}
