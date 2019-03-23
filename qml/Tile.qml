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

    property int tileFontSize: width/3

    Rectangle{
        id: innerRect
        anchors.centerIn: parent
        width: parent.width - 2
        height: width
        radius: 4
        color: "#88B605"

        Text{
            id: innerRectText
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: tileFontSize
            text: Math.pow(2, tileValue)
        }
    }

    Component.onCompleted: {
        x = (width) * (tileIndex % gridSizeGame)
        y = (height) * Math.floor(tileIndex / gridSizeGame)
        tileValue = Math.random() < 0.9 ? 1 : 2
    }

    function moveTile(newTileIndex){
        tileIndex = newTileIndex
        x = ((width) * (tileIndex % gridSizeGame))
        y = ((height) * Math.floor(tileIndex / gridSizeGame))
    }

    function destroyTile(){
        removeEntity()
    }
}
