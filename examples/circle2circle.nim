import bumpy, common, pixie/demo, vmath, chroma

var
  a: Circle
  b: Circle
a.radius = 100
b.pos.x = 300
b.pos.y = 300
b.radius = 50

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  a.pos = getMousePos()
  screen.fillCircle(a, parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(a, b): parseHtmlColor("#e74c3c")
    else: parseHtmlColor("#3498db")
  color.a = 0.75
  screen.fillCircle(b, color)

  tick()
