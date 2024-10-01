%dw 2.0
output application/json

var body = payload.you.body

var board = payload.board
var head = body[0] // First body part is always head
var neck = body[1] // Second body part is always neck
var food = board.food // Comida

var moves = ["up", "down", "left", "right"]

// Step 0: Find my neck location so I don't eat myself
var myNeckLocation = neck match {
	case neck if neck.x < head.x -> "left" //my neck is on the left of my head
	case neck if neck.x > head.x -> "right" //my neck is on the right of my head
	case neck if neck.y < head.y -> "down" //my neck is below my head
	case neck if neck.y > head.y -> "up"	//my neck is above my head
	else -> ''
}

// TODO: Step 2 - Don't hit yourself.
// Use information from `body` to avoid moves that would collide with yourself.

// TODO: Step 3 - Don't collide with others.
// Use information from `payload` to prevent your Battlesnake from colliding with others.

// TODO: Step 4 - Find food.
// Use information in `payload` to seek out and find food.
// food = board.food

// Find safe moves by eliminating neck location and any other locations computed in above steps
var safeMoves = moves - myNeckLocation // - remove other dangerous locations

fun removerCaminho(mover) = (safeMoves-mover)[randomInt(sizeOf(safeMoves-mover))]
fun removerDoisCaminhos(mover1, mover2) = (safeMoves-mover1-mover2)[randomInt(sizeOf(safeMoves-mover1-mover2))]

//Não bater quando chegar nos cantos
fun naoBaterBoard(mover) = 
if (head.x == 10) removerCaminho("right")
else if(head.x == 0) removerCaminho("left") 
else if(head.y == 10) removerCaminho("up")
else if(head.y == 0) removerCaminho("down")
else (safeMoves)[randomInt(sizeOf(safeMoves))]

//Não bater quando chegar nas pontas
fun validaPosicaoBoard(mover) = 
if(head.x == 10 and head.y == 10) removerDoisCaminhos("up","right")
else if (head.x == 0 and head.y == 0) removerDoisCaminhos("down","left")
else naoBaterBoard(mover)

var proximidade = 1

var nextMove = validaPosicaoBoard((safeMoves)[randomInt(sizeOf(safeMoves))])

// Função para calcular a distância euclidiana entre dois pontos
fun euclideanDistance(p1, p2) = sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y))

// Encontrar o ponto mais próximo
var closestPoint = food reduce ((closest, current) -> 
  if (euclideanDistance(current, head) < euclideanDistance(closest, head)) 
    current 
  else 
    closest
) default food[0]
---
{
    terere: euclideanDistance(food[0], head),
    tiriri: closestPoint,
    move: nextMove,
	shout: "Moving $(nextMove)"
}