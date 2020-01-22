import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Layouts 1.4
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.13 as Controls
import QtQuick.Controls 1.4

TableView {
    anchors {
    }
    
    implicitHeight: 150 - anchors.topMargin
    
    TableViewColumn {
        title: "Top Processes"
        role: "process"
        width: 200
    }
    TableViewColumn {
        title: "CPU"
        role: "cpu"
        width: 75
    }
    TableViewColumn {
        title: "GPU"
        role: "gpu"
        width: 75
    }
    TableViewColumn {
        title: "RAM"
        role: "ram"
        width: 75
    }
    TableViewColumn {
        title: "Upload"
        role: "upload"
        width: 90
    }
    TableViewColumn {
        title: "Download"
        role: "download"
        width: 90
    }
    
}
