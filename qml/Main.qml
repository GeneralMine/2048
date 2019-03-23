import Felgo 3.0
import QtQuick 2.2

GameWindow {
    id: gameWindow
    screenWidth: 960
    screenHeight: 640

    property int gridWidth: 300 // width and height of the game grid
    property int gridSizeGame: 4 // game grid size in tiles
    property int gridSizeGameSquared: gridSizeGame*gridSizeGame
    property var emptyCells // an array to keep track of all empty cells
    property var tileItems:  new Array(gridSizeGameSquared) // our Tiles

    activeScene: gameScene

    EntityManager {
        id: entityManager
        entityContainer: gameContainer
    }

    Scene {
        id: gameScene

        width: 480
        height: 320

        Rectangle {
            id: background
            anchors.fill: gameScene.gameWindowAnchorItem
            color: "#B6581A" // main color
            border.width: 5
            border.color: "#4A230B" // margin color
            radius: 10 // radius of the corners
        }
        Item {
            id: gameContainer
            width: gridWidth
            height: width // square so height = width
            anchors.centerIn: parent

            GameBackground {}
        }
        Timer {
            id: moveRelease
            interval: 300
        }
        Keys.forwardTo: keyboardController //  makeing sure that focus is automatically provided to the keyboardController.

        Item {
            id: keyboardController

            Keys.onPressed: {
                if (event.key === Qt.Key_Left && moveRelease.running === false) {
                    event.accepted = true
                    moveRelease.start()
                    console.log("move Left")
                }
            }
        }
    }
}
