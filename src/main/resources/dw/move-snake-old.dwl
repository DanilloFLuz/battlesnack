%dw 2.0
output application/json

var body = payload.you.body

var board = payload.board
var head = body[0] // First body part is always head
var neck = body[1] // Second body part is always neck
var food = board.food // Comida

var moves = ["up", "down", "left", "right"]

var findNearFood = do {
    fun calcularDistancia(ponto1, ponto2) =
        abs(ponto1.x - ponto2.x) + abs(ponto1.y - ponto2.y)

    var distancias = food map ((item) -> {
        alimento: item,
        distancia: calcularDistancia(head, item)
    })

    var alimentoMaisProximo = distancias minBy ((item) -> item.distancia)
    ---
    alimentoMaisProximo
}

var moveToFood = do {
    var food = findNearFood[0]
    var move = if(head.x > food.x) "left"
    else if(head.x < food.x)  "right" 
    else if(head.y > food.y)  "down"
    else "up"
    ---
    move 
}

---
{
    move: moveToFood,
	shout: "Moving $(moveToFood)"
}