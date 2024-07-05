%dw 2.0
output application/json

var body = payload.you.body
var board = payload.board
var head = body[0] // First body part is always head
var neck = body[1] // Second body part is always neck

var moves = ["up", "down", "left", "right"]

// Step 0: Find my neck location so I don't eat myself
var myNeckLocation = neck match {
	case neck if neck.x < head.x -> "left" //my neck is on the left of my head
	case neck if neck.x > head.x -> "right" //my neck is on the right of my head
	case neck if neck.y < head.y -> "down" //my neck is below my head
	case neck if neck.y > head.y -> "up"	//my neck is above my head
	else -> ''
}

// TODO: Step 1 - Don't hit walls.
// Use information from `board` and `head` to not move beyond the game board.

// TODO: Step 2 - Don't hit yourself.
// Use information from `body` to avoid moves that would collide with yourself.

// TODO: Step 3 - Don't collide with others.
// Use information from `payload` to prevent your Battlesnake from colliding with others.

// TODO: Step 4 - Find food.
// Use information in `payload` to seek out and find food.
// food = board.food


// Find safe moves by eliminating neck location and any other locations computed in above steps
var safeMoves = moves - myNeckLocation // - remove other dangerous locations
// Next random move from safe moves
fun removerCaminho(mover) = (safeMoves-mover)[randomInt(sizeOf(safeMoves-mover))]
fun removerDoisCaminhos(mover1, mover2) = (safeMoves-mover1-mover2)[randomInt(sizeOf(safeMoves-mover1-mover2))]

fun validaPosicao(mover) = 
if(head.x == 10 and head.y == 10) removerDoisCaminhos("up","right") 
else if (head.x == 0 and head.y == 0) removerDoisCaminhos("down","left")
else naoBater(mover)

var nextMove = validaPosicao((safeMoves)[randomInt(sizeOf(safeMoves))])

fun naoBater(mover) = 
if (head.x == 10) removerCaminho("up")
else if(head.x == 0) removerCaminho("down") 
else nextMove


---
{
    move: nextMove,
	shout: "Moving $(nextMove)"
}