import bumpy, chroma, common, pixie/demo, vmath

var
  a: seq[Vec2]
  b: seq[Vec2]

b.add(vec2(200, 100))
b.add(vec2(400, 130))
b.add(vec2(350, 300))
b.add(vec2(250, 330))

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  let mousePos = getMousePos()
  a.setLen(0)
  a.add(vec2(-20, -10) + mousePos)
  a.add(vec2(-30, -49) + mousePos)
  a.add(vec2(40, 60) + mousePos)
  a.add(vec2(30, 70) + mousePos)
  screen.fillPoly(a, parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(a, b):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  color.a = 0.75
  screen.fillPoly(b, color)

  tick()
