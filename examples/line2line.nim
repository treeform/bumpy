import bumpy, chroma, fidget, fidget/opengl/context, fidget/openglbackend, vmath

# The lines always overlap unless you get them to be perfectly parallel.

var
  a: Line
  b: Line

a.a.x = 0
a.a.y = 100

proc drawMain() =
  b.a.x = 0
  b.a.y = 400
  b.b.x = windowFrame.x
  b.b.y = 600

  a.b = mouse.pos

  let windowEdge = Line(
    a: vec2(windowFrame.x, 0),
    b: vec2(windowFrame.x, windowFrame.y)
  )

  var at: Vec2
  if intersects(windowEdge, a, at):
    ctx.line(a.a, at, parseHtmlColor("#2ecc71"))

  let color =
    if overlap(a, b):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  ctx.line(b.a, b.b, color)

windowFrame = vec2(600, 600)
startFidget(drawMain)
