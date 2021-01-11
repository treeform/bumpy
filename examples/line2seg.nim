import bumpy, chroma, fidget, fidget/opengl/context, fidget/openglbackend, vmath

# The lines always overlap unless you get them to be perfectly parallel.

var
  l: Line
  s: Segment

l.a.x = 0
l.a.y = 100

proc drawMain() =
  s.at.x = 100
  s.at.y = 400
  s.to.x = windowFrame.x - 100
  s.to.y = 600

  l.b = mouse.pos

  let windowEdge = Line(
    a: vec2(windowFrame.x, 0),
    b: vec2(windowFrame.x, windowFrame.y)
  )

  var at: Vec2
  if intersects(windowEdge, l, at):
    ctx.line(l.a, at, parseHtmlColor("#2ecc71"))

  let color =
    if overlaps(l, s):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  ctx.line(s.at, s.to, color)

windowFrame = vec2(600, 600)
startFidget(drawMain)
