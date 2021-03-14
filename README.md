# Bumpy - 2d collision library for nim.

`nimble install bumpy`

Based on the book http://www.jeffreythompson.org/collision-detection/table_of_contents.php


Supported collisions:

Shape         | Point         | Circle        | Rectangle     | Segment       | Polygon       | Line          |
------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
Point         | ✅           | ✅            | ✅           | ✅            | ✅           | ✅            |
Circle        | ✅           | ✅            | ✅           | ✅            | ✅           |               |
Rectangle     | ✅           | ✅            | ✅           | ✅            | ✅           |               |
Segment       | ✅           | ✅            | ✅           | ✅            | ✅           | ✅            |
Polygon       | ✅           | ✅            | ✅           | ✅            | ✅           |               |
Line          | ✅           |                |               | ✅            |              | ✅            |


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

## **proc** overlaps

Test overlap: point vs point. (Must be exactly equal.)

```nim
proc overlaps(a, b: Vec2): bool {.inline.}
```

## **proc** overlaps

Test overlap: point vs circle.

```nim
proc overlaps(a: Vec2; b: Circle): bool {.inline.}
```

## **proc** overlaps

Test overlap: circle vs point.

```nim
proc overlaps(a: Circle; b: Vec2): bool {.inline.}
```

## **proc** overlaps

Test overlap: circle vs circle.

```nim
proc overlaps(a, b: Circle): bool
```

## **proc** overlaps

Test overlap: point vs rectangle.

```nim
proc overlaps(a: Vec2; b: Rect): bool
```

## **proc** overlaps

Test overlap: rect vs point.

```nim
proc overlaps(a: Rect; b: Vec2): bool {.inline.}
```

## **proc** overlaps

Test overlap: rect vs rect.

```nim
proc overlaps(a, b: Rect): bool
```

## **proc** overlaps

Test overlap: circle vs rectangle.

```nim
proc overlaps(a: Circle; b: Rect): bool
```

## **proc** overlaps

Test overlap: rect vs circle.

```nim
proc overlaps(a: Rect; b: Circle): bool {.inline.}
```

## **proc** overlaps

Test overlap: point vs segment.

```nim
proc overlaps(a: Vec2; s: Segment; buffer = 0.1): bool
```

## **proc** overlaps

Test overlap: segment vs point.

```nim
proc overlaps(a: Segment; b: Vec2; buffer = 0.1): bool {.inline, tags: [].}
```

## **proc** overlaps

Test overlap: circle vs segment.

```nim
proc overlaps(c: Circle; s: Segment): bool
```

## **proc** overlaps

Test overlap: circle vs segment.

```nim
proc overlaps(s: Segment; c: Circle): bool {.inline.}
```

## **proc** overlaps

Test overlap: segment vs segment.

```nim
proc overlaps(d, s: Segment): bool
```

## **proc** overlaps

Test overlap: segments vs rectangle.

```nim
proc overlaps(s: Segment; r: Rect): bool
```

## **proc** overlaps

Test overlap: rectangle vs segment.

```nim
proc overlaps(r: Rect; s: Segment): bool {.inline.}
```

## **proc** overlapsTri

Optimization for triangles:

```nim
proc overlapsTri(tri: seq[Vec2]; p: Vec2): bool
```

## **proc** overlaps

Test overlap: polygon vs point.

```nim
proc overlaps(poly: seq[Vec2]; p: Vec2): bool
```

## **proc** overlaps

Test overlap: point vs polygon.

```nim
proc overlaps(p: Vec2; poly: seq[Vec2]): bool {.inline.}
```

## **proc** overlaps

Test overlap: polygon vs circle.

```nim
proc overlaps(poly: seq[Vec2]; c: Circle): bool
```

## **proc** overlaps

Test overlap: circle vs polygon.

```nim
proc overlaps(c: Circle; poly: seq[Vec2]): bool {.inline.}
```

## **proc** overlaps

Test overlap: polygon vs rect.

```nim
proc overlaps(poly: seq[Vec2]; r: Rect): bool
```

## **proc** overlaps

Test overlap: rect vs polygon.

```nim
proc overlaps(r: Rect; poly: seq[Vec2]): bool {.inline.}
```

## **proc** overlaps

Test overlap: polygon vs segment.

```nim
proc overlaps(poly: seq[Vec2]; s: Segment): bool
```

## **proc** overlaps

Test overlap: segment vs polygon.

```nim
proc overlaps(s: Segment; poly: seq[Vec2]): bool {.inline.}
```

## **proc** overlaps

Test overlap: polygon vs polygon.

```nim
proc overlaps(a: seq[Vec2]; b: seq[Vec2]): bool
```

## **proc** overlaps

Test overlap: line vs line.

```nim
proc overlaps(a, b: Line): bool {.inline.}
```

## **proc** overlaps

Test overlap: line vs seg.

```nim
proc overlaps(l: Line; s: Segment): bool {.inline.}
```

## **proc** overlaps

Test overlap: seg vs line.

```nim
proc overlaps(s: Segment; l: Line): bool {.inline.}
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
