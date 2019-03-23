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
            color: "#2979FF" // main color
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
        MouseArea{
            id: mouseArea
            anchors.fill: gameScene.gameWindowAnchorItem

            property int startX //initial position X
            property int startY //initial position Y

            property string direction //of the swipe
            property bool moving: false

            onPressed: {
                startX = mouseX
                startY = mouseY
                moving = false
            }

            onReleased: {
                moving = false
            }

            onPositionChanged: {
                var deltax = mouse.x - startX
                var deltay = mouse.y - startY

                if(moving === false){
                    if(Math.abs(deltax) > 40 || Math.abs(deltay) > 40){
                        moving = true

                        if(deltax > 30 && Math.abs(deltay) < 30 && moveRelease.running === false){
                            console.log("move right")
                            moveRight()
                            moveRelease.start()
                        }
                        else if(deltax < -30 && Math.abs(deltay) < 30 && moveRelease.running === false){
                            console.log("move left")
                            moveLeft()
                            moveRelease.start()
                        }
                        else if(Math.abs(deltax) < 30 && deltay > 30 && moveRelease.running === false){
                            console.log("move down")
                            moveRelease.start()
                        }
                        else if(Math.abs(deltax) < 30 && deltay < -30 && moveRelease.running === false){
                            console.log("move up")
                            moveRelease.start()
                        }
                    }
                }
            }
        }

        Component.onCompleted: {
            // fill the main array with empty spaces
            for(var i = 0; i < gridSizeGameSquared; i++){
                tileItems[i] = null
            }
            //collect empty cells positions
            updateEmptyCells()
            //create 2 random tiles
            createNewTile()
            createNewTile()
        }
    }

    function updateEmptyCells(){ //extract and save emptyCells from tileItems for later generation of new random tiles
        emptyCells = []
        for(var i = 0; i < gridSizeGameSquared; i++){
            if(tileItems[i] === null){
                emptyCells.push(i)
            }
        }
    }

    function createNewTile(){
        var randomCellId = emptyCells[Math.floor(Math.random() * emptyCells.length)] // get random emptyCells
        var tileId = entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("Tile.qml"), {"tileIndex": randomCellId}) //create new Tile with a referenceID
        tileItems[randomCellId] = entityManager.getEntityById(tileId) //paste new Tile to the array
        emptyCells.splice(emptyCells.indexOf(randomCellId), 1) //remove the taken cell from emptyCell array
    }
    function merge(sourceRow){
        var i, j
        var nonEmptyTiles = [] //sourceRow without empty tiles

        //remove empty elements
        for(i = 0; i < sourceRow.length; i++){
            if(sourceRow[i] > 0){
                nonEmptyTiles.push(sourceRow[i])
            }
        }

        var mergedRow = [] //row afer merge
        for(i = 0; i < nonEmptyTiles.length; i++){

            if(i === nonEmptyTiles.length - 1){ //if last element push because last element has no other to merge with
                mergedRow.push(nonEmptyTiles[i])
            }
            else{
                //comparing if values are equal/mergeable
                if(nonEmptyTiles[i] === nonEmptyTiles[i+1]){
                    //merge elements
                    mergedRow.push(nonEmptyTiles[i] + 1)
                    i++ //skip one element, because one got deleted
                }
                else{
                    mergedRow.push(nonEmptyTiles[i]) //no merge
                }
            }
        }

        //fill empty spots with zeros
        for(i=mergedRow.length; i < sourceRow.length; i++){
            mergedRow[i] = 0
        }
        //create object with merged row array inside and return it
        return {mergedRow : mergedRow}
    }
    function getRowAt(index){
        var row = []
        for(var j = 0; j < gridSizeGame; j++){
            //if there are no titleItems at this spot push(0) to the row, else push the titleIndex value
            if(tileItems[j + index * gridSizeGame] === null){
                row.push(0)
            }
            else{
                row.push(tileItems[j + index * gridSizeGame].tileValue)
            }
        }
        return row
    }
    function moveLeft(){
        var sourceRow, mergedRow, merger
        for(var i = 0; i < gridSizeGame; i++){
            sourceRow = getRowAt(i)
            merger = merge(sourceRow)
            mergedRow = merger.mergedRow
            console.log(mergedRow)
        }
    }
    function moveRight(){
        var sourceRow, mergedRow, merger
        for(var i = 0; i < gridSizeGame; i++){
            sourceRow = getRowAt(i).reverse()
            merger = merge(sourceRow)
            mergedRow = merger.mergedRow
            mergedRow.reverse()
            console.log(mergedRow)
        }
    }
}
