%dw 2.0
output application/json
import * from dw::Common

var body = payload.you.body

var board = payload.board
var head = body[0] // First body part is always head
var neck = body[1] // Second body part is always neck
var food = board.food // Comida

fun getSafeMoves(move):Moves = do {
    var wallsMoves:Moves = [
        (down) if head.y == 0,
        (up) if head.y == (board.width - 1),
        (left) if head.x == 0,
        (right) if head.x == (board.height - 1)
    ]
    var snake:Moves = [
        (up) if body contains { x: head.x, y: head.y+1} ,
        (down) if body contains {x: head.x, y: head.y-1},
        (right) if body contains {x: head.x+1, y: head.y},
        (left) if body contains {x: head.x-1, y: head.y}
    ] 
    ---
    allMoves -- wallsMoves -- snake
}

var findNearFood = do {
    fun calcularDistancia(ponto1, ponto2) =
        abs(ponto1.x - ponto2.x) + abs(ponto1.y - ponto2.y)
    var distancias = food map ((item) -> {
        alimento: item,
        distancia: calcularDistancia(head, item)
    })
    var alimentoMaisProximo = distancias minBy ((item) -> item.distancia)
    ---
    alimentoMaisProximo[0]
}

var moveToFood = do {
    var nearFood = findNearFood
    var move = if(head.x > nearFood.x) "left"
    else if(head.x < nearFood.x)  "right" 
    else if(head.y > nearFood.y)  "down"
    else "up"
    ---
    move 
}

var safeMoves = if(getSafeMoves(moveToFood) contains moveToFood) moveToFood
else getSafeMoves(moveToFood)[0]
---
{
    move: safeMoves,
	shout: "Moving $(safeMoves)"
}