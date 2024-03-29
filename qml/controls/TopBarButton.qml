import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import org.kde.plasma.core 2.0 as PlasmaCore

Button {
    id: btnTopBar

    property url btnIconSource: "../../images/svg_images/minimize_icon.svg"
    property color btnColorDefault: "#1c1d20"
    property color btnColorMouseOver: "#23272e"
    property color btnColorClicked: "#00a1f1"

    QtObject {
       id: internal

       property var dynamicColor: if (btnTopBar.down) {
                                      btnTopBar.down ? btnColorClicked : btnColorDefault
                                  }
                                  else {
                                      btnTopBar.hovered ? btnColorMouseOver : btnColorDefault
                                  }
    }

    implicitWidth: 35
    implicitHeight: 35

    background: Rectangle {
        id: bgBtn
        color: internal.dynamicColor
    }

    Image {
        id: iconBtn
        source: btnIconSource
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        height:16
        width: 16
        fillMode: Image.PreserveAspectFit
        visible: false
        antialiasing: false
    }

    ColorOverlay {
        anchors.fill: iconBtn
        source: iconBtn
        color: PlasmaCore.Theme.buttonTextColor
        antialiasing: false
    }

}

/*##^##
Designer {
    D{i:0;height:35;width:35}
}
##^##*/
