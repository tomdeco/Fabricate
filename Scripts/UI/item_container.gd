extends Container

var SLOT_WIDTH = 64
var SLOT_SIZE = Vector2(SLOT_WIDTH, SLOT_WIDTH)

# All available inventory slots, represented as a Rect2
var slot_rects = {
	"0": Rect2(Vector2(0 * SLOT_WIDTH, 0 * SLOT_WIDTH), SLOT_SIZE), "1": Rect2(Vector2(1 * SLOT_WIDTH, 0 * SLOT_WIDTH), SLOT_SIZE), "2": Rect2(Vector2(2 * SLOT_WIDTH, 0 * SLOT_WIDTH), SLOT_SIZE), "3": Rect2(Vector2(3 * SLOT_WIDTH, 0 * SLOT_WIDTH), SLOT_SIZE),
	"4": Rect2(Vector2(0 * SLOT_WIDTH, 1 * SLOT_WIDTH), SLOT_SIZE), "5": Rect2(Vector2(1 * SLOT_WIDTH, 1 * SLOT_WIDTH), SLOT_SIZE), "6": Rect2(Vector2(2 * SLOT_WIDTH, 1 * SLOT_WIDTH), SLOT_SIZE), "7": Rect2(Vector2(3 * SLOT_WIDTH, 1 * SLOT_WIDTH), SLOT_SIZE),
	"8": Rect2(Vector2(0 * SLOT_WIDTH, 2 * SLOT_WIDTH), SLOT_SIZE), "9": Rect2(Vector2(1 * SLOT_WIDTH, 2 * SLOT_WIDTH), SLOT_SIZE), "10": Rect2(Vector2(2 * SLOT_WIDTH, 2 * SLOT_WIDTH), SLOT_SIZE), "11": Rect2(Vector2(3 * SLOT_WIDTH, 2 * SLOT_WIDTH), SLOT_SIZE),

}

# Track which slots are occupied by an item. All empty by default
var slot_empty_states = {
	"0": true, 	"1": true, 
	"2": true, 	"3": true, 
	"4": true, 	"5": true, 
	"6": true, 	"7": true, 
	"8": true, 	"9": true,
	"10": true, "11": true
}

var MAX_STORAGE = slot_rects.size()
