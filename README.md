# Bumpy - 2d collision library for nim.

Based on the book http://www.jeffreythompson.org/collision-detection/table_of_contents.php


Supported collisions:

Shape         | Point         | Circle        | Rectangle     | Segment       | Polygon       |
------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
Point         | ✅           | ✅            | ✅           | ✅            | ✅           |
Circle        | ✅           | ✅            | ✅           | ✅            | ✅           |
Rectangle     | ✅           | ✅            | ✅           | ✅            | ✅           |
Segment       | ✅           | ✅            | ✅           | ✅            | ✅           |
Polygon       | ✅           | ✅            | ✅           | ✅            | ✅           |


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
 a*: Vec2
 b*: Vec2
```

## **proc** circle


```nim
proc circle(pos: Vec2; radius: float32): Circle
```

## **proc** segment


```nim
proc segment(a, b: Vec2): Segment
```

## **proc** overlap

Do two points overlap? (Must be exactly equal.)

```nim
proc overlap(a, b: Vec2): bool
```

## **proc** overlap

Test overlap: point vs circle.

```nim
proc overlap(a: Vec2; b: Circle): bool
```

## **proc** overlap

Test overlap: circle vs point.

```nim
proc overlap(a: Circle; b: Vec2): bool
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
proc overlap(a: Rect; b: Vec2): bool
```

## **proc** overlap

Do two rectangles overlap?

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
proc overlap(a: Rect; b: Circle): bool
```

## **proc** overlap

Test overlap: point vs segment.

```nim
proc overlap(a: Vec2; s: Segment; buffer = 0.1): bool
```

## **proc** overlap

Test overlap: segment vs point.

```nim
proc overlap(a: Segment; b: Vec2; buffer = 0.1): bool
```

## **proc** overlap

Test overlap: circle vs segment.

```nim
proc overlap(c: Circle; s: Segment): bool
```

## **proc** overlap

Test overlap: circle vs segment.

```nim
proc overlap(s: Segment; c: Circle): bool
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
proc overlap(r: Rect; s: Segment): bool
```

## **proc** overlap

Test overlap: polygon vs point.

```nim
proc overlap(poly: seq[Vec2]; p: Vec2): bool
```

## **proc** overlap

Test overlap: point vs polygon.

```nim
proc overlap(p: Vec2; poly: seq[Vec2]): bool
```

## **proc** overlap

Test overlap: polygon vs circle.

```nim
proc overlap(poly: seq[Vec2]; c: Circle): bool
```

## **proc** overlap

Test overlap: circle vs polygon.

```nim
proc overlap(c: Circle; poly: seq[Vec2]): bool
```

## **proc** overlap

Test overlap: polygon vs rect.

```nim
proc overlap(poly: seq[Vec2]; r: Rect): bool
```

## **proc** overlap

Test overlap: rect vs polygon.

```nim
proc overlap(r: Rect; poly: seq[Vec2]): bool
```

## **proc** overlap

Test overlap: polygon vs segment.

```nim
proc overlap(poly: seq[Vec2]; s: Segment): bool
```

## **proc** overlap

Test overlap: segment vs polygon.

```nim
proc overlap(s: Segment; poly: seq[Vec2]): bool
```

## **proc** overlap

Test overlap: polygon vs segment.

```nim
proc overlap(a: seq[Vec2]; b: seq[Vec2]): bool
```
