import CustomControls 1.0
import org.kde.kirigami 2.4 as Kirigami

RadialBar {
    id: control

    width: parent.width / 2.3
    height: width
    penStyle: Qt.FlatCap
    progressColor: Kirigami.Theme.highlightColor
    foregroundColor: Kirigami.Theme.disabledTextColor
    dialWidth: 8
    minValue: 0
    maxValue: 100
    value: 16
    suffixText: "%"
    startAngle: 350
    textFont {
        family: "Ariel"
        italic: false
        pointSize: 18
    }
    textColor: foregroundColor
}
