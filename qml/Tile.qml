import QtQuick 2.2
import Felgo 3.0

EntityBase {
    id: tile
    entityType: "Tile"

    width: gridWidth / gridSizeGame // "300" / "4"
    height: width

    property int tileIndex
    property int tileValue
    property string tileText
    property color tileColor
    property color tileTextColor: "white"

    property int tileFontSize: width/3

    property int animationDuration: system.desktopPlatform ? 500 : 250

    property var bgColors: ["#000000", "#88B605", "#587603", "#293601", "#48765F", "#1A9C70", "#14C3B6", "#1591B6", "#1668C3", "#1C15B6", "#821DB6", "#C31555"]

    Rectangle{
        id: innerRect
        anchors.centerIn: parent
        width: parent.width - 2
        height: width
        radius: 4
        color: bgColors[tileValue]

        Text{
            id: innerRectText
            anchors.centerIn: parent
            color: tileTextColor
            font.pixelSize: tileFontSize
            text: Math.pow(2, tileValue)
        }
    }

    Component.onCompleted: {
        x = (width) * (tileIndex % gridSizeGame)
        y = (height) * Math.floor(tileIndex / gridSizeGame)
        tileValue = Math.random() < 0.9 ? 1 : 2
        showTileAnim.start()
    }

    function moveTile(newTileIndex){
        tileIndex = newTileIndex
        moveTileAnim.targetPoint.x = ((width) * (tileIndex % gridSizeGame))
        moveTileAnim.targetPoint.y = ((height) * Math.floor(tileIndex / gridSizeGame))
        moveTileAnim.start()
    }

    function destroyTile(){
        deathAnimation.start()
    }

    ParallelAnimation{
        id: showTileAnim

        NumberAnimation{
            target: innerRect
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: animationDuration
        }

        ScaleAnimator{
            target: innerRect
            from: 0
            to: 1
            duration: animationDuration
            easing.type: Easing.OutQuad
        }
    }

    ParallelAnimation{
        id: moveTileAnim
        property point targetPoint: Qt.point(0,0)
        NumberAnimation{
            target: tile
            property: "x"
            duration: animationDuration/2
            to: moveTileAnim.targetPoint.x
        }
        NumberAnimation{
            target: tile
            property: "y"
            duration: animationDuration/2
            to: moveTileAnim.targetPoint.y
        }
    }

    SequentialAnimation{
        id: deathAnimation
        NumberAnimation{
            target: innerRect
            property: "opacity"
            from: 1
            to: 0
            duration: animationDuration/2
        }
        ScriptAction{
            script: removeEntity()
        }
    }
}
