import bumpy, chroma, common, pixie/demo, vmath

var
  a: Circle
  b: Rect
a.radius = 50
b.x = 150
b.y = 200
b.w = 300
b.h = 200

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  a.pos = getMousePos()
  screen.fillCircle(a, parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(a, b): parseHtmlColor("#e74c3c")
    else: parseHtmlColor("#3498db")
  color.a = 0.75
  screen.fillRect(b, color)

  tick()
