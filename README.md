# Bumpy - 2d collision library for nim.

`nimble install bumpy`

Based on the book http://www.jeffreythompson.org/collision-detection/table_of_contents.php


Supported collisions:

Shape         | Point         | Circle        | Rectangle     | Segment       | Polygon       | Line          |
------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
Point         | ✅           | ✅            | ✅           | ✅            | ✅           |               |
Circle        | ✅           | ✅            | ✅           | ✅            | ✅           |               |
Rectangle     | ✅           | ✅            | ✅           | ✅            | ✅           |               |
Segment       | ✅           | ✅            | ✅           | ✅            | ✅           | ✅            |
Polygon       | ✅           | ✅            | ✅           | ✅            | ✅           |               |
Line          |              |                |               | ✅            |              | ✅            |


# API: bumpy

```nim
import bumpy
```

## **type** Circle


```nim
Circle = object
 pos*: Vec2
 radius*: float32
```

## **type** Segment


```nim
Segment = object
 at*: Vec2
 to*: Vec2
```

## **type** Rect


```nim
Rect = object
 x*: float32
 y*: float32
 w*: float32
 h*: float32
```

## **type** Line


```nim
Line = object
 a*: Vec2
 b*: Vec2
```

## **proc** rect


```nim
proc rect(x, y, w, h: float32): Rect {.inline.}
```

## **proc** rect


```nim
proc rect(pos, size: Vec2): Rect {.inline.}
```

## **proc** xy

Gets the xy as a Vec2.

```nim
proc xy(rect: Rect): Vec2 {.inline.}
```

## **proc** xy=

Sets the xy from Vec2.

```nim
proc xy=(rect: var Rect; v: Vec2) {.inline.}
```

## **proc** wh

Gets the wh as a Vec2.

```nim
proc wh(rect: Rect): Vec2 {.inline.}
```

## **proc** wh=

Sets the wh from Vec2.

```nim
proc wh=(rect: var Rect; v: Vec2) {.inline.}
```

## **proc** `*`

* all elements of a Rect.

```nim
proc `*`(r: Rect; v: float): Rect
```

## **proc** `/`

/ all elements of a Rect.

```nim
proc `/`(r: Rect; v: float): Rect
```

## **proc** `+`

Add two boxes together.

```nim
proc `+`(a, b: Rect): Rect
```

## **proc** `$`


```nim
proc `$`(a: Rect): string {.raises: [ValueError].}
```

## **proc** `or`

Union of two rectangles.

```nim
proc `or`(a, b: Rect): Rect
```

## **proc** `and`

Intersection of two rectangles.

```nim
proc `and`(a, b: Rect): Rect
```

## **proc** circle


```nim
proc circle(pos: Vec2; radius: float32): Circle {.inline.}
```

## **proc** segment


```nim
proc segment(at, to: Vec2): Segment {.inline.}
```

## **proc** overlap

Test overlap: point vs point. (Must be exactly equal.)

```nim
proc overlap(a, b: Vec2): bool {.inline.}
```

## **proc** overlap

Test overlap: point vs circle.

```nim
proc overlap(a: Vec2; b: Circle): bool {.inline.}
```

## **proc** overlap

Test overlap: circle vs point.

```nim
proc overlap(a: Circle; b: Vec2): bool {.inline.}
```

## **proc** overlap

Test overlap: circle vs circle.

```nim
proc overlap(a, b: Circle): bool
```

## **proc** overlap

Test overlap: point vs rectangle.

```nim
proc overlap(a: Vec2; b: Rect): bool
```

## **proc** overlap

Test overlap: rect vs point.

```nim
proc overlap(a: Rect; b: Vec2): bool {.inline.}
```

## **proc** overlap

Test overlap: rect vs rect.

```nim
proc overlap(a, b: Rect): bool
```

## **proc** overlap

Test overlap: circle vs rectangle.

```nim
proc overlap(a: Circle; b: Rect): bool
```

## **proc** overlap

Test overlap: rect vs circle.

```nim
proc overlap(a: Rect; b: Circle): bool {.inline.}
```

## **proc** overlap

Test overlap: point vs segment.

```nim
proc overlap(a: Vec2; s: Segment; buffer = 0.1): bool
```

## **proc** overlap

Test overlap: segment vs point.

```nim
proc overlap(a: Segment; b: Vec2; buffer = 0.1): bool {.inline, tags: [].}
```

## **proc** overlap

Test overlap: circle vs segment.

```nim
proc overlap(c: Circle; s: Segment): bool
```

## **proc** overlap

Test overlap: circle vs segment.

```nim
proc overlap(s: Segment; c: Circle): bool {.inline.}
```

## **proc** overlap

Test overlap: segment vs segment.

```nim
proc overlap(d, s: Segment): bool
```

## **proc** overlap

Test overlap: segments vs rectangle.

```nim
proc overlap(s: Segment; r: Rect): bool
```

## **proc** overlap

Test overlap: rectangle vs segment.

```nim
proc overlap(r: Rect; s: Segment): bool {.inline.}
```

## **proc** overlapTri

Optimization for triangles:

```nim
proc overlapTri(tri: seq[Vec2]; p: Vec2): bool
```

## **proc** overlap

Test overlap: polygon vs point.

```nim
proc overlap(poly: seq[Vec2]; p: Vec2): bool
```

## **proc** overlap

Test overlap: point vs polygon.

```nim
proc overlap(p: Vec2; poly: seq[Vec2]): bool {.inline.}
```

## **proc** overlap

Test overlap: polygon vs circle.

```nim
proc overlap(poly: seq[Vec2]; c: Circle): bool
```

## **proc** overlap

Test overlap: circle vs polygon.

```nim
proc overlap(c: Circle; poly: seq[Vec2]): bool {.inline.}
```

## **proc** overlap

Test overlap: polygon vs rect.

```nim
proc overlap(poly: seq[Vec2]; r: Rect): bool
```

## **proc** overlap

Test overlap: rect vs polygon.

```nim
proc overlap(r: Rect; poly: seq[Vec2]): bool {.inline.}
```

## **proc** overlap

Test overlap: polygon vs segment.

```nim
proc overlap(poly: seq[Vec2]; s: Segment): bool
```

## **proc** overlap

Test overlap: segment vs polygon.

```nim
proc overlap(s: Segment; poly: seq[Vec2]): bool {.inline.}
```

## **proc** overlap

Test overlap: polygon vs polygon.

```nim
proc overlap(a: seq[Vec2]; b: seq[Vec2]): bool
```

## **proc** overlap

Test overlap: line vs line.

```nim
proc overlap(a, b: Line): bool {.inline.}
```

## **proc** overlap

Test overlap: line vs seg.

```nim
proc overlap(l: Line; s: Segment): bool {.inline.}
```

## **proc** overlap

Test overlap: seg vs line.

```nim
proc overlap(s: Segment; l: Line): bool {.inline.}
```

## **proc** intersects

Checks if the a segment intersects b segment. If it returns true, at will have point of intersection

```nim
proc intersects(a, b: Segment; at: var Vec2): bool {.inline, tags: [].}
```

## **proc** intersects


```nim
proc intersects(a, b: Line; at: var Vec2): bool {.inline.}
```

## **proc** intersects

Checks if the line intersects the segment. If it returns true, at will have point of intersection

```nim
proc intersects(l: Line; s: Segment; at: var Vec2): bool {.inline, tags: [].}
```

## **proc** intersects

Checks if the line intersects the segment. If it returns true, at will have point of intersection

```nim
proc intersects(s: Segment; l: Line; at: var Vec2): bool {.inline, tags: [].}
```
