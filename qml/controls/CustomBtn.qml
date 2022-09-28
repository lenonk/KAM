import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: customBtn

    property color colorDefault: "#55aaff"
    property color colorMouseOver: "#cccccc"
    property color colorPressed: "#333333"

    QtObject {
        id: internal

        property var dynamicColor: if (customBtn.down) {
                                       customBtn.down ? colorPressed : colorDefault
                                   } else {
                                       customBtn.hovered ? colorMouseOver : colorDefault
                                   }
    }

    text: qsTr("Custom Btn")
    implicitWidth: 200
    implicitHeight: 40

    background: Rectangle {
        color: internal.dynamicColor
        radius: 10
    }

    contentItem: Item {
        id: item1
        Text {
            id: textBtn
            text: customBtn.text
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#ffffffff"
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:40;width:200}
}
##^##*/
